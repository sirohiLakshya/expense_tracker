import 'package:flutter/material.dart';

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  Transaction(
      {required this.id,
      required this.amount,
      required this.date,
      required this.title});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
    );
  }
}
