import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String formatarData(dynamic timestamp) {
    if (timestamp is Timestamp) {
      DateTime date = timestamp.toDate();
      return DateFormat('dd/MM/yyyy – HH:mm').format(date);
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('Usuário não autenticado'));
    }

    final expensesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('gastos');

    return StreamBuilder<QuerySnapshot>(
      stream: expensesRef.orderBy('data', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return const Center(child: Text('Nenhum gasto registrado'));
        }
        return ListView(
          children: docs.map((doc) {
            final data = doc.data()! as Map<String, dynamic>;
            return ListTile(
              title: Text(data['descricao'] ?? 'Sem descrição'),
              subtitle: Text(formatarData(data['data'])),
              trailing: Text("R\$ ${data['valor'] ?? '0'}"),
            );
          }).toList(),
        );
      },
    );
  }
}
