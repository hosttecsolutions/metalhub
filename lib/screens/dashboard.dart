import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../widgets/common.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    const stats = [
      (
        Icons.assignment_outlined,
        '248',
        'Notas Fiscais Emitidas',
        '+12%',
        green,
      ),
      (Icons.person_outline, '67', 'Clientes ativos', '+5%', Color(0xFF1672A5)),
      (
        Icons.attach_money,
        'R\$ 125.450',
        'Faturamento Mensal',
        '+19%',
        Color(0xFFBC6C9C),
      ),
      (
        Icons.inventory_2_outlined,
        '45.2 ton',
        'Material processado',
        '+49%',
        Color(0xFFD78B45),
      ),
    ];
    const activities = [
      (true, 'NF-2025-00001 - Metalúrgica Lourenço', '20/11/2025'),
      (false, 'Novo cliente cadastrado - Indústrias Marcelo', '19/11/2025'),
      (true, 'NF-2025-00002 - Recicladora Henrique', '18/11/2025'),
      (false, 'Novo cliente cadastrado - Indústria Souza', '17/11/2025'),
      (false, 'Novo cliente cadastrado - Metal Louco', '16/11/2025'),
      (true, 'NF-2025-00003 - Indústria Rafaelo', '14/11/2025'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PageHeading(
          'Bem-vindo a MetalHub',
          'Visão geral de suas operações',
        ),
        AdaptiveGrid(
          columns: 4,
          minWidth: 200,
          children: stats
              .map(
                (s) => Panel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: s.$5.withValues(alpha: .07),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(s.$1, size: 22, color: s.$5),
                          ),
                          StatusChip('↗ ${s.$4}'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        s.$2,
                        style: const TextStyle(
                          color: ink,
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(s.$3, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 28),
        Panel(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Atividades recentes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const Divider(),
              for (final a in activities) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StatusChip(
                              a.$1
                                  ? 'Nota Fiscal Emitida'
                                  : 'Cliente Cadastrado',
                              color: a.$1 ? green : const Color(0xFF1672A5),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              a.$2,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        a.$3,
                        style: const TextStyle(fontSize: 10, color: muted),
                      ),
                    ],
                  ),
                ),
                if (a != activities.last) const Divider(),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
