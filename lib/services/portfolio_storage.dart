import 'dart:convert';
import 'package:garasu/models/coin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PortfolioStorage {
  static const String _portfolioKey = 'portfolio';

  static Future<void> savePortfolio(List<Coin> coins) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String portfolioString = json.encode(coins.map((coin) => coin.toJson()).toList());
    await prefs.setString(_portfolioKey, portfolioString);
  }

  static Future<List<Coin>> loadPortfolio() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? portfolioString = prefs.getString(_portfolioKey);

    if (portfolioString != null) {
      List<dynamic> portfolioJson = json.decode(portfolioString);
      return portfolioJson.map((coinJson) => Coin.fromJson(coinJson)).toList();
    } else {
      return [];
    }
  }
}