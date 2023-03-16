import 'package:flutter/material.dart';
import 'package:garasu/models/coin.dart';
import 'package:intl/intl.dart';

class PortfolioCoinListItem extends StatelessWidget {
  final Coin coin;
  final Function(double) onRemove;
  final Function(double) onAdd;
  final Function(double) onSubtract;
  final NumberFormat currencyFormat = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 2,
  );

  PortfolioCoinListItem({
    required this.coin,
    required this.onRemove,
    required this.onAdd,
    required this.onSubtract,
  });

  Future<void> showQuantityInputDialog(
      BuildContext context, Function(double) onConfirm) async {
    double? inputQuantity;
    inputQuantity = await showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter quantity'),
          content: TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) {
              inputQuantity = double.tryParse(value);
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(inputQuantity);
              },
            ),
          ],
        );
      },
    );

    if (inputQuantity != null) {
      onConfirm(inputQuantity!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            Image.network(
              coin.image,
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    // Add this
                    child: Text(
                      '${coin.name} (${coin.symbol.toUpperCase()})',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Amount: ${coin.quantity.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Value: ${currencyFormat.format(coin.quantity * coin.currentPrice)}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle),
                        onPressed: () =>
                            showQuantityInputDialog(context, onSubtract),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle),
                        onPressed: () =>
                            showQuantityInputDialog(context, onAdd),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              // Add this IconButton
              icon: const Icon(Icons.delete),
              onPressed: () => onRemove(coin.quantity),
            ),
          ],
        ),
      ),
    );
  }
}
