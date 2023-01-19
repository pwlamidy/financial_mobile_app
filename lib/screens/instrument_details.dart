import 'package:flutter/material.dart';

class InstrumentDetails extends StatefulWidget {
  const InstrumentDetails({Key? key}) : super(key: key);

  @override
  State<InstrumentDetails> createState() => _InstrumentDetailsState();
}

class _InstrumentDetailsState extends State<InstrumentDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Financial Mobile App"),
      ),
    );
  }
}
