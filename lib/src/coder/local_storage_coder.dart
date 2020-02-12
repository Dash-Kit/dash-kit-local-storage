import 'package:flutter_platform_local_storage/src/local_storage.dart';

abstract class LocalStorageCoder<T extends LocalStorageItem> {
  dynamic encode(T item);

  T decode(dynamic data);
}
