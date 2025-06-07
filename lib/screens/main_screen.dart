import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'add_expense_screen.dart';
import 'add_income_screen.dart';
import 'grafics_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ResumoGrafico(),
    AddExpenseScreen(),
    AddIncomeScreen(),
  ];

  final List<String> _titles = [
    'Resumo',
    'Nova Despesa',
    'Nova Receita',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Resumo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.remove_circle),
            label: 'Despesa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Receita',
          ),
        ],
      ),
    );
  }
}
