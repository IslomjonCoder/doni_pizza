class CacheManager {
  final Map<String, dynamic> _cache = {};

  /// Get data from the cache using a specific [key].
  dynamic get(String key) {
    if (_cache.containsKey(key)) {
      return _cache[key];
    }
    return null;
  }

  /// Add data to the cache with a specific [key].
  void add(String key, dynamic data) {
    _cache[key] = data;
  }

  /// Remove data from the cache with a specific [key].
  void remove(String key) {
    _cache.remove(key);
  }

  /// Clear the entire cache.
  void clear() {
    _cache.clear();
  }
}
