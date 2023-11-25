from codegen.models.models import Enum


def enum_to_type(schema: str, parent_type: str, enum: Enum) -> str:
    res = f"drop type if exists {schema}.{parent_type}_{enum.name} cascade;\n"
    enums = ', '.join(f'\'{e}\'' for e in enum.items)
    res += f"create type {schema}.{parent_type}_{enum.name} as enum ({enums});"
    return res
