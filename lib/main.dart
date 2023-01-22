import 'package:financial_mobile_app/blocs/nav/navigation_cubit.dart';
import 'package:financial_mobile_app/router/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const FinanceApp());
}

class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

  static final GoRouter router = AppRouter().router;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NavigationCubit>(
        create: (context) => NavigationCubit(),
        child: MaterialApp.router(
          title: 'Finance App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routerConfig: router,
        ));
  }
}
