import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function selectHandler;
  const NewTransaction(this.selectHandler, {super.key});

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amtController = TextEditingController();
  DateTime? _selectedDate;

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then(
      (pickedDate) {
        if (pickedDate == null) {
          return;
        }
        setState(() {
          _selectedDate = pickedDate;
        });
      },
    );
  }

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amtController.text);
    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }
    widget.selectHandler(enteredTitle, enteredAmount, _selectedDate);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 55,
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  labelText: 'Title',
                ),
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
              ),
            ),
            const SizedBox(
              width: double.infinity,
              height: 15,
            ),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  labelText: 'Amount',
                ),
                controller: _amtController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
              ),
            ),
            const SizedBox(
              width: double.infinity,
              height: 10,
            ),
            SizedBox(
              height: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 240,
                    padding: const EdgeInsets.all(2),
                    child: Text(
                      _selectedDate == null
                          ? ''
                          : 'Picked Date: ${DateFormat.yMd().format(_selectedDate!)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _presentDatePicker,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, elevation: 0),
                    child: Text(
                      'Choose Date',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColorLight),
              onPressed: () {
                _submitData();
              },
              child: Text(
                'Add Transaction',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
