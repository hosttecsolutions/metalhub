import 'package:flutter/material.dart';

import '../core/navigation.dart';
import '../core/theme.dart';
import '../widgets/common.dart';
import '../models/client.dart';
import '../data/client_repository.dart';

enum RegistrationKind { employee, user, individual, company }

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key, required this.kind});
  final RegistrationKind kind;
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final nameController = TextEditingController();
  final documentController = TextEditingController();
  final addressController = TextEditingController();
  Client? editing;
  bool initialized = false;
  bool saving = false;
  String? error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (initialized || !isClient) return;
    initialized = true;
    final argument = ModalRoute.of(context)?.settings.arguments;
    if (argument is Client) {
      editing = argument;
      nameController.text = argument.name;
      documentController.text = argument.document;
      addressController.text = argument.address;
      clientType = argument.clientType;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    documentController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> saveClient() async {
    FocusScope.of(context).unfocus();
    setState(() {
      saving = true;
      error = null;
    });
    try {
      final now = DateTime.now().toUtc();
      await ClientRepository.instance.save(
        Client(
          id: editing?.id ?? 'client-${now.microsecondsSinceEpoch}',
          personType: company ? 'PJ' : 'PF',
          name: nameController.text.trim(),
          document: documentController.text.trim(),
          address: addressController.text.trim(),
          clientType: clientType,
          status: editing?.status ?? 'Ativo',
          email: editing?.email ?? '',
          phone: editing?.phone ?? '',
          createdAt: editing?.createdAt ?? now.toIso8601String(),
        ),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cliente salvo com sucesso.')),
      );
      goTo(context, '/clientes');
    } on FormatException catch (e) {
      if (mounted) setState(() => error = e.message);
    } catch (_) {
      if (mounted) {
        setState(
          () => error =
              'Não foi possível salvar. Confira o armazenamento e tente novamente.',
        );
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  DateTime? admission;
  String status = 'Ativo';
  String clientType = 'Fornecedor';
  bool get isClient =>
      widget.kind == RegistrationKind.individual ||
      widget.kind == RegistrationKind.company;
  bool get company => widget.kind == RegistrationKind.company;
  bool get user => widget.kind == RegistrationKind.user;
  String get title => switch (widget.kind) {
    RegistrationKind.employee => 'Cadastro de Funcionário',
    RegistrationKind.user => 'Cadastro de Usuários',
    RegistrationKind.individual => 'Cadastro de Cliente (Pessoa Física)',
    RegistrationKind.company => 'Cadastro de Cliente (Pessoa Jurídica)',
  };
  String get banner => switch (widget.kind) {
    RegistrationKind.employee => 'banner-funcionario',
    RegistrationKind.user => 'banner-usuarios',
    RegistrationKind.individual => 'banner-cliente-pf',
    RegistrationKind.company => 'banner-cliente-pj',
  };
  Widget field(
    String label,
    String hint, {
    TextInputType? keyboard,
    bool obscure = false,
    TextEditingController? controller,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 12, color: muted)),
      const SizedBox(height: 7),
      TextField(
        controller: controller,
        enabled: !saving,
        keyboardType: keyboard,
        obscureText: obscure,
        decoration: InputDecoration(hintText: hint),
      ),
    ],
  );
  Widget dropdown(
    String label,
    String value,
    List<String> options,
    ValueChanged<String?> onChange,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 12, color: muted)),
      const SizedBox(height: 7),
      DropdownButtonFormField<String>(
        initialValue: value,
        isExpanded: true,
        style: const TextStyle(fontSize: 13, color: ink),
        items: options
            .map(
              (option) => DropdownMenuItem(value: option, child: Text(option)),
            )
            .toList(),
        onChanged: onChange,
      ),
    ],
  );
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      PageHeading(
        title,
        isClient
            ? 'Cadastre todos os clientes no seu sistema'
            : user
            ? 'Gerencie todos os usuários de seu sistema'
            : 'Gerencie todos os funcionários de seu sistema',
      ),
      BannerImage(banner),
      Panel(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isClient) ...[
              Wrap(
                spacing: 14,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('Pessoa Física'),
                    selected: !company,
                    onSelected: saving || editing != null
                        ? null
                        : (_) => goTo(context, '/cadastro-cliente-pf'),
                    selectedColor: paleGreen,
                    labelStyle: const TextStyle(fontSize: 12),
                  ),
                  ChoiceChip(
                    label: const Text('Pessoa Jurídica'),
                    selected: company,
                    onSelected: saving || editing != null
                        ? null
                        : (_) => goTo(context, '/cadastro-cliente-pj'),
                    selectedColor: paleGreen,
                    labelStyle: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
            AdaptiveGrid(
              columns: 2,
              minWidth: 260,
              children: [
                field(
                  company
                      ? 'Razão Social:'
                      : widget.kind == RegistrationKind.employee
                      ? 'Nome do funcionário:'
                      : 'Nome completo:',
                  company ? 'Razão social da empresa' : 'Nome completo',
                  controller: isClient ? nameController : null,
                ),
                field(
                  company
                      ? 'CNPJ:'
                      : user
                      ? 'E-mail:'
                      : 'CPF:',
                  company
                      ? '00.000.000/0000-00'
                      : user
                      ? 'email@email.com.br'
                      : '000.000.000-00',
                  controller: isClient ? documentController : null,
                  keyboard: user
                      ? TextInputType.emailAddress
                      : TextInputType.number,
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (isClient)
              AdaptiveGrid(
                columns: 2,
                minWidth: 260,
                children: [
                  field(
                    'Endereço:',
                    'Rua, número, cidade e estado',
                    controller: addressController,
                  ),
                  dropdown(
                    'Tipo de Cliente:',
                    clientType,
                    ['Fornecedor', 'Comprador'],
                    (value) =>
                        setState(() => clientType = value ?? 'Fornecedor'),
                  ),
                ],
              )
            else
              AdaptiveGrid(
                columns: 4,
                minWidth: 170,
                children: [
                  if (user) field('Senha:', 'Digite sua senha', obscure: true),
                  field('Cargo:', 'Cargo do funcionário'),
                  field('Setor:', 'Setor'),
                  if (!user)
                    field(
                      'Salário:',
                      'R\$ 0,00',
                      keyboard: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                  dropdown(
                    user ? 'Status da Conta:' : 'Status de admissão:',
                    status,
                    ['Ativo', 'Inativo'],
                    (value) => setState(() => status = value ?? 'Ativo'),
                  ),
                ],
              ),
            const SizedBox(height: 24),
            if (!isClient && !user) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 260,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Data de admissão:',
                        style: TextStyle(fontSize: 12, color: muted),
                      ),
                      const SizedBox(height: 7),
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: admission ?? DateTime.now(),
                            firstDate: DateTime(1950),
                            lastDate: DateTime(2100),
                          );
                          if (date != null && mounted) {
                            setState(() => admission = date);
                          }
                        },
                        borderRadius: BorderRadius.circular(7),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            suffixIcon: Icon(
                              Icons.calendar_today_outlined,
                              size: 18,
                            ),
                          ),
                          child: Text(
                            admission == null
                                ? 'Selecione uma data'
                                : '${admission!.day.toString().padLeft(2, '0')}/${admission!.month.toString().padLeft(2, '0')}/${admission!.year}',
                            style: const TextStyle(fontSize: 13, color: muted),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Text(
                  error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                  semanticsLabel: error,
                ),
              ),
            FilledButton(
              onPressed: saving
                  ? null
                  : isClient
                  ? saveClient
                  : () => showFeatureUnavailable(context),
              child: Text(
                saving
                    ? 'SALVANDO...'
                    : isClient
                    ? editing != null
                          ? 'SALVAR ALTERAÇÕES'
                          : 'CADASTRAR CLIENTE'
                    : user
                    ? 'CADASTRAR USUÁRIO'
                    : 'CADASTRAR FUNCIONÁRIO',
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
