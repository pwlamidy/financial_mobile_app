class Stock {
  final String name;
  final String ticker;
  final Map<String, dynamic> prices;

  Stock(this.name, this.ticker, this.prices);

  static Stock fromJson(Map<String, dynamic> json) {
    return Stock(json['name'], json['ticker'], json['Time_Series_(5min)']);
  }
}
