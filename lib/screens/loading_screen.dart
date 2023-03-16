import 'package:flutter/material.dart';
import 'package:garasu/providers/coin_provider.dart';
import 'package:garasu/screens/home_screen.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<CoinProvider>(context, listen: false).fetchCoins(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return HomeScreen();
        } else {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}