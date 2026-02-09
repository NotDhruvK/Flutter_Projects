import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  // C L A S S  V A R I B L E S
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 670,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Garlic Bread',
      amount: 220,
      date: DateTime.now(),
      category: Category.food,
    ),
  ];

  final Widget fallBackContent = const Center(
    child: Text('No Expenses found! \nStart adding some...'),
  );

  // C L A S S  M E T H O D S

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        persist: false,
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted!'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
    // print(_registeredExpenses.length);
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return NewExpense(onAddExpense: _addExpense);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),

      body: Column(
        children: [
          Chart(expenses: _registeredExpenses),
          Expanded(
            child: _registeredExpenses.isEmpty
                ? fallBackContent
                : ExpensesList(
                    expenses: _registeredExpenses,
                    onRemoveExpense: _removeExpense,
                  ),
          ),
        ],
      ),
    );
  }
}
