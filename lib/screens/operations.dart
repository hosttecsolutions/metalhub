import 'package:flutter/material.dart';

import '../core/navigation.dart';
import '../core/theme.dart';
import '../widgets/common.dart';

class InvoicesScreen extends StatelessWidget {
  const InvoicesScreen({super.key});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const PageHeading(
        'Notas Fiscais',
        'Gerencie todas as notas fiscais',
        action: ActionButton('Nova Nota Fiscal', icon: Icons.add),
      ),
      SearchableCards(
        hint: 'Buscar por número, cliente ou material...',
        items: List.filled(
          9,
          'NF-2025-00248 Metalúrgica Silva Ltda Sucata de Ferro 24/11/2025 R\$ 12.500,00',
        ),
        builder: (_) => const InvoiceCard(),
      ),
    ],
  );
}

class InvoiceCard extends StatelessWidget {
  const InvoiceCard({super.key});
  @override
  Widget build(BuildContext context) => Panel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'NF-2025-00248',
          style: TextStyle(
            fontSize: 16,
            color: green,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Metalúrgica Silva Ltda',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 6),
        const Detail(Icons.calendar_today_outlined, '24/11/2025'),
        const Detail(Icons.attach_money, 'R\$ 12.500,00'),
        const Detail(Icons.inventory_2_outlined, 'Sucata de Ferro - 2.5 ton'),
        const SizedBox(height: 12),
        const Row(
          children: [
            Expanded(
              child: ActionButton(
                'Visualizar',
                icon: Icons.visibility_outlined,
                soft: true,
              ),
            ),
            SizedBox(width: 8),
            ActionButton(
              '',
              icon: Icons.download_outlined,
              color: Color(0xFF1672A5),
              soft: true,
            ),
          ],
        ),
      ],
    ),
  );
}

class LogisticsScreen extends StatelessWidget {
  const LogisticsScreen({super.key});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const PageHeading(
        'Logística',
        'Gerencie as rotas e entregas',
        action: ActionButton('Nova Entrega', icon: Icons.add),
      ),
      SearchableCards(
        hint: 'Buscar por código, motorista ou empresa...',
        items: const ['Viagem 001 Empresa A Matheus Yuri ABC-1234 Poá Suzano'],
        builder: (_) => const DeliveryCard(),
      ),
    ],
  );
}

class DeliveryCard extends StatelessWidget {
  const DeliveryCard({super.key});
  @override
  Widget build(BuildContext context) => Panel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Wrap(
          spacing: 10,
          runSpacing: 8,
          children: [
            Text(
              'Viagem 001 - Empresa A',
              style: TextStyle(color: green, fontWeight: FontWeight.w600),
            ),
            StatusChip('A fazer', color: Color(0xFFF1846C)),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Caminhão Scania - ABC-1234',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const Detail(Icons.person_outline, 'Matheus Yuri'),
        const Detail(Icons.phone_outlined, '(11) 99999-9999'),
        const Detail(Icons.location_on_outlined, 'Poá, São Paulo'),
        const Padding(
          padding: EdgeInsets.only(left: 25),
          child: Text('│  90 km', style: TextStyle(color: muted, fontSize: 11)),
        ),
        const Detail(Icons.location_on_outlined, 'Suzano, São Paulo'),
        const SizedBox(height: 12),
        const AdaptiveGrid(
          columns: 2,
          minWidth: 110,
          gap: 10,
          children: [
            _DateBox('Coletado', '24/11/2024 às 12:20'),
            _DateBox('Entrega Prevista', '26/11/2024'),
          ],
        ),
        const SizedBox(height: 14),
        const Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ActionButton('Ver imprevistos', color: Color(0xFFF36C78)),
            ActionButton(
              'Cadastrar imprevisto',
              color: Color(0xFFD97656),
              soft: true,
            ),
          ],
        ),
      ],
    ),
  );
}

class _DateBox extends StatelessWidget {
  const _DateBox(this.label, this.date);
  final String label;
  final String date;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color(0xFFEDF5FB),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: muted)),
        const SizedBox(height: 4),
        Text(
          date,
          style: const TextStyle(fontSize: 10, color: Color(0xFF1672A5)),
        ),
      ],
    ),
  );
}

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const PageHeading(
        'Rastreamento de Cargas',
        'Acompanhe suas entregas em tempo real',
      ),
      Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Rastrear Carga',
              style: TextStyle(fontSize: 12, color: muted),
            ),
            const SizedBox(height: 10),
            LayoutBuilder(
              builder: (context, box) {
                final input = const TextField(
                  decoration: InputDecoration(
                    hintText: 'Digite o código de rastreio',
                    prefixIcon: Icon(Icons.search, size: 18),
                  ),
                );
                final button = FilledButton(
                  onPressed: () => showFeatureUnavailable(context),
                  child: const Text('RASTREAR'),
                );
                return box.maxWidth < 500
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [input, const SizedBox(height: 10), button],
                      )
                    : Row(
                        children: [
                          Expanded(child: input),
                          const SizedBox(width: 12),
                          button,
                        ],
                      );
              },
            ),
          ],
        ),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 26, bottom: 16),
        child: Text(
          'Rastreamentos Ativos',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: muted,
          ),
        ),
      ),
      AdaptiveGrid(
        columns: 4,
        minWidth: 220,
        children: List.generate(8, (_) => const TrackingCard()),
      ),
    ],
  );
}

class TrackingCard extends StatelessWidget {
  const TrackingCard({super.key});
  @override
  Widget build(BuildContext context) => Panel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Viagem 001 - Empresa A',
          style: TextStyle(
            color: green,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0F1),
            borderRadius: BorderRadius.circular(7),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Detail(
                Icons.location_on_outlined,
                'Poá, São Paulo',
                color: Color(0xFFEE8E99),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25, top: 6, bottom: 6),
                child: Text(
                  'Localização atual:\nRod. Anhanguera, Km 42',
                  style: TextStyle(fontSize: 10, color: muted),
                ),
              ),
              Detail(
                Icons.location_on_outlined,
                'Suzano, São Paulo',
                color: Color(0xFFEE8E99),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const ActionButton('Ver dados da entrega', soft: true),
      ],
    ),
  );
}

class MtrScreen extends StatelessWidget {
  const MtrScreen({super.key});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const PageHeading(
        'MTR - Manifesto de Transporte de Resíduos',
        'Gerencie os manifestos de transporte',
        action: ActionButton('Nova MTR', icon: Icons.add),
      ),
      SearchableCards(
        hint: 'Buscar por gerador, destinatário ou transportadora...',
        columns: 2,
        minWidth: 400,
        items: List.filled(
          2,
          'MTR 001 Empresa A Metalúrgica Silva Ltda TransResíduos Express Marcelo Engenharia',
        ),
        builder: (_) => const MtrCard(),
      ),
    ],
  );
}

class MtrCard extends StatelessWidget {
  const MtrCard({super.key});
  @override
  Widget build(BuildContext context) => const Panel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'MTR 001 - Empresa A',
          style: TextStyle(
            color: green,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 16),
        AdaptiveGrid(
          columns: 3,
          minWidth: 110,
          gap: 12,
          children: [
            _DataValue('Gerador', 'Metalúrgica Silva Ltda'),
            _DataValue('Transportador', 'TransResíduos Express'),
            _DataValue('Destinatário', 'Marcelo Engenharia'),
          ],
        ),
        SizedBox(height: 12),
        Detail(Icons.calendar_today_outlined, 'Emissão: 24/11/2025'),
        Detail(Icons.inventory_2_outlined, 'Coleta: 24/11/2025'),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ActionButton(
              'Visualizar',
              icon: Icons.visibility_outlined,
              color: Color(0xFF1672A5),
              soft: true,
            ),
            ActionButton(
              'Baixar',
              icon: Icons.download_outlined,
              color: Color(0xFFD97656),
              soft: true,
            ),
          ],
        ),
      ],
    ),
  );
}

class EmployeesScreen extends StatelessWidget {
  const EmployeesScreen({super.key});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const PageHeading(
        'Funcionários cadastrados',
        'Gerencie seus funcionários',
      ),
      SearchableCards(
        hint: 'Buscar por nome, CPF ou cargo...',
        columns: 2,
        minWidth: 420,
        items: const [
          'Marcelo Henrique de Souza Lourenço 000.000.000-00 Aux. Administrativo Administração Ativo',
        ],
        builder: (_) => const Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Marcelo Henrique de Souza Lourenço',
                style: TextStyle(
                  color: green,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16),
              AdaptiveGrid(
                columns: 3,
                minWidth: 100,
                gap: 12,
                children: [
                  _DataValue('CPF', '000.000.000-00'),
                  _DataValue('Cargo', 'Aux. Administrativo'),
                  _DataValue('Setor', 'Administração'),
                ],
              ),
              SizedBox(height: 12),
              Detail(Icons.calendar_today_outlined, '26/11/2025'),
              Detail(Icons.attach_money, 'R\$ 10.000,00'),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: StatusChip('Ativo'),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

class _DataValue extends StatelessWidget {
  const _DataValue(this.label, this.value);
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 11, color: muted)),
      const SizedBox(height: 5),
      Text(value, style: const TextStyle(fontSize: 12, color: green)),
    ],
  );
}
