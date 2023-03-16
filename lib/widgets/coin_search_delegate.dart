import 'package:flutter/material.dart';
import 'package:garasu/models/coin.dart';
import 'package:garasu/widgets/coin_list_item.dart';

class CoinSearchDelegate extends SearchDelegate<Coin> {
  final List<Coin> coins;

  CoinSearchDelegate(this.coins);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: theme.primaryColor,
      primaryIconTheme: theme.primaryIconTheme,
      primaryColorBrightness: theme.primaryColorBrightness,
      textTheme: theme.textTheme,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, Coin.empty());
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<Coin> results = coins
        .where((coin) =>
    coin.name.toLowerCase().contains(query.toLowerCase()) ||
        coin.symbol.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (results.isEmpty) {
      return Center(
        child: Text('No results found for "$query"'),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => close(context, results[index]),
          child: CoinListItem(coin: results[index]),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Coin> suggestions = query.isEmpty
        ? []
        : coins
        .where((coin) =>
    coin.name.toLowerCase().startsWith(query.toLowerCase()) ||
        coin.symbol.toLowerCase().startsWith(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return CoinListItem(coin: suggestions[index]);
      },
    );
  }
}
