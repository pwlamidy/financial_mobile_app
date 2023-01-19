import 'package:financial_mobile_app/screens/instrument_search.dart';
import 'package:financial_mobile_app/screens/dashboard.dart';
import 'package:financial_mobile_app/screens/error_page.dart';
import 'package:financial_mobile_app/screens/instrument_details.dart';
import 'package:financial_mobile_app/screens/login.dart';
import 'package:financial_mobile_app/screens/portfolio.dart';
import 'package:financial_mobile_app/screens/sign_up.dart';
import 'package:financial_mobile_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class AppRouter {
  late final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const Login(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUp(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const Dashboard(),
      ),
      GoRoute(
        path: '/portfolio',
        builder: (context, state) => const Portfolio(),
      ),
      GoRoute(
        path: '/details',
        builder: (context, state) => const InstrumentDetails(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const InstrumentSearch(),
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: ErrorPage(error: state.error,),
    ),
    // TODO Add Redirect
  );
}