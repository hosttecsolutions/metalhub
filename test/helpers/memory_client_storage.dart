import 'package:metalhub/data/client_repository.dart';

class MemoryClientStorage implements ClientJsonStorage {
  String? value;
  bool failWrites = false;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String data) async {
    if (failWrites) throw StateError('Storage unavailable');
    value = data;
  }
}
