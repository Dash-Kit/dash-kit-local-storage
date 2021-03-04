import 'package:dash_kit_local_storage/src/coder/local_storage_coder.dart';
import 'package:dash_kit_local_storage/src/local_storage.dart';

class JsonLocalStorageCoder<T extends LocalStorageItem>
    extends LocalStorageCoder<T> {
  JsonLocalStorageCoder({
    required this.fromJson,
    required this.toJson,
  });

  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;

  @override
  T decode(data) {
    return fromJson(data);
  }

  @override
  dynamic encode(T item) {
    return toJson(item);
  }
}
