import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:garasu/models/coin.dart';
import 'package:provider/provider.dart';

import '../providers/coin_provider.dart';
import '../screens/add_coin_screen.dart';

class CoinListItem extends StatelessWidget {
  final NumberFormat currencyFormat = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 2,
  );
  final Coin coin;

  CoinListItem({required this.coin});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final quantity = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddCoinScreen(coin: coin),
          ),
        );
        if (quantity != null) {
          Provider.of<CoinProvider>(context, listen: false).addToPortfolio(coin: coin, quantity: quantity);
        }
      },
      child: Card(
        child: ListTile(
          leading: Image.network(
            coin.image,
            width: 50,
            height: 50,
            fit: BoxFit.contain,
          ),
          title: Text(coin.name),
          subtitle: Text(
            '${coin.symbol.toUpperCase()} - ${currencyFormat.format(coin.currentPrice)}',
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${coin.priceChangePercentage24h.toStringAsFixed(2)}%',
                style: TextStyle(
                  color: coin.priceChangePercentage24h >= 0
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}