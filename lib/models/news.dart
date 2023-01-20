class News {
  final String title;
  final String url;

  News(this.title, this.url);

  static News fromJson(Map<String, dynamic> json) {
    return News(json['title'], json['url']);
  }
}
