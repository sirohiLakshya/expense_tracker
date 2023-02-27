import 'package:expense_cal/widgets/new_transaction.dart';
import 'package:flutter/material.dart';
import './models/transaction.dart';
import 'widgets/transaction_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    Transaction(
      amount: 50.01,
      date: DateTime.now(),
      id: 't1',
      title: 'Shoes',
    ),
    Transaction(
      amount: 20.56,
      date: DateTime.now(),
      id: 't2',
      title: 'Grocery',
    )
  ];

  void _addNewTrans(String txTitle, double txAmt) {
    final newTX = Transaction(
        id: DateTime.now().toString(),
        amount: txAmt,
        date: DateTime.now(),
        title: txTitle);
    setState(() {
      _userTransactions.add(newTX);
    });
  }

  void _startNewTrnx(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          child: NewTransaction(_addNewTrans),
          onTap: () {},
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter App'),
        actions: [
          IconButton(
            onPressed: () => _startNewTrnx(context),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              color: Colors.amber,
              elevation: 5,
              child: Container(
                width: double.infinity,
                height: 50,
                child: Text(
                  'CHART',
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            TransactionList(
              transactions: _userTransactions,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startNewTrnx(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
