import 'package:flutter_platform_local_storage/src/coder/local_storage_coder.dart';
import 'package:flutter_platform_local_storage/src/local_storage.dart';

class DefaultLocalStorageCoder<T extends LocalStorageItem>
    extends LocalStorageCoder<T> {
  @override
  T decode(data) {
    return data;
  }

  @override
  dynamic encode(item) {
    return item;
  }
}
