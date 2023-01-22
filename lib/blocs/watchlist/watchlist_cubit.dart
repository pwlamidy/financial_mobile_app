import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:financial_mobile_app/models/stock.dart';

part 'watchlist_state.dart';

class WatchlistCubit extends Cubit<WatchlistState> {
  WatchlistCubit() : super(WatchlistState([]));

  void addToWatchlist(stock) {
    state.watchlist = [...state.watchlist, stock];
    emit(WatchlistState(state.watchlist));
  }

  void deleteFromWatchlist(stock) {
    state.watchlist.remove(stock);
    state.watchlist = [...state.watchlist];
    emit(WatchlistState(state.watchlist));
  }

  @override
  void onChange(Change<WatchlistState> change) {
    super.onChange(change);
    print(change);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
}
