import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme.dart';
import 'widgets/app_shell.dart';
import 'screens/auth.dart';
import 'screens/dashboard.dart';
import 'screens/clients.dart';
import 'screens/operations.dart';
import 'screens/registration.dart';

class MetalHubApp extends StatelessWidget {
  const MetalHubApp({super.key});

  static const screens = <String, Widget>{
    '/dashboard': DashboardScreen(),
    '/notas-fiscais': InvoicesScreen(),
    '/clientes': ClientsScreen(),
    '/logistica': LogisticsScreen(),
    '/rastreamento': TrackingScreen(),
    '/cadastro-funcionario': RegistrationScreen(
      kind: RegistrationKind.employee,
    ),
    '/cadastro-usuario': RegistrationScreen(kind: RegistrationKind.user),
    '/mtr': MtrScreen(),
    '/movimentacoes': ClientsScreen(movements: true),
    '/funcionarios': EmployeesScreen(),
    '/cadastro-cliente-pf': RegistrationScreen(
      kind: RegistrationKind.individual,
    ),
    '/cadastro-cliente-pj': RegistrationScreen(kind: RegistrationKind.company),
  };

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'MetalHub',
    locale: const Locale('pt', 'BR'),
    supportedLocales: const [Locale('pt', 'BR'), Locale('en', 'US')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    debugShowCheckedModeBanner: false,
    theme: buildTheme(),
    initialRoute: '/',
    routes: {
      '/': (_) => const AuthScreen(),
      '/cadastro': (_) => const AuthScreen(signup: true),
      for (final entry in screens.entries)
        entry.key: (_) => AppShell(route: entry.key, child: entry.value),
    },
  );
}
