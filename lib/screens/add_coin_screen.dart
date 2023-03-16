import 'package:flutter/material.dart';
import 'package:garasu/models/coin.dart';

class AddCoinScreen extends StatefulWidget {
  final Coin coin;

  AddCoinScreen({required this.coin});

  @override
  _AddCoinScreenState createState() => _AddCoinScreenState();
}

class _AddCoinScreenState extends State<AddCoinScreen> {
  final _formKey = GlobalKey<FormState>();
  double _quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Coin to Portfolio'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the quantity';
                  }
                  return null;
                },
                onChanged: (value) {
                  _quantity = double.parse(value);
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Add coin to portfolio
                    Navigator.pop(context, _quantity);
                  }
                },
                child: Text('Add Coin'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
