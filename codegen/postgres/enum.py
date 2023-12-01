from codegen.models.models import Enum_


def sort_enums(enums: list[str]) -> list[str]:
    return sorted(enums, key=lambda e: e)


def enum_to_type(schema: str, parent_type: str, enum: Enum_) -> str:
    res = f"drop type if exists {schema}.{parent_type}_{enum.type_name} cascade;\n\n"
    enums = ',\n'.join(f'    \'{e}\'' for e in sort_enums(enum.items))
    res += f"""create type {schema}.{parent_type}_{enum.type_name} as enum (
{enums}
);"""
    return res
