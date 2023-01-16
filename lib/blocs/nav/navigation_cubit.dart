import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:financial_mobile_app/utils/nav_bar_items.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationState(NavbarItem.dashboard, 0));

  void getNavBarItem(NavbarItem navbarItem) {
    switch (navbarItem) {
      case NavbarItem.dashboard:
        emit(NavigationState(NavbarItem.dashboard, 0));
        break;
      case NavbarItem.portfolio:
        emit(NavigationState(NavbarItem.portfolio, 1));
        break;
    }
  }
}
