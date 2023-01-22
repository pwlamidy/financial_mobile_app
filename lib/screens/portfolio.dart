import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_mobile_app/blocs/watchlist/watchlist_cubit.dart';
import 'package:financial_mobile_app/models/stock.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Portfolio extends StatefulWidget {
  const Portfolio({Key? key}) : super(key: key);

  @override
  State<Portfolio> createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {
  CollectionReference stocksCollection =
      FirebaseFirestore.instance.collection("stocks");
  CollectionReference watchListsCollection =
      FirebaseFirestore.instance.collection("watchlists");

  final WatchlistCubit _watchlistCubit = WatchlistCubit();

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  void initState() {
    super.initState();

    watchListsCollection
        .where("uid",
            isEqualTo: FirebaseAuth.instance.currentUser?.uid.toString())
        .get()
        .then((watchListsRef) {
      if (watchListsRef.docs.isNotEmpty) {
        List<dynamic> userWatchList = watchListsRef.docs.first.get("list");

        for (var w in userWatchList) {
          stocksCollection
              .where("ticker", isEqualTo: w)
              .get()
              .then((stockData) {
            final name = stockData.docs.first.get("name");
            final ticker = stockData.docs.first.get("ticker");
            Map<String, dynamic> prices =
                stockData.docs.first.get("Time_Series_(5min)");

            // Sort prices by increasing timestamp
            prices = Map.fromEntries(prices.entries.toList()
              ..sort((e1, e2) => e1.key.compareTo(e2.key)));

            Stock s = Stock(name, ticker, prices);

            _watchlistCubit.addToWatchlist(s);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: BlocProvider(
        create: (_) => _watchlistCubit,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 20.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Portfolio",
                        style: TextStyle(fontSize: 25),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.0, left: 20.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Profit/Loss",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text(
                              "Apple",
                              style: TextStyle(fontSize: 20.0),
                            ),
                            Spacer(),
                            Text(
                              "+5%",
                              style: TextStyle(
                                  color: Colors.green, fontSize: 20.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text(
                              "Tesla",
                              style: TextStyle(fontSize: 20.0),
                            ),
                            Spacer(),
                            Text(
                              "-5%",
                              style:
                                  TextStyle(color: Colors.red, fontSize: 20.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.0, left: 20.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Watchlist",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                BlocBuilder<WatchlistCubit, WatchlistState>(
                    builder: (context, state) {
                  return Column(
                    children: state.watchlist.map(
                      (w) {
                        double latestPrice =
                            double.parse(w.prices.values.last["close"]);
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 10.0, left: 10.0, right: 10.0),
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "${w.name}",
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Text(
                                        "\$$latestPrice",
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        _watchlistCubit.deleteFromWatchlist(w);

                                        final watchListsRef =
                                            await watchListsCollection
                                                .where("uid",
                                                    isEqualTo: FirebaseAuth
                                                        .instance
                                                        .currentUser
                                                        ?.uid
                                                        .toString())
                                                .get();

                                        watchListsRef.docs.first.reference
                                            .update({
                                          "list": state.watchlist
                                              .map((s) => s.ticker)
                                              .toList()
                                        }).then((value) {
                                          developer.log(
                                              "DocumentSnapshot successfully updated!");
                                          setState(() {
                                            watchListsCollection =
                                                FirebaseFirestore.instance
                                                    .collection("watchlists");
                                          });
                                        }).onError((error, stackTrace) {
                                          developer.log(
                                              "Error updating document $error");
                                        });
                                      },
                                      child: Ink(
                                        child: Icon(Icons.close),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
