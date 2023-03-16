import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:garasu/models/coin.dart';
import 'package:garasu/services/coin_gecko_api.dart';
import 'package:garasu/services/portfolio_storage.dart';

class CoinProvider extends ChangeNotifier {
  List<Coin> _coins = [];
  List<Coin> _portfolioCoins = [];

  List<Coin> get coinsList => _coins;
  List<Coin> get portfolioCoins => _portfolioCoins;

  final CoinGeckoApi _coinGeckoApi = CoinGeckoApi();

  Future<bool> fetchCoins() async {
    try {
      _coins = await _coinGeckoApi.fetchCoinsList();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  void addToPortfolio({required Coin coin, required double quantity}) {
    int index = _portfolioCoins.indexWhere((element) => element.id == coin.id);
    if (index != -1) {
      _portfolioCoins[index].quantity += quantity;
    } else {
      _portfolioCoins.add(coin.copyWith(quantity: quantity));
    }
    _updatePortfolio();
  }

  void subtractFromPortfolio({required Coin coin, required double quantity}) {
    int index = _portfolioCoins.indexWhere((element) => element.id == coin.id);
    if (index != -1) {
      _portfolioCoins[index].quantity -= quantity;
      if (_portfolioCoins[index].quantity <= 0) {
        _portfolioCoins.removeAt(index);
      }
    }
    _updatePortfolio();
  }

  void removeAllFromPortfolio(Coin coin) {
    _portfolioCoins.removeWhere((element) => element.id == coin.id);
    _updatePortfolio();
  }

  void setPortfolio(List<Coin> coins) {
    _portfolioCoins = coins;
    notifyListeners();
  }

  double totalPortfolioValue() {
    return _portfolioCoins.fold(
        0.0, (total, coin) => total + (coin.price * coin.quantity));
  }

  void _updatePortfolio() {
    PortfolioStorage.savePortfolio(_portfolioCoins);
    notifyListeners();
  }
}