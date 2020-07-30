abstract class LocalStorageDependancy {
  Future<void> setItem(String key, dynamic value);

  Future<dynamic> getItem(String key);

  Future<void> removeItem(String key);

  Future<void> clear();

  void dispose();
}
