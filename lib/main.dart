import 'dart:convert';
import 'dart:io';

import 'package:expense_cal/widgets/new_transaction.dart';
import 'package:flutter/material.dart';
import './models/transaction.dart';
import 'widgets/chart.dart';
import 'widgets/transaction_list.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // errorColor: Colors.grey,
        primarySwatch: Colors.cyan,
        fontFamily: 'QuickSand',
        textTheme: ThemeData.light().textTheme.copyWith(
                titleMedium: const TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            )),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
      title: 'Personal Expenses',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Transaction> _userTransactions = [];
  @override
  void initState() {
    super.initState();
    _loadTransactions().then(
      (transactionsString) {
        if (transactionsString.isNotEmpty) {
          final transactionsList =
              json.decode(transactionsString) as List<dynamic>;
          setState(
            () {
              _userTransactions = transactionsList
                  .map<Transaction>((tx) => Transaction.fromMap(tx))
                  .toList();
            },
          );
        }
      },
    );
  }

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/transactions.txt');
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where(
      (tx) {
        return tx.date.isAfter(
          DateTime.now().subtract(
            Duration(days: 7),
          ),
        );
      },
    ).toList();
  }

  Future<void> _addNewTrans(
      String txTitle, double txAmt, DateTime chosenDate) async {
    final newTX = Transaction(
        id: DateTime.now().toString(),
        amount: txAmt,
        date: chosenDate,
        title: txTitle);
    setState(() {
      _userTransactions.add(newTX);
    });
    final file = await _getLocalFile();
    final transactionsString =
        json.encode(_userTransactions.map((tx) => tx.toMap()).toList());
    await file.writeAsString(transactionsString);
  }

  Future<void> _deleteTransaction(String id) async {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
    final file = await _getLocalFile();
    final transactionsString =
        json.encode(_userTransactions.map((tx) => tx.toMap()).toList());
    await file.writeAsString(transactionsString);
  }

  Future<String> _loadTransactions() async {
    try {
      final file = await _getLocalFile();
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      return '';
    }
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Expenses'),
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
            Chart(_recentTransactions),
            TransactionList(
              transactions: _userTransactions,
              deleteTx: _deleteTransaction,
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
