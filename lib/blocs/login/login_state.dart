part of 'login_cubit.dart';

class LoginState extends Equatable {
  final LoginStatus loginStatus;

  LoginState(this.loginStatus);

  @override
  List<Object> get props => [this.loginStatus];
}