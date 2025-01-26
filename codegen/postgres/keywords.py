def escape_postgres_keyword(keyword: str) -> str:
    return f'"{keyword}"'
