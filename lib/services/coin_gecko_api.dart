import 'dart:convert';
import 'package:garasu/models/coin.dart';
import 'package:http/http.dart' as http;

class CoinGeckoApi {
  final String _baseUrl = 'https://api.coingecko.com/api/v3';

  Future<List<Coin>> fetchCoinsList({int page = 1, int perPage = 100}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=$perPage&page=$page&sparkline=false&price_change_percentage=24h'),
    );

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((coin) => Coin.fromJson(coin)).toList();
    } else {
      throw Exception('Failed to load coins data');
    }
  }

  Future<Coin> fetchCoinDetails(String coinId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/coins/$coinId?localization=false&tickers=false&community_data=false&developer_data=false&sparkline=false'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return Coin.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load coin details');
    }
  }
}