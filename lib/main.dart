import 'package:flutter/material.dart';
import 'package:garasu/screens/home_screen.dart';
import 'package:garasu/providers/coin_provider.dart';
import 'package:provider/provider.dart';
import 'package:garasu/providers/theme_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CoinProvider()),
        ChangeNotifierProvider(
            create: (_) => ThemeProvider(themeData: ThemeData.light())),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Garasu',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: HomeScreen(),
    );
  }

}