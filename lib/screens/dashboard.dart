import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20.0, left: 20.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Dashboard",
                      style: TextStyle(fontSize: 25),
                    ),
                    Spacer(),
                    IconButton(
                      padding: EdgeInsets.only(right: 20.0),
                      onPressed: () {
                        Navigator.pushNamed(context, "/search");
                      },
                      icon: Icon(
                        Icons.search,
                        size: 40,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
