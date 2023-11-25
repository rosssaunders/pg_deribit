def required_to_string(required: bool) -> str:
    if required:
        return '(Required) '
    else:
        return ''


def escape_comment(comment: str) -> str:
    return str(comment).replace("'", "''")
