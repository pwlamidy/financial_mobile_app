import 'package:flutter/material.dart';

class InstrumentSearch extends StatefulWidget {
  const InstrumentSearch({Key? key}) : super(key: key);

  @override
  State<InstrumentSearch> createState() => _InstrumentSearchState();
}

class _InstrumentSearchState extends State<InstrumentSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Financial Mobile App"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20.0, left: 20.0),
              child: Row(
                children: <Widget>[
                  const Text(
                    "Search",
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
