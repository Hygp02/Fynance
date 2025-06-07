import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  RegisterScreen({super.key});

  void register(BuildContext context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: senhaController.text,
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Erro ao registrar")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastro")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: senhaController, decoration: const InputDecoration(labelText: "Senha"), obscureText: true),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () => register(context), child: const Text("Cadastrar"))
          ],
        ),
      ),
    );
  }
}
