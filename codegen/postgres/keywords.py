def escape_postgres_keyword(keyword) -> str:
    # List of PostgreSQL reserved keywords
    reserved_keywords = [
        'all', 'analyse', 'analyze', 'and', 'any', 'array', 'as', 'asc', 'asymmetric',
        'both', 'case', 'cast', 'check', 'collate', 'column', 'constraint', 'create',
        'current_date', 'current_role', 'current_time', 'current_timestamp',
        'current_user', 'default', 'deferrable', 'desc', 'distinct', 'do', 'else', 'end',
        'except', 'false', 'for', 'foreign', 'from', 'grant', 'group', 'having', 'in',
        'initially', 'intersect', 'into', 'leading', 'limit', 'localtime', 'localtimestamp',
        'new', 'not', 'null', 'of', 'off', 'offset', 'old', 'on', 'only', 'or', 'order',
        'placing', 'primary', 'references', 'returning', 'select', 'session_user',
        'some', 'symmetric', 'table', 'then', 'to', 'trailing', 'true', 'union', 'unique',
        'user', 'using', 'variadic', 'when', 'where', 'window', 'with', 'interval'
    ]

    # If the keyword is a reserved keyword, return it wrapped in double quotes
    if keyword.lower() in reserved_keywords:
        return f'"{keyword}"'

    # If the keyword is not a reserved keyword, return it as is
    return keyword
