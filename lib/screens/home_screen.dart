import 'package:flutter/material.dart';
import 'package:garasu/models/coin.dart';
import 'package:garasu/providers/coin_provider.dart';
import 'package:garasu/widgets/coin_list_item.dart';
import 'package:garasu/widgets/coin_search_delegate.dart';
import 'package:garasu/widgets/portfolio_coin_list_item.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:garasu/services/portfolio_storage.dart';

import '../providers/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final NumberFormat currencyFormat =
  NumberFormat.currency(locale: 'en_US', symbol: '\$', decimalDigits: 2);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchCoins();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _fetchCoins() async {
    await Provider.of<CoinProvider>(context, listen: false).fetchCoins();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _savePortfolio(context);
    }
  }

  Future<void> _savePortfolio(BuildContext context) async {
    final coins = Provider.of<CoinProvider>(context, listen: false).portfolioCoins;
    await PortfolioStorage.savePortfolio(coins);
  }

  void showFetchStatus(BuildContext context, bool success) {
    final snackBar = SnackBar(
      content: Text(
          success ? 'Coins fetched successfully!' : 'Failed to fetch coins.'),
      duration: Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _loadPortfolio() async {
    final coins = await PortfolioStorage.loadPortfolio();
    final coinProvider = Provider.of<CoinProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      coinProvider.setPortfolio(coins);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Garasu'),
          actions: [
            IconButton(
              icon: Icon(
                Provider.of<ThemeProvider>(context).themeData.brightness == Brightness.light
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
              onPressed: () {
                Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
              },
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                final Coin? selectedCoin = await showSearch(
                  context: context,
                  delegate: CoinSearchDelegate(
                    Provider.of<CoinProvider>(context, listen: false).coinsList,
                  ),
                );
                if (selectedCoin != null) {
                  Provider.of<CoinProvider>(context, listen: false)
                      .addToPortfolio(coin: selectedCoin, quantity: 1.0);
                }
              },
            ),

          ],
        ),
        body: RefreshIndicator(
        onRefresh: () async {
      bool success = await Provider.of<CoinProvider>(context, listen: false)
          .fetchCoins();
      showFetchStatus(context, success);
    },
          child: Consumer<CoinProvider>(
            builder: (context, coinProvider, _) {
              return ListView.builder(
                itemCount: coinProvider.coinsList.length,
                itemBuilder: (context, index) {
                  return CoinListItem(coin: coinProvider.coinsList[index]);
                },
              );
            },
          ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('My Portfolio'),
                    Selector<CoinProvider, double>(
                      selector: (_, coinProvider) => coinProvider.totalPortfolioValue(),
                      builder: (context, totalValue, _) {
                        return Text(
                          'Total: ${currencyFormat.format(totalValue)}',
                          style: TextStyle(fontSize: 18),
                        );
                      },
                    ),
                  ],
                ),
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 300),
                        child: SingleChildScrollView(
                          child: SizedBox(
                            width: 300,
                            child: Consumer<CoinProvider>(
                              builder: (context, coinProvider, _) {
                                return Container(
                                  height: 300,
                                  width: MediaQuery.of(context).size.width,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: coinProvider.portfolioCoins.map((coin) {
                                        return PortfolioCoinListItem(
                                          coin: coin,
                                          onRemove: (double _) {
                                            coinProvider.removeAllFromPortfolio(coin);
                                            Navigator.of(context).pop();
                                          },
                                          onAdd: (double amount) {
                                            coinProvider.addToPortfolio(
                                                coin: coin, quantity: amount);
                                          },
                                          onSubtract: (double amount) {
                                            coinProvider.subtractFromPortfolio(
                                                coin: coin, quantity: amount);
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.account_balance_wallet),
      ),
    );
  }
}