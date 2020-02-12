import 'package:flutter_platform_local_storage/src/dependency/local_storage_dependancy.dart';
import 'package:localstorage/localstorage.dart';

class DefaultLocalStorageDependency extends LocalStorageDependancy {
  DefaultLocalStorageDependency(String storageKey)
      : _storage = LocalStorage(storageKey);

  final LocalStorage _storage;

  @override
  Future<void> setItem(String key, dynamic value) {
    return _storage.setItem(key, value);
  }

  @override
  Future<dynamic> getItem(String key) {
    return Future.value(_storage.getItem(key));
  }

  @override
  Future<void> removeItem(String key) {
    return _storage.deleteItem(key);
  }

  @override
  Future<void> clear() async {
    try {
      return await _storage.clear();
    } catch (error) {
      return;
    }
  }

  @override
  void dispose() {
    _storage.dispose();
  }
}
