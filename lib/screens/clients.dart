import 'package:flutter/material.dart';
import '../core/navigation.dart';
import '../core/theme.dart';
import '../widgets/common.dart';
import '../models/client.dart';
import '../data/client_repository.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key, this.movements = false});
  final bool movements;
  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  late Future<List<Client>> clients;
  @override
  void initState() {
    super.initState();
    clients = ClientRepository.instance.readAll();
  }

  void reload() =>
      setState(() => clients = ClientRepository.instance.readAll());
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      PageHeading(
        widget.movements ? 'Visualizar seus pedidos/vendas' : 'Clientes',
        widget.movements
            ? 'Gerencie todas as suas movimentações na MetalHub'
            : 'Gerencie sua carteira de clientes',
        action: widget.movements
            ? null
            : Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ActionButton(
                    'Novo Cliente',
                    icon: Icons.add,
                    onPressed: () => goTo(context, '/cadastro-cliente-pf'),
                  ),
                ],
              ),
      ),
      if (widget.movements)
        const AdaptiveGrid(children: [ClientCard(movements: true)])
      else
        FutureBuilder<List<Client>>(
          future: clients,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Padding(
                padding: EdgeInsets.all(28),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError) {
              return Panel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Não foi possível ler os clientes. Os dados salvos foram preservados.',
                    ),
                    const SizedBox(height: 12),
                    ActionButton(
                      'Tentar novamente',
                      icon: Icons.refresh,
                      onPressed: reload,
                    ),
                  ],
                ),
              );
            }
            final data = snapshot.data ?? [];
            if (data.isEmpty) {
              return const Panel(
                child: Text(
                  'Nenhum cliente cadastrado. Use Novo Cliente para começar.',
                ),
              );
            }
            return SearchableCards(
              hint: 'Buscar por nome, CPF/CNPJ ou endereço...',
              items: data.map((item) => item.searchText).toList(),
              builder: (index) => ClientCard(client: data[index]),
            );
          },
        ),
    ],
  );
}

class ClientCard extends StatelessWidget {
  const ClientCard({super.key, this.client, this.movements = false});
  final Client? client;
  final bool movements;
  @override
  Widget build(BuildContext context) {
    final data = client ?? sampleClients.first;
    final color = data.inactive ? const Color(0xFFE15B62) : green;
    return Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                data.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              StatusChip(data.status, color: color),
            ],
          ),
          const SizedBox(height: 10),
          Detail(Icons.attach_file, data.document, color: color),
          if (data.email.isNotEmpty)
            Detail(Icons.email_outlined, data.email, color: color),
          if (data.phone.isNotEmpty)
            Detail(Icons.phone_outlined, data.phone, color: color),
          Detail(Icons.location_on_outlined, data.address, color: color),
          Detail(Icons.attach_money, data.clientType, color: color),
          const SizedBox(height: 14),
          if (movements)
            const ActionButton(
              'Visualizar suas movimentações',
              icon: Icons.visibility_outlined,
              color: Color(0xFFF36C78),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ActionButton(
                  'Editar Cliente',
                  icon: Icons.edit_outlined,
                  color: const Color(0xFFF1846C),
                  onPressed: () => Navigator.of(context).pushReplacementNamed(
                    data.isCompany
                        ? '/cadastro-cliente-pj'
                        : '/cadastro-cliente-pf',
                    arguments: data,
                  ),
                ),
                ActionButton(
                  'Detalhes',
                  icon: Icons.info_outline,
                  soft: true,
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(data.name),
                      content: SingleChildScrollView(
                        child: Text(
                          '${data.isCompany ? "Pessoa Jurídica" : "Pessoa Física"}\n${data.document}\n${data.address}\n${data.clientType}\n${data.status}'
                          '${data.email.isEmpty ? "" : "\n${data.email}"}${data.phone.isEmpty ? "" : "\n${data.phone}"}',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Fechar'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
