import 'package:flutter/material.dart';

class AccessCode extends StatefulWidget {
  const AccessCode({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AccessCode> createState() => _AccessCodeState();
}

class _AccessCodeState extends State<AccessCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Financial Mobile App"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 60.0),
              child: Center(
                child: SizedBox(
                  height: 150,
                  child: Text(
                    widget.title,
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'OTP',
                    hintText: 'Enter OTP received'),
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: TextButton(
                  onPressed: () {},
                  child: const Text("Resend OTP"),
                )),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
