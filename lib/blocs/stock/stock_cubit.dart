import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:financial_mobile_app/models/stock.dart';

part 'stock_state.dart';

class StockCubit extends Cubit<StockState> {
  StockCubit() : super(StockState(null));

  void getStock(stock) {
    emit(StockState(stock));
  }

  @override
  void onChange(Change<StockState> change) {
    super.onChange(change);
    print(change);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
}
