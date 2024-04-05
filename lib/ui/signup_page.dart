import 'package:event_poll/states/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String username = '';
  String password = '';
  String password_bis = '';
  String? error;
  // Clé permettant de référencer la classe d'état du composant Form
  final _formKey = GlobalKey<FormState>();

  String? _validateRequired(String? value) {
    return value == null || value.isEmpty ? 'Ce champ est obligatoire.' : null;
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (password == password_bis) {
      final user = await context.read<AuthState>().signup(username, password);

      if (user == null) {
        // Vérifie que le contexte est toujours valide avant de naviguer
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/polls', (_) => false);
        }
      } else {
        setState(() {
          error = 'Une erreur est survenue.';
        });
      }
    } else {
      setState(() {
        error = 'Les mots de passe sont différents, recommencez';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Identifiant'),
            onChanged: (value) => username = value,
            validator: _validateRequired,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Mot de passe'),
            obscureText: true,
            onChanged: (value) => password = value,
            validator: _validateRequired,
          ),
          TextFormField(
            decoration:
                const InputDecoration(labelText: 'Confirmer Mot de passe'),
            obscureText: true,
            onChanged: (value) => password_bis = value,
            validator: _validateRequired,
          ),
          const SizedBox(height: 16),
          if (error != null)
            Text(error!,
                style: theme.textTheme.labelMedium!
                    .copyWith(color: theme.colorScheme.error)),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Connexion'),
          ),
        ],
      ),
    );
  }
}
