import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AddIncomeScreen extends StatefulWidget {
  const AddIncomeScreen({super.key});

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final descController = TextEditingController();
  final valueController = TextEditingController();

  @override
  void dispose() {
    descController.dispose();
    valueController.dispose();
    super.dispose();
  }

  void saveIncome(BuildContext context) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  try {
    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('receitas');

    await ref.add({
      'descricao': descController.text,
      'valor': double.tryParse(valueController.text) ?? 0,
      'data': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Receita salva com sucesso!')),
    );

    descController.clear();
    valueController.clear();

  } catch (e) {
    print('Erro ao salvar receita: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Erro ao salvar receita')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: "Descrição"),
            ),
            TextField(
              controller: valueController,
              decoration: const InputDecoration(labelText: "Valor"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => saveIncome(context),
              child: const Text("Salvar"),
              )
          ],
        ),
      ),
    );
  }
}
