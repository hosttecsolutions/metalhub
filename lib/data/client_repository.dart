import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/client.dart';

abstract interface class ClientJsonStorage {
  Future<String?> read();
  Future<void> write(String value);
}

class LocalClientJsonStorage implements ClientJsonStorage {
  final SharedPreferencesAsync preferences = SharedPreferencesAsync();
  static const key = 'metalhub.clients.v1';
  @override
  Future<String?> read() => preferences.getString(key);
  @override
  Future<void> write(String value) => preferences.setString(key, value);
}

class ClientRepository {
  ClientRepository({ClientJsonStorage? storage})
    : storage = storage ?? LocalClientJsonStorage();
  static ClientRepository instance = ClientRepository();
  final ClientJsonStorage storage;

  Future<List<Client>> readAll() async {
    final raw = await storage.read();
    if (raw == null) return List.of(sampleClients);
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic> ||
        decoded['schemaVersion'] != 1 ||
        decoded['clients'] is! List) {
      throw const FormatException(
        'O JSON de clientes não pôde ser lido. Os dados foram preservados.',
      );
    }
    return (decoded['clients'] as List).map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Cliente inválido no JSON.');
      }
      return Client.fromJson(item);
    }).toList();
  }

  Future<void> save(Client client) async {
    final digits = client.document.replaceAll(RegExp(r'\D'), '');
    if (client.name.trim().isEmpty || client.address.trim().isEmpty) {
      throw const FormatException('Preencha nome e endereço.');
    }
    if (digits.length != (client.isCompany ? 14 : 11)) {
      throw FormatException(
        client.isCompany
            ? 'Informe um CNPJ com 14 dígitos.'
            : 'Informe um CPF com 11 dígitos.',
      );
    }
    final clients = await readAll();
    if (clients.any(
      (item) =>
          item.id != client.id &&
          item.document.replaceAll(RegExp(r'\D'), '') == digits,
    )) {
      throw const FormatException('Já existe um cliente com esse CPF ou CNPJ.');
    }
    final index = clients.indexWhere((item) => item.id == client.id);
    if (index < 0) {
      clients.insert(0, client);
    } else {
      clients[index] = client;
    }
    await storage.write(encode(clients));
  }

  String encode(List<Client> clients) =>
      const JsonEncoder.withIndent('  ').convert({
        'schemaVersion': 1,
        'clients': clients.map((item) => item.toJson()).toList(),
      });
}
