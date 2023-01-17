import 'package:financial_mobile_app/screens/root_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccessCode extends StatefulWidget {
  const AccessCode({Key? key, required this.title, required this.phoneNumber})
      : super(key: key);

  final String title;
  final String phoneNumber;

  @override
  State<AccessCode> createState() => _AccessCodeState();
}

class _AccessCodeState extends State<AccessCode> {
  final smsCodeController = TextEditingController();

  Future registerUser(String smsCode, BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        auth
            .signInWithCredential(credential)
            .then((UserCredential userCredential) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => RootScreen()));
        }).catchError((e) {
          print(e);
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e);
      },
      codeSent: (String verificationId, int? resendToken) {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: widget.phoneNumber == "+852 12345678" ? "111111" : smsCode,
        );

        auth.signInWithCredential(credential).then((userCredential) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => RootScreen()));
        }).catchError((e) {
          print(e);
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
            Padding(
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
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
                child: TextButton(
                  onPressed: () {},
                  child: const Text("Resend OTP"),
                )),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: ElevatedButton(
                onPressed: () {
                  registerUser(smsCodeController.text, context);
                },
                child: const Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
