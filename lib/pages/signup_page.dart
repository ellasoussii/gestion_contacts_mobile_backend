import 'package:flutter/material.dart';
import '../database/db_helper.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _register() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('Erreur'),
          content: Text('Veuillez remplir tous les champs.'),
        ),
      );
      return;
    }

    try {
      // Ajouter l'utilisateur dans SQLite
      await DatabaseHelper.instance.addUser(email, password);

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Inscription réussie ✅'),
          content: Text('Bienvenue, $email !'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // fermer la dialog
                Navigator.pop(context); // revenir à LoginPage
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      // Si l'email existe déjà (unique)
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('Erreur'),
          content: Text("Cet email existe déjà."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inscription')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Mot de passe'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Créer un compte'),
            ),
          ],
        ),
      ),
    );
  }
}
