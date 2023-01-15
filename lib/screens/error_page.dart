import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final Exception? error;

  const ErrorPage({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(error.toString());
  }
}
