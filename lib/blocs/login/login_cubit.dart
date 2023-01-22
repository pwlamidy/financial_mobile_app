import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:financial_mobile_app/utils/login_status.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState(LoginStatus.fail));

  void getLoginStatus(LoginStatus loginStatus) {
    emit(LoginState(loginStatus));
  }
}
