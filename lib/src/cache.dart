import 'package:flutter/foundation.dart';
import 'package:flutter_platform_local_storage/src/coder/local_storage_coder.dart';
import 'package:flutter_platform_local_storage/src/dependency/default_local_storage_dependency.dart';
import 'package:flutter_platform_local_storage/src/dependency/local_storage_dependancy.dart';
import 'package:flutter_platform_local_storage/src/local_storage.dart';

class Cache<T extends LocalStorageItem> extends LocalStorage<T> {
  Cache(LocalStorageCoder<T> coder)
      : _storage = DefaultLocalStorageDependency(T.toString()),
        _coder = coder,
        assert(T != dynamic);

  Cache.customLocalStorageDependancy({
    @required LocalStorageDependancy localStorageDependancy,
    @required LocalStorageCoder<T> coder,
  })  : _storage = localStorageDependancy,
        _coder = coder;

  final LocalStorageDependancy _storage;
  final LocalStorageCoder<T> _coder;

  static const _itemsKeysStorageKey = 'ITEMS_KEYS_STORAGE_KEY';

  @override
  Future<T> getItem(String key) async {
    final itemData = await _storage.getItem(key);

    if (itemData == null) {
      return null;
    }

    return _coder.decode(itemData);
  }

  @override
  Future<List<T>> getAllItems() async {
    final keys = await _getAllKeys();

    if (keys.isEmpty) {
      return [];
    }

    final items = keys.map((key) => _storage.getItem(key));
    return Future.wait(items)
        .then((values) => values.map(_coder.decode).toList());
  }

  @override
  Future<void> updateItem(T item) async {
    assert(item.storageId != null, 'Storage ID cannot be null');

    if (item?.storageId == null) {
      return;
    }

    final keys = await _getAllKeys();

    if (!keys.contains(item.storageId)) {
      keys.add(item.storageId);
      await _storage.setItem(_itemsKeysStorageKey, keys);
    }

    await _storage.setItem(item.storageId, item);
  }

  @override
  Future<void> updateItems(List<T> items) async {
    final filtredItems = items.where((i) => i.storageId != null);
    assert(filtredItems.length == items.length, 'Storage ID cannot be null');

    final keys = await _getAllKeys();
    final keysSet = keys.toSet();
    final missingKeys = filtredItems
        .where((i) => !keysSet.contains(i.storageId))
        .map((i) => i.storageId);

    if (missingKeys.isNotEmpty) {
      keys.addAll(missingKeys);
      await _storage.setItem(_itemsKeysStorageKey, keys);
    }

    await Future.wait(
      filtredItems.map((i) => _storage.setItem(i.storageId, i)),
    );
  }

  @override
  Future<void> removeItem(T item) async {
    assert(item.storageId != null, 'Storage ID cannot be null');

    if (item?.storageId == null) {
      return;
    }

    final keys = await _getAllKeys();
    keys.remove(item.storageId);

    await _storage.setItem(_itemsKeysStorageKey, keys);
    await _storage.removeItem(item.storageId);
  }

  @override
  Future<void> clear() {
    return _storage.clear();
  }

  @override
  Future<void> removeItemByKey(String key) async {
    assert(key != null, 'Storage ID cannot be null');

    if (key == null) {
      return;
    }

    final keys = await _getAllKeys();
    keys.remove(key);

    await _storage.setItem(_itemsKeysStorageKey, keys);
    await _storage.removeItem(key);
  }

  @override
  void dispose() {
    _storage.dispose();
  }

  Future<List<String>> _getAllKeys() async {
    final keys = await _storage.getItem(_itemsKeysStorageKey);
    if (keys != null && keys is List<dynamic>) {
      return keys.cast<String>();
    }
    return [];
  }
}
