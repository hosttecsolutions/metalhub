import 'package:flutter/material.dart';

import '../core/navigation.dart';
import '../core/theme.dart';
import 'common.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.route, required this.child});
  final String route;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 1000;
    final active = route.startsWith('/cadastro-cliente') ? '/clientes' : route;
    Widget menu() => Material(
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 14, bottom: 16),
            child: Text(
              'PRINCIPAL',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1.5,
                color: muted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          for (final item in destinations)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: ListTile(
                selected: active == item.route,
                selectedTileColor: paleGreen,
                selectedColor: green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                dense: true,
                visualDensity: VisualDensity.compact,
                horizontalTitleGap: 10,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 3,
                ),
                leading: Icon(
                  item.icon,
                  size: 19,
                  color: active == item.route ? green : muted,
                ),
                title: Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: active == item.route
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
                onTap: () {
                  if (!wide) Navigator.pop(context);
                  goTo(context, item.route);
                },
              ),
            ),
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: !wide,
        title: const Brand(),
        titleSpacing: wide ? 26 : 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ),
        actions: [
          if (wide && route == '/cadastro-funcionario')
            const Text(
              'Recursos Humanos',
              style: TextStyle(fontSize: 12, color: green),
            ),
          TextButton.icon(
            onPressed: () => Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/', (_) => false),
            icon: const Icon(Icons.logout, size: 16),
            label: Text(wide ? 'Sair' : ''),
            style: TextButton.styleFrom(foregroundColor: muted),
          ),
          const SizedBox(width: 12),
        ],
      ),
      drawer: wide
          ? null
          : Drawer(
              width: 260,
              child: SafeArea(
                child: Column(
                  children: [
                    const Padding(padding: EdgeInsets.all(20), child: Brand()),
                    const Divider(),
                    Expanded(child: menu()),
                  ],
                ),
              ),
            ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (wide)
            SizedBox(
              width: 248,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  border: Border(right: BorderSide(color: outline)),
                ),
                child: menu(),
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              key: PageStorageKey(route),
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1512),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: wide ? 36 : 20,
                      vertical: wide ? 32 : 24,
                    ),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
