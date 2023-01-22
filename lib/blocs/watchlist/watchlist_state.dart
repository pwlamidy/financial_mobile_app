part of 'watchlist_cubit.dart';

class WatchlistState extends Equatable {
  List<Stock> watchlist;

  WatchlistState(this.watchlist);

  @override
  List<Object?> get props => [this.watchlist];
}