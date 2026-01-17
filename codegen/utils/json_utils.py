import json

try:
    import numpy as np
except ModuleNotFoundError:
    np = None


class CustomJSONizer(json.JSONEncoder):
    def default(self, obj):
        if np is not None and isinstance(obj, np.bool_):
            return super().encode(bool(obj))
        return super().default(obj)
