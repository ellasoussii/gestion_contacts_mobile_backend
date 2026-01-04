import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void _register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
      _showError("Veuillez remplir tous les champs.");
      return;
    }

    if (password != confirm) {
      _showError("Les mots de passe ne correspondent pas.");
      return;
    }

    final user = User(name: name, email: email, password: password);
    final createdUser = await ApiService.signup(user);

    if (!mounted) return;

    if (createdUser != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Inscription réussie ! Bienvenue ${createdUser.name}")),
      );
      Navigator.pop(context); // retour à la page de login
    } else {
      _showError("Erreur lors de l'inscription. Email peut-être déjà utilisé.");
    }
  }

  void _showError(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Erreur"),
        content: Text(msg),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inscription")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Nom")),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Mot de passe")),
            TextField(controller: confirmPasswordController, obscureText: true, decoration: const InputDecoration(labelText: "Confirmer")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _register, child: const Text("Créer un compte")),
          ],
        ),
      ),
    );
  }
}
