import json
import logging
import re
from contextlib import contextmanager
from typing import Any, Dict, List, Optional

from deribit.consts import excluded_urls, matching_engine_endpoints
from models.models import Endpoint, EnumDefinition, Field, Function, TypeDefinition

logger = logging.getLogger(__name__)

SPEC_BASE_URL = "https://docs.deribit.com/specifications/split"
PRIMITIVE_TYPE_NAMES = {
    "number or string",
    "string",
    "text",
    "float",
    "number",
    "decimal",
    "integer",
    "boolean",
    "object",
    "json",
    "timestamp",
    "map",
    "float[]",
}


def _default_response_type(end_point: str) -> TypeDefinition:
    parent_type_name = f"{_url_to_type_name(end_point)}_response"
    def_res_type = TypeDefinition(parent_type_name)
    def_res_type.is_primitive = True
    def_res_type.fields.append(Field(name="id", type=TypeDefinition(name="integer")))
    def_res_type.fields.append(Field(name="jsonrpc", type=TypeDefinition(name="string")))
    return def_res_type


def _section_to_spec_name(section: str) -> str:
    return re.sub(r"[^a-z0-9_]+", "_", section.lower()).strip("_")


def _url_to_type_name(end_point: str) -> str:
    items = end_point.split("/")
    return "_".join(items[1:])


def _get_singular_type_name(parent_type_name: str, field_name: str) -> str:
    try:
        import inflect

        engine = inflect.engine()
        singular = engine.singular_noun(field_name)
        if singular is False:
            singular = field_name
    except Exception:
        singular = field_name[:-1] if field_name.endswith("s") else field_name

    return f"{parent_type_name}_{singular}"


def _clean_markdown(text: str) -> str:
    if not text:
        return ""
    # Replace markdown links with their label.
    text = re.sub(r"\[([^\]]+)\]\([^)]+\)", r"\1", text)
    # Drop backticks and emphasis markers.
    text = text.replace("`", "")
    text = text.replace("**", "")
    text = text.replace("*", "")
    # Collapse whitespace/newlines.
    return " ".join(text.split()).strip()


def _first_sentence(text: str) -> str:
    if not text:
        return ""
    stripped = text.strip()
    return stripped.split("\n")[0].strip()


def _download_spec(spec_name: str) -> Optional[Dict[str, Any]]:
    url = f"{SPEC_BASE_URL}/{spec_name}_openapi.json"
    try:
        import requests
    except ImportError as exc:
        logger.error("requests is required to download specs: %s", exc)
        return None

    try:
        response = requests.get(url, timeout=30)
        response.raise_for_status()
        return response.json()
    except requests.RequestException as exc:
        logger.error("Failed to download spec %s: %s", spec_name, exc)
    except json.JSONDecodeError as exc:
        logger.error("Failed to decode spec %s: %s", spec_name, exc)
    return None


class OpenAPIResponseParser:
    def __init__(self, components: Dict[str, Any]):
        self.components = components
        self.types: Dict[str, TypeDefinition] = {}
        self.response_type: Optional[TypeDefinition] = None
        self.parent_type_name = ""
        self._ref_stack: List[str] = []

    def parse(
        self, endpoint: str, schema: Optional[Dict[str, Any]]
    ) -> tuple[TypeDefinition, Optional[TypeDefinition], List[TypeDefinition]]:
        self.types = {}
        self.response_type = None
        self.parent_type_name = f"{_url_to_type_name(endpoint)}_response"
        root_type = TypeDefinition(self.parent_type_name)
        self.types[self.parent_type_name] = root_type

        if schema is None:
            root_type = _default_response_type(endpoint)
            return root_type, None, [root_type]

        resolved = self._resolve_schema(schema)
        if not self._is_object_schema(resolved):
            logger.warning("Unexpected response schema for %s: %s", endpoint, resolved)
            root_type = _default_response_type(endpoint)
            return root_type, None, [root_type]

        self._populate_object_fields(root_type, resolved, self.parent_type_name)
        return root_type, self.response_type, list(self.types.values())

    def _populate_object_fields(
        self, target: TypeDefinition, schema: Dict[str, Any], parent_type_name: str
    ) -> None:
        properties = schema.get("properties", {})
        for field_name in sorted(properties.keys()):
            field_schema = properties[field_name]
            resolved_schema = self._resolve_schema(field_schema)
            comment = _clean_markdown(
                field_schema.get("description", "") or resolved_schema.get("description", "")
            )
            field_type = self._field_type_for_schema(
                field_name, field_schema, parent_type_name
            )
            target.fields.append(
                Field(name=field_name, type=field_type, documentation=comment, required=False)
            )

    def _field_type_for_schema(
        self, field_name: str, field_schema: Dict[str, Any], parent_type_name: str
    ) -> TypeDefinition:
        ref_name = self._extract_ref_name(field_schema)
        with self._ref_guard(ref_name) as is_recursive:
            if is_recursive:
                return self._recursive_fallback(field_name, field_schema.get("type") == "array")

            resolved = self._resolve_schema(field_schema)

            if self._is_object_schema(resolved):
                return self._handle_object(field_name, resolved, parent_type_name)

            if resolved.get("type") == "array":
                return self._handle_array(field_name, resolved, parent_type_name)

            return self._handle_primitive(field_name, resolved)

    def _handle_object(
        self, field_name: str, schema: Dict[str, Any], parent_type_name: str
    ) -> TypeDefinition:
        if not schema.get("properties"):
            type_def = TypeDefinition(name="json")
            if field_name == "result":
                response_type = TypeDefinition(name="json")
                response_type.is_primitive = True
                self.response_type = response_type
            return type_def

        type_name = f"{self.parent_type_name}_{field_name}"
        field_type = TypeDefinition(type_name)

        nested_type = TypeDefinition(type_name)
        self.types[type_name] = nested_type
        self._populate_object_fields(nested_type, schema, type_name)

        if field_name == "result":
            self.response_type = nested_type

        return field_type

    def _handle_array(
        self, field_name: str, schema: Dict[str, Any], parent_type_name: str
    ) -> TypeDefinition:
        items_schema = schema.get("items", {})
        ref_name = self._extract_ref_name(items_schema)
        with self._ref_guard(ref_name) as is_recursive:
            if is_recursive:
                return self._recursive_fallback(field_name, is_array=True)

            items = self._resolve_schema(items_schema)

            if self._is_timestamp_value_object(items):
                type_name = _get_singular_type_name(self.parent_type_name, field_name)
                field_type = TypeDefinition(name="float[]")
                field_type.is_array = True

                nested_type = TypeDefinition(type_name)
                nested_type.is_array = True
                nested_type.is_nested_array = True
                nested_type.fields.append(Field(name="timestamp", type=TypeDefinition("integer")))
                nested_type.fields.append(Field(name="value", type=TypeDefinition("number")))
                self.types[type_name] = nested_type

                if field_name == "result":
                    self.response_type = nested_type

                return field_type

            if self._is_object_schema(items):
                type_name = _get_singular_type_name(self.parent_type_name, field_name)
                field_type = TypeDefinition(type_name)
                field_type.is_array = True

                nested_type = TypeDefinition(type_name)
                nested_type.is_array = True
                self.types[type_name] = nested_type
                self._populate_object_fields(nested_type, items, type_name)

                if field_name == "result":
                    self.response_type = nested_type

                return field_type

            if items.get("type") == "array":
                field_type = TypeDefinition(name="float[]")
                field_type.is_array = True
                return field_type

            primitive_name = self._primitive_name(items)
            field_type = TypeDefinition(name=primitive_name)
            field_type.is_array = True

            if field_name == "result":
                response_type = TypeDefinition(name=primitive_name)
                response_type.is_array = True
                response_type.is_primitive = True
                self.response_type = response_type

            return field_type

    def _handle_primitive(self, field_name: str, schema: Dict[str, Any]) -> TypeDefinition:
        primitive_name = self._primitive_name(schema)
        field_type = TypeDefinition(name=primitive_name)

        if field_name == "result":
            response_type = TypeDefinition(name=primitive_name)
            response_type.is_primitive = True
            self.response_type = response_type

        return field_type

    def _primitive_name(self, schema: Dict[str, Any]) -> str:
        type_name = schema.get("type")
        if not type_name and "enum" in schema:
            type_name = "string"
        if not type_name:
            type_name = "string"
        if type_name == "text":
            type_name = "string"
        return type_name

    def _is_object_schema(self, schema: Dict[str, Any]) -> bool:
        return schema.get("type") == "object" or "properties" in schema

    def _is_timestamp_value_object(self, schema: Dict[str, Any]) -> bool:
        if not self._is_object_schema(schema):
            return False
        props = schema.get("properties", {})
        return set(props.keys()) == {"timestamp", "value"}

    def _resolve_schema(
        self, schema: Dict[str, Any], seen_refs: Optional[set[str]] = None
    ) -> Dict[str, Any]:
        if not schema:
            return {}

        if seen_refs is None:
            seen_refs = set()

        if "$ref" in schema:
            ref_name = schema["$ref"].split("/")[-1]
            if ref_name in seen_refs:
                logger.warning("Detected circular $ref for %s", ref_name)
                return {}
            seen_refs.add(ref_name)
            return self._resolve_schema(
                self.components.get("schemas", {}).get(ref_name, {}), seen_refs
            )

        if "allOf" in schema:
            return self._merge_allof(schema["allOf"], seen_refs)

        return schema

    def _extract_ref_name(self, schema: Dict[str, Any]) -> Optional[str]:
        if not schema:
            return None
        ref = schema.get("$ref")
        if not ref:
            return None
        return ref.split("/")[-1]

    @contextmanager
    def _ref_guard(self, ref_name: Optional[str]):
        if not ref_name:
            yield False
            return
        if ref_name in self._ref_stack:
            logger.warning("Detected recursive schema reference to %s", ref_name)
            yield True
            return
        self._ref_stack.append(ref_name)
        try:
            yield False
        finally:
            self._ref_stack.pop()

    def _recursive_fallback(self, field_name: str, is_array: bool) -> TypeDefinition:
        fallback_type = TypeDefinition(name="json")
        fallback_type.is_primitive = True
        fallback_type.is_array = is_array
        if field_name == "result":
            response_type = TypeDefinition(name="json")
            response_type.is_primitive = True
            response_type.is_array = is_array
            self.response_type = response_type
        return fallback_type


    def _merge_allof(
        self, schemas: List[Dict[str, Any]], seen_refs: set[str]
    ) -> Dict[str, Any]:
        merged: Dict[str, Any] = {"type": "object", "properties": {}, "required": []}
        for entry in schemas:
            resolved = self._resolve_schema(entry, seen_refs)
            merged["properties"].update(resolved.get("properties", {}))
            merged["required"].extend(resolved.get("required", []))
        return merged


def _request_type_from_parameters(
    endpoint: str, parameters: List[Dict[str, Any]], components: Dict[str, Any]
) -> Optional[TypeDefinition]:
    if not parameters:
        return None

    request_type = TypeDefinition(name=f"{_url_to_type_name(endpoint)}_request")
    for param in parameters:
        schema = param.get("schema", {})
        if "$ref" in schema:
            ref_name = schema["$ref"].split("/")[-1]
            schema = components.get("schemas", {}).get(ref_name, {})

        required = bool(param.get("required"))
        comment = _clean_markdown(param.get("description", ""))

        if _is_json_string_schema(schema, comment):
            type_def = TypeDefinition(name="json")
            type_def.is_primitive = True
            request_type.fields.append(
                Field(name=param["name"], type=type_def, documentation=comment, required=required)
            )
            continue

        array_items_schema = _extract_array_items_schema(schema, components)
        enum_items = _extract_enum_items(schema, components)
        if enum_items:
            enum_values = sorted({str(item) for item in enum_items})
            request_type.enums.append(
                EnumDefinition(
                    type_name=param["name"],
                    items=enum_values,
                )
            )
            type_def = TypeDefinition(name=param["name"])
            type_def.is_enum = True
            type_def.is_primitive = True
            type_def.is_array = schema.get("type") == "array" or array_items_schema is not None
            type_def.enum_items = enum_values
        elif array_items_schema is not None:
            type_def = TypeDefinition(name=_primitive_name_for_request(array_items_schema))
            type_def.is_array = True
            type_def.is_primitive = True
        else:
            type_def = TypeDefinition(name=_primitive_name_for_request(schema))
            type_def.is_primitive = True

        if not enum_items and schema.get("type") == "array":
            type_def = TypeDefinition(name=_primitive_name_for_request(schema.get("items", {})))
            type_def.is_array = True
            type_def.is_primitive = True

        request_type.fields.append(
            Field(name=param["name"], type=type_def, documentation=comment, required=required)
        )

    return request_type


def _primitive_name_for_request(schema: Dict[str, Any]) -> str:
    if "$ref" in schema:
        return "string"
    type_name = schema.get("type", "string")
    if type_name == "text":
        type_name = "string"
    return type_name


def _is_json_string_schema(schema: Dict[str, Any], description: str) -> bool:
    if not schema or schema.get("type") != "string":
        return False
    schema_description = schema.get("description", "")
    combined = " ".join(filter(None, [description, schema_description]))
    return "json string" in combined.lower()


def _extract_enum_items(
    schema: Dict[str, Any],
    components: Dict[str, Any],
    seen_refs: Optional[set[str]] = None,
) -> List[Any]:
    if not schema:
        return []
    if seen_refs is None:
        seen_refs = set()

    if "$ref" in schema:
        ref_name = schema["$ref"].split("/")[-1]
        if ref_name in seen_refs:
            return []
        seen_refs.add(ref_name)
        return _extract_enum_items(
            components.get("schemas", {}).get(ref_name, {}), components, seen_refs
        )

    enums: List[Any] = []
    if "enum" in schema:
        enums.extend(schema.get("enum", []))

    for key in ("oneOf", "anyOf", "allOf"):
        for entry in schema.get(key, []):
            enums.extend(_extract_enum_items(entry, components, seen_refs))

    if schema.get("type") == "array":
        enums.extend(_extract_enum_items(schema.get("items", {}), components, seen_refs))

    return enums


def _extract_array_items_schema(
    schema: Dict[str, Any],
    components: Dict[str, Any],
    seen_refs: Optional[set[str]] = None,
) -> Optional[Dict[str, Any]]:
    if not schema:
        return None
    if seen_refs is None:
        seen_refs = set()

    if "$ref" in schema:
        ref_name = schema["$ref"].split("/")[-1]
        if ref_name in seen_refs:
            return None
        seen_refs.add(ref_name)
        return _extract_array_items_schema(
            components.get("schemas", {}).get(ref_name, {}), components, seen_refs
        )

    if schema.get("type") == "array":
        return schema.get("items", {})

    for key in ("oneOf", "anyOf", "allOf"):
        for entry in schema.get(key, []):
            items_schema = _extract_array_items_schema(entry, components, seen_refs)
            if items_schema is not None:
                return items_schema

    return None


def _select_operation(methods: Dict[str, Any]) -> Optional[Dict[str, Any]]:
    if not methods:
        return None
    if "get" in methods:
        return methods["get"]
    if "post" in methods:
        return methods["post"]
    return next(iter(methods.values()), None)


def _select_response_schema(
    responses: Dict[str, Any], components: Dict[str, Any]
) -> Optional[Dict[str, Any]]:
    if not responses:
        return None
    response = responses.get("200")
    if response is None:
        for key in sorted(responses.keys()):
            if str(key).startswith("2"):
                response = responses[key]
                break
    if response is None:
        return None

    if "$ref" in response:
        ref_name = response["$ref"].split("/")[-1]
        response = components.get("responses", {}).get(ref_name, response)

    content = response.get("content", {})
    if not content:
        return None
    media = content.get("application/json")
    if media is None:
        media = next(iter(content.values()), None)
    if not media:
        return None
    return media.get("schema")


def load_endpoints_from_openapi(sections: List[str]) -> List[Function]:
    endpoints: List[Function] = []
    for section in sections:
        spec_name = _section_to_spec_name(section)
        spec = _download_spec(spec_name)
        if not spec:
            continue

        components = spec.get("components", {})
        parser = OpenAPIResponseParser(components)

        for path, methods in spec.get("paths", {}).items():
            operation = _select_operation(methods)
            if not operation:
                continue

            endpoint_name = _url_to_type_name(path)
            if endpoint_name in excluded_urls:
                logger.debug("%s: skipping due to %s", endpoint_name, excluded_urls[endpoint_name])
                continue

            description = _first_sentence(operation.get("description") or operation.get("summary") or "")
            comment = _clean_markdown(description)

            parameters = list(operation.get("parameters", []))
            request_type = _request_type_from_parameters(path, parameters, components)

            response_schema = _select_response_schema(operation.get("responses", {}), components)
            root_type, response_type, all_types = parser.parse(path, response_schema)
            _apply_snapshot_class_flags(request_type, all_types, response_type)

            rate_limiter = (
                "matching_engine_request_log_call"
                if endpoint_name in matching_engine_endpoints
                else "non_matching_engine_request_log_call"
            )

            requires_auth = not path.startswith("/public/")

            function = Function(
                name=endpoint_name,
                endpoint=Endpoint(
                    name=endpoint_name,
                    path=path,
                    request_type=request_type,
                    response_type=root_type,
                    response_types=all_types,
                    rate_limiter=rate_limiter,
                ),
                comment=comment,
                response_type=response_type,
                requires_auth=requires_auth,
            )

            endpoints.append(function)

    return endpoints


def load_endpoints_from_snapshot(snapshot_path: str) -> List[Function]:
    with open(snapshot_path, "r", encoding="utf-8") as file:
        snapshot = json.load(file)

    functions: List[Function] = []
    for entry in snapshot:
        endpoint = entry["endpoint"]
        request_type = (
            _type_definition_from_dict(endpoint["request_type"])
            if endpoint["request_type"] is not None
            else None
        )
        response_type = (
            _type_definition_from_dict(endpoint["response_type"])
            if endpoint["response_type"] is not None
            else None
        )
        response_types = [
            _type_definition_from_dict(type_dict) for type_dict in endpoint["response_types"]
        ]

        function = Function(
            name=entry["name"],
            endpoint=Endpoint(
                name=endpoint["name"],
                path=endpoint["path"],
                request_type=request_type,
                response_type=response_type,
                response_types=response_types,
                rate_limiter=endpoint["rate_limiter"],
            ),
            comment=entry.get("comment", ""),
            response_type=(
                _type_definition_from_dict(entry["response_type"])
                if entry.get("response_type") is not None
                else None
            ),
            requires_auth=entry.get("requires_auth", True),
        )

        _apply_snapshot_class_flags(request_type, response_types, function.response_type)

        functions.append(function)

    return functions


def _type_definition_from_dict(data: Dict[str, Any]) -> TypeDefinition:
    type_def = TypeDefinition(name=data["name"])
    type_def.is_array = data.get("is_array", False)
    type_def.is_primitive = data.get("is_primitive", False)
    type_def.is_nested_array = data.get("is_nested_array", False)

    for enum in data.get("enums", []):
        type_def.enums.append(EnumDefinition(type_name=enum["name"], items=enum["items"]))

    for field in data.get("fields", []):
        field_type = _type_definition_from_dict(field["type"])
        type_def.fields.append(
            Field(
                name=field["name"],
                type=field_type,
                documentation=field.get("comment", field.get("documentation", "")),
                required=_normalize_required(field.get("required", False)),
            )
        )

    enum_map = {enum.type_name: enum.items for enum in type_def.enums}
    if enum_map:
        for field in type_def.fields:
            enum_items = enum_map.get(field.type.name)
            if enum_items is not None:
                field.type.is_enum = True
                field.type.is_primitive = True
                field.type.enum_items = enum_items

    return type_def


def _normalize_required(value: Any) -> bool:
    if isinstance(value, str):
        return value.strip().lower() == "true"
    return bool(value)


def _apply_snapshot_class_flags(
    request_type: Optional[TypeDefinition],
    response_types: List[TypeDefinition],
    result_type: Optional[TypeDefinition],
) -> None:
    enum_names: set[str] = set()
    if request_type is not None:
        _collect_enum_names(request_type, enum_names)
    for type_def in response_types:
        _collect_enum_names(type_def, enum_names)
    if result_type is not None:
        _collect_enum_names(result_type, enum_names)

    class_names: set[str] = set(t.name for t in response_types)
    if result_type is not None:
        class_names.add(result_type.name)
    if request_type is not None:
        _collect_type_names(request_type, class_names, enum_names)

    class_names -= PRIMITIVE_TYPE_NAMES
    class_names -= enum_names

    if request_type is not None:
        _mark_class_fields(request_type, class_names)
    for type_def in response_types:
        _mark_class_fields(type_def, class_names)
    if result_type is not None:
        _mark_class_fields(result_type, class_names)


def _collect_enum_names(type_def: TypeDefinition, enum_names: set[str]) -> None:
    for enum in type_def.enums:
        enum_names.add(enum.type_name)
    for field in type_def.fields:
        _collect_enum_names(field.type, enum_names)


def _collect_type_names(
    type_def: TypeDefinition, names: set[str], enum_names: set[str]
) -> None:
    if type_def.name not in PRIMITIVE_TYPE_NAMES and type_def.name not in enum_names:
        names.add(type_def.name)
    for field in type_def.fields:
        _collect_type_names(field.type, names, enum_names)


def _mark_class_fields(type_def: TypeDefinition, class_names: set[str]) -> None:
    for field in type_def.fields:
        if field.type.name in class_names:
            field.type.is_class = True
        _mark_class_fields(field.type, class_names)
