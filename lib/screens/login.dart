import 'package:financial_mobile_app/screens/access_code.dart';
import 'package:financial_mobile_app/screens/sign_up.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Financial Mobile App"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 60.0),
                child: Center(
                  child: SizedBox(
                    height: 150,
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Mobile No.',
                      hintText: 'Enter valid mobile no.'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const AccessCode()));
                  },
                  child: const Text('Submit'),
                ),
              ),
              const SizedBox(
                height: 130,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SignUp()));
                },
                child: const Text("Don't have an account?"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
