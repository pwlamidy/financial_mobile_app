class Stock {
  final String name;
  final String ticker;

  Stock(this.name, this.ticker);

  static Stock fromJson(Map<String, dynamic> json) {
    return Stock(json['name'], json['ticker']);
  }
}
