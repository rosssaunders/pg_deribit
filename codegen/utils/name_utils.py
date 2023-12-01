import inflect
p = inflect.engine()


def get_singular_type_name(parent_type_name: str, field_name: str) -> str:
    if p.singular_noun(field_name) is False:
        new_type_name = f"{parent_type_name}_{field_name}"
    else:
        new_type_name = f"{parent_type_name}_{p.singular_noun(field_name)}"

    return new_type_name


def strip_field_name(field_name: str) -> str:
    field_name = str(field_name).replace('› ', '')
    field_name = field_name.replace('› › ', '')
    return field_name


def count_ident(field_name: str) -> int:
    return field_name.count('›')


def url_to_type_name(end_point):
    items = end_point.split('/')
    return '_'.join(items[1:])

