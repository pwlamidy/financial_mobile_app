part of 'stock_cubit.dart';

class StockState extends Equatable {
  final Stock? stock;

  StockState(this.stock);

  @override
  List<Object?> get props => [this.stock];
}