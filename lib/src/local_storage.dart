abstract class LocalStorageItem {
  String get storageId;
}

abstract class LocalStorage<T extends LocalStorageItem> {
  Future<T> getItem(String key);

  Future<List<T>> getAllItems();

  Future<void> updateItem(T item);

  Future<void> updateItems(List<T> items);

  Future<void> removeItem(T item);

  Future<void> removeItemByKey(String key);

  Future<void> clear();

  void dispose();
}
