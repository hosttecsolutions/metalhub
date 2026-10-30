import 'package:flutter/material.dart';

class Destination {
  const Destination(this.route, this.label, this.icon);
  final String route;
  final String label;
  final IconData icon;
}

const destinations = [
  Destination('/dashboard', 'Dashboard', Icons.dashboard_outlined),
  Destination('/notas-fiscais', 'Notas Fiscais', Icons.receipt_long_outlined),
  Destination('/clientes', 'Clientes', Icons.people_outline),
  Destination('/logistica', 'Logística', Icons.local_shipping_outlined),
  Destination('/rastreamento', 'Rastreamento', Icons.location_on_outlined),
  Destination(
    '/cadastro-funcionario',
    'Cadastro de Funcionário',
    Icons.person_add_alt_outlined,
  ),
  Destination(
    '/cadastro-usuario',
    'Cadastro de Usuário',
    Icons.manage_accounts_outlined,
  ),
  Destination('/mtr', 'MTR', Icons.description_outlined),
  Destination('/movimentacoes', 'Suas movimentações', Icons.swap_horiz),
  Destination(
    '/funcionarios',
    'Funcionários Cadastrados',
    Icons.badge_outlined,
  ),
];

void goTo(BuildContext context, String route) {
  if (ModalRoute.of(context)?.settings.name == route) return;
  Navigator.of(context).pushReplacementNamed(route);
}

void showFeatureUnavailable(BuildContext context) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      const SnackBar(
        content: Text('Esta funcionalidade ainda não está disponível.'),
      ),
    );
}
