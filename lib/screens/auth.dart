import 'package:flutter/material.dart';

import '../core/navigation.dart';
import '../core/theme.dart';
import '../widgets/common.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.signup = false});
  final bool signup;
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool checked = true;
  bool obscure = true;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (!widget.signup) {
      usernameController.text = 'admin';
      passwordController.text = 'admin';
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void submit() {
    if (!widget.signup &&
        (usernameController.text.trim() != 'admin' ||
            passwordController.text != 'admin')) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Usuário ou senha inválidos. Use admin / admin.'),
          ),
        );
      return;
    }
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    goTo(context, '/dashboard');
  }

  Widget field(
    String label,
    String hint, {
    bool password = false,
    bool email = false,
    TextEditingController? controller,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: muted)),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          obscureText: password && obscure,
          keyboardType: email ? TextInputType.emailAddress : TextInputType.text,
          autocorrect: !email && !password,
          enableSuggestions: !password,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: password
                ? IconButton(
                    onPressed: () => setState(() => obscure = !obscure),
                    icon: Icon(
                      obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18,
                    ),
                    tooltip: obscure ? 'Mostrar senha' : 'Ocultar senha',
                  )
                : null,
          ),
        ),
      ],
    ),
  );
  @override
  Widget build(BuildContext context) {
    final contents = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Brand(vertical: true),
        const SizedBox(height: 32),
        if (widget.signup) field('Nome completo:', 'Nome completo'),
        if (widget.signup)
          field('E-mail:', 'email@email.com.br', email: true)
        else
          field('Usuário:', 'Usuário', controller: usernameController),
        field(
          'Senha:',
          'Digite sua senha',
          password: true,
          controller: passwordController,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 22,
              height: 24,
              child: Checkbox(
                value: checked,
                onChanged: (value) => setState(() => checked = value ?? false),
                activeColor: green,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                widget.signup
                    ? 'Estou de acordo com os'
                    : 'Lembrar-se dos dados',
                style: const TextStyle(fontSize: 10, color: muted),
              ),
            ),
            Flexible(
              child: TextButton(
                onPressed: () => showFeatureUnavailable(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  textStyle: const TextStyle(fontSize: 10),
                ),
                child: Text(
                  widget.signup ? 'termos de utilização' : 'Esqueceu a senha?',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        FilledButton(
          onPressed: widget.signup && !checked ? null : submit,
          child: Text(widget.signup ? 'Cadastrar-se' : 'Entrar'),
        ),
        if (!widget.signup) ...[
          const SizedBox(height: 14),
          const Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'Para acessar, basta digitar '),
                TextSpan(
                  text: 'admin / admin',
                  style: TextStyle(color: green, fontWeight: FontWeight.w600),
                ),
                TextSpan(text: '.'),
              ],
            ),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: muted, height: 1.5),
          ),
        ],
        const SizedBox(height: 14),
        TextButton(
          onPressed: () => goTo(context, widget.signup ? '/' : '/cadastro'),
          child: Text(
            widget.signup ? 'Já tenho uma conta' : 'Criar uma conta',
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, box) => SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: (box.maxHeight - 48).clamp(0, double.infinity),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: widget.signup
                      ? Panel(
                          padding: const EdgeInsets.all(28),
                          child: contents,
                        )
                      : Padding(
                          padding: const EdgeInsets.all(12),
                          child: contents,
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
