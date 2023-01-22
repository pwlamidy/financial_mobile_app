import 'package:financial_mobile_app/blocs/login/login_cubit.dart';
import 'package:financial_mobile_app/screens/root_screen.dart';
import 'package:financial_mobile_app/utils/login_status.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:developer' as developer;

class AccessCode extends StatefulWidget {
  const AccessCode({Key? key, required this.title, required this.phoneNumber})
      : super(key: key);

  final String title;
  final String phoneNumber;

  @override
  State<AccessCode> createState() => _AccessCodeState();
}

class _AccessCodeState extends State<AccessCode> {
  final _loginCubit = LoginCubit();
  final smsCodeController = TextEditingController();

  String _verificationId = "";

  @override
  void initState() {
    super.initState();
    registerUser();
  }

  Future registerUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        auth
            .signInWithCredential(credential)
            .then((UserCredential userCredential) {
          _loginCubit.getLoginStatus(LoginStatus.success);
        }).catchError((e) {
          print(e);
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e);
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  void dispose() {
    smsCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _loginCubit,
      child: BlocListener<LoginCubit, LoginState>(
        listener: (BuildContext context, state) {
          if (state.loginStatus == LoginStatus.success) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => RootScreen()));
          }
        },
        bloc: _loginCubit,
        child: Scaffold(
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
                Padding(
                  padding: EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  child: TextField(
                    obscureText: true,
                    controller: smsCodeController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'OTP',
                        hintText: 'Enter OTP received'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: ElevatedButton(
                    onPressed: () {
                      PhoneAuthCredential credential =
                      PhoneAuthProvider.credential(
                        verificationId: _verificationId,
                        smsCode: smsCodeController.text,
                      );

                      FirebaseAuth.instance
                          .signInWithCredential(credential)
                          .then((userCredential) {
                        _loginCubit.getLoginStatus(LoginStatus.success);
                      }).catchError((e) {
                        print(e);
                      });
                    },
                    child: const Text("Submit"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
