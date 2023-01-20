import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:financial_mobile_app/models/news.dart';

part 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(NewsState(null));

  void getNews(List<News> news) {
    emit(NewsState(news));
  }

  @override
  void onChange(Change<NewsState> change) {
    super.onChange(change);
    print(change);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
}
