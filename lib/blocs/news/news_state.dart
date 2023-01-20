part of 'news_cubit.dart';

class NewsState extends Equatable {
  final List<News>? news;

  NewsState(this.news);

  @override
  List<Object?> get props => [this.news];
}