import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:metalhub/data/client_repository.dart';
import 'package:metalhub/models/client.dart';
import 'helpers/memory_client_storage.dart';

Client record(
  String id,
  String name,
  String document, {
  String personType = 'PF',
}) => Client(
  id: id,
  personType: personType,
  name: name,
  document: document,
  address: 'Rua das Flores, 10 - Mogi das Cruzes, SP',
  clientType: 'Fornecedor',
  createdAt: '2026-10-30T12:00:00.000Z',
);

void main() {
  test(
    'PF e PJ são gravados em JSON e recuperados por outra instância',
    () async {
      final storage = MemoryClientStorage();
      final repository = ClientRepository(storage: storage);
      await repository.save(
        record('pf-1', 'Cliente Pessoa Física', '123.456.789-09'),
      );
      await repository.save(
        record(
          'pj-1',
          'Empresa Exemplo',
          '12.345.678/0001-95',
          personType: 'PJ',
        ),
      );
      final json = jsonDecode(storage.value!);
      expect(json['schemaVersion'], 1);
      final restored = await ClientRepository(storage: storage).readAll();
      expect(restored.first.name, 'Empresa Exemplo');
      expect(
        restored.any((client) => client.name == 'Cliente Pessoa Física'),
        isTrue,
      );
    },
  );
  test('CPF/CNPJ duplicado não altera o JSON', () async {
    final storage = MemoryClientStorage();
    final repository = ClientRepository(storage: storage);
    await repository.save(record('pf-1', 'Primeiro', '123.456.789-09'));
    final before = storage.value;
    await expectLater(
      repository.save(record('pf-2', 'Duplicado', '12345678909')),
      throwsFormatException,
    );
    expect(storage.value, before);
  });
  test('Edição atualiza o mesmo cliente sem criar uma cópia', () async {
    final storage = MemoryClientStorage();
    final repository = ClientRepository(storage: storage);
    await repository.save(record('pf-1', 'Nome inicial', '12345678909'));
    await repository.save(record('pf-1', 'Nome atualizado', '12345678909'));
    final matches = (await repository.readAll()).where(
      (client) => client.id == 'pf-1',
    );
    expect(matches.single.name, 'Nome atualizado');
  });
  test(
    'JSON corrompido é preservado e falha de gravação é informada',
    () async {
      final storage = MemoryClientStorage()..value = '{invalid';
      final repository = ClientRepository(storage: storage);
      await expectLater(repository.readAll(), throwsFormatException);
      await expectLater(
        repository.save(record('pf-1', 'Nome', '12345678909')),
        throwsFormatException,
      );
      expect(storage.value, '{invalid');
      storage.value = null;
      storage.failWrites = true;
      await expectLater(
        repository.save(record('pf-1', 'Nome', '12345678909')),
        throwsStateError,
      );
      expect(storage.value, isNull);
    },
  );
}
