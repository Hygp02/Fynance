import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ResumoGrafico extends StatefulWidget {
  const ResumoGrafico({super.key});

  @override
  State<ResumoGrafico> createState() => _ResumoGraficoState();
}

class _ResumoGraficoState extends State<ResumoGrafico> {
  double totalReceitas = 0;
  double totalDespesas = 0;
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final receitasSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('receitas')
        .get();

    final despesasSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('gastos')
        .get();

    double receitas = 0;
    double despesas = 0;

    for (var doc in receitasSnap.docs) {
      receitas += (doc['valor'] as num).toDouble();
    }

    for (var doc in despesasSnap.docs) {
      despesas += (doc['valor'] as num).toDouble();
    }

    setState(() {
      totalReceitas = receitas;
      totalDespesas = despesas;
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (totalReceitas == 0 && totalDespesas == 0) {
      return const Center(
        child: Text('Sem dados para mostrar ainda'),
      );
    }

    final totalGeral = totalReceitas + totalDespesas;
    final porcentagemReceita = (totalReceitas / totalGeral) * 100;
    final porcentagemDespesa = (totalDespesas / totalGeral) * 100;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Resumo Financeiro',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Text('Total de Receitas: R\$ ${totalReceitas.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.green, fontSize: 16)),
          Text('Total de Despesas: R\$ ${totalDespesas.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.red, fontSize: 16)),
          const SizedBox(height: 24),
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 8,
                centerSpaceRadius: 50,
                sections: [
                  PieChartSectionData(
                    color: Colors.green,
                    value: totalReceitas,
                    title: '${porcentagemReceita.toStringAsFixed(1)}%',
                    radius: 80,
                    titleStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: Colors.red,
                    value: totalDespesas,
                    title: '${porcentagemDespesa.toStringAsFixed(1)}%',
                    radius: 80,
                    titleStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
