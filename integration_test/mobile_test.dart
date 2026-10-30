import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:metalhub/app.dart';
import 'package:metalhub/data/client_repository.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Android: login, cadastro e persistência nativa', (tester) async {
    final storage = LocalClientJsonStorage();
    final original = await storage.read();
    final name = 'Cliente Android ${DateTime.now().microsecondsSinceEpoch}';
    try {
      ClientRepository.instance = ClientRepository();
      await tester.pumpWidget(const MetalHubApp());
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Entrar'));
      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();
      expect(find.text('Bem-vindo a MetalHub'), findsOneWidget);
      await tester.tap(find.byType(DrawerButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Clientes'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Novo Cliente'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).at(0), name);
      await tester.enterText(find.byType(TextField).at(1), '98765432100');
      await tester.ensureVisible(find.byType(TextField).at(2));
      await tester.enterText(find.byType(TextField).at(2), 'Rua Android, 10');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('CADASTRAR CLIENTE'));
      await tester.tap(find.text('CADASTRAR CLIENTE'));
      await tester.pumpAndSettle();
      expect(find.text(name), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      ClientRepository.instance = ClientRepository();
      await tester.pumpWidget(const MetalHubApp());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DrawerButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Clientes'));
      await tester.pumpAndSettle();
      expect(find.text(name), findsOneWidget);
      expect(tester.takeException(), isNull);
    } finally {
      if (original == null) {
        await storage.preferences.remove(LocalClientJsonStorage.key);
      } else {
        await storage.write(original);
      }
    }
  });
}
