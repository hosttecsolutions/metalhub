import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metalhub/app.dart';
import 'package:metalhub/data/client_repository.dart';
import 'helpers/memory_client_storage.dart';
import 'package:metalhub/widgets/app_shell.dart';
import 'package:metalhub/core/theme.dart';

void main() {
  setUp(
    () => ClientRepository.instance = ClientRepository(
      storage: MemoryClientStorage(),
    ),
  );

  testWidgets(
    'Cadastra PF, recupera após reiniciar a aplicação e edita o cliente',
    (tester) async {
      tester.view.physicalSize = const Size(1400, 1100);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const MetalHubApp());
      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Clientes'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Novo Cliente'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextField).at(0),
        'Cliente Cadastrado',
      );
      await tester.enterText(find.byType(TextField).at(1), '12345678909');
      await tester.enterText(find.byType(TextField).at(2), 'Rua Exemplo, 10');
      await tester.ensureVisible(find.text('CADASTRAR CLIENTE'));
      await tester.tap(find.text('CADASTRAR CLIENTE'));
      await tester.pumpAndSettle();
      expect(find.text('Cliente Cadastrado'), findsOneWidget);
      final storage = ClientRepository.instance.storage;
      await tester.pumpWidget(const SizedBox());
      ClientRepository.instance = ClientRepository(storage: storage);
      await tester.pumpWidget(const MetalHubApp());
      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Clientes'));
      await tester.pumpAndSettle();
      expect(find.text('Cliente Cadastrado'), findsOneWidget);
      await tester.tap(find.text('Editar Cliente').first);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'Cliente Editado');
      await tester.ensureVisible(find.text('SALVAR ALTERAÇÕES'));
      await tester.tap(find.text('SALVAR ALTERAÇÕES'));
      await tester.pumpAndSettle();
      expect(find.text('Cliente Editado'), findsOneWidget);
      expect(find.text('Cliente Cadastrado'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Login rejeita senha incorreta e aceita admin / admin', (
    tester,
  ) async {
    await tester.pumpWidget(const MetalHubApp());
    await tester.enterText(find.byType(TextField).last, 'incorreta');
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();
    expect(
      find.text('Usuário ou senha inválidos. Use admin / admin.'),
      findsOneWidget,
    );
    expect(find.text('Bem-vindo a MetalHub'), findsNothing);
    await tester.enterText(find.byType(TextField).last, 'admin');
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();
    expect(find.text('Bem-vindo a MetalHub'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Login navega para Dashboard e permite abrir clientes no celular',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const MetalHubApp());
      expect(
        tester.widget<TextField>(find.byType(TextField).first).controller!.text,
        'admin',
      );
      expect(
        tester.widget<TextField>(find.byType(TextField).last).controller!.text,
        'admin',
      );
      expect(
        find.textContaining('Para acessar', findRichText: true),
        findsOneWidget,
      );
      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();
      expect(find.text('Bem-vindo a MetalHub'), findsOneWidget);
      await tester.tap(find.byType(DrawerButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Clientes'));
      await tester.pumpAndSettle();
      expect(find.text('Gerencie sua carteira de clientes'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  for (final size in [
    const Size(360, 800),
    const Size(768, 1024),
    const Size(1920, 1080),
    const Size(3840, 2160),
  ]) {
    testWidgets('Todas as páginas sem overflow em ${size.width.toInt()}px', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      for (final entry in MetalHubApp.screens.entries) {
        await tester.pumpWidget(
          MaterialApp(
            theme: buildTheme(),
            home: AppShell(
              key: ValueKey(entry.key),
              route: entry.key,
              child: entry.value,
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: entry.key);
      }
      await tester.pumpWidget(const MetalHubApp());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'Login');
      await tester.ensureVisible(find.text('Criar uma conta'));
      await tester.tap(find.text('Criar uma conta'));
      await tester.pumpAndSettle();
      expect(find.text('Nome completo'), findsOneWidget);
      expect(tester.takeException(), isNull, reason: 'Cadastro');
    });
  }

  testWidgets('Busca exibe estado vazio e recupera resultados', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildTheme(),
        home: AppShell(
          route: '/clientes',
          child: MetalHubApp.screens['/clientes']!,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'inexistente');
    await tester.pump();
    expect(find.text('Nenhum resultado encontrado.'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'metalurgica');
    await tester.pump();
    expect(find.text('Metalúrgica Silva Ltda'), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });
}
