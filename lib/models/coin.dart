class Coin {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final double currentPrice;
  final double marketCap;
  final double priceChangePercentage24h;
  double quantity;

  Coin({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.marketCap,
    required this.priceChangePercentage24h,
    this.quantity = 0,
  });

  static Coin empty() {
    return Coin(
      id: '',
      symbol: '',
      name: '',
      image: '',
      currentPrice: 0,
      priceChangePercentage24h: 0,
      marketCap: 0,
    );
  }

  Coin copyWith({
    String? id,
    String? symbol,
    String? name,
    String? image,
    double? currentPrice,
    double? priceChangePercentage24h,
    double? marketCap,
    double? quantity,
  }) {
    return Coin(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      image: image ?? this.image,
      currentPrice: currentPrice ?? this.currentPrice,
      priceChangePercentage24h: priceChangePercentage24h ?? this.priceChangePercentage24h,
      marketCap: marketCap ?? this.marketCap,
      quantity: quantity ?? this.quantity,
    );
  }

  double get price => currentPrice;

  Map<String, dynamic> toJson() => {
    'id': id,
    'symbol': symbol,
    'name': name,
    'image': image,
    'currentPrice': currentPrice,
    'marketCap': marketCap,
    'priceChangePercentage24h': priceChangePercentage24h,
    'quantity': quantity,
  };

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      currentPrice: json['current_price'].toDouble(),
      priceChangePercentage24h: json['price_change_percentage_24h'].toDouble(),
      marketCap: json['market_cap'].toDouble(),
    );
  }

  factory Coin.fromJsonWithQuantity(Map<String, dynamic> json) {
    return Coin(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      currentPrice: json['current_price'].toDouble(),
      priceChangePercentage24h: json['price_change_percentage_24h'].toDouble(),
      marketCap: json['market_cap'].toDouble(),
      quantity: json['quantity'].toDouble(),
    );
  }
}