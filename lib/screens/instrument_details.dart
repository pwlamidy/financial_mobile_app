import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financial_mobile_app/blocs/news/news_cubit.dart';
import 'package:financial_mobile_app/blocs/stock/stock_cubit.dart';
import 'package:financial_mobile_app/models/news.dart';
import 'package:financial_mobile_app/models/stock.dart';
import 'package:financial_mobile_app/widgets/stock_price_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:developer' as developer;

class InstrumentDetails extends StatefulWidget {
  const InstrumentDetails({Key? key, this.ticker}) : super(key: key);

  final String? ticker;

  @override
  State<InstrumentDetails> createState() => _InstrumentDetailsState();
}

class _InstrumentDetailsState extends State<InstrumentDetails> {
  CollectionReference stocksCollection =
      FirebaseFirestore.instance.collection("stocks");
  CollectionReference newsCollection =
      FirebaseFirestore.instance.collection("news");
  CollectionReference watchListsCollection =
      FirebaseFirestore.instance.collection("watchlists");

  final StockCubit _stockCubit = StockCubit();
  final NewsCubit _newsCubit = NewsCubit();

  bool addedToWatchlist = false;

  @override
  void initState() {
    super.initState();

    stocksCollection
        .where("ticker", isEqualTo: widget.ticker)
        .get()
        .then((stockData) {
      final name = stockData.docs.first.get("name");
      final ticker = stockData.docs.first.get("ticker");
      Map<String, dynamic> prices =
          stockData.docs.first.get("Time_Series_(5min)");

      // Sort prices by increasing timestamp
      prices = Map.fromEntries(
          prices.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));

      Stock s = Stock(name, ticker, prices);
      _stockCubit.getStock(s);
    });

    newsCollection
        .where("ticker", isEqualTo: widget.ticker)
        .get()
        .then((newsData) {
      List feed = newsData.docs.first["feed"];
      _newsCubit.getNews(feed.map((f) => News.fromJson(f)).toList());
    });

    watchListsCollection
        .where("uid",
            isEqualTo: FirebaseAuth.instance.currentUser?.uid.toString())
        .get()
        .then((watchListsRef) {
      if (watchListsRef.docs.isNotEmpty) {
        List<dynamic> userWatchList = watchListsRef.docs.first.get("list");
        if (userWatchList.contains("${widget.ticker}")) {
          setState(() {
            addedToWatchlist = true;
          });
        }
      }
    });
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  Widget stockNameWidget(BuildContext context) {
    return BlocBuilder<StockCubit, StockState>(builder: (context, state) {
      return Text(
        "${_stockCubit.state.stock?.name}",
        style: TextStyle(fontSize: 25),
      );
    });
  }

  Widget newsWidget(BuildContext context) {
    return BlocBuilder<NewsCubit, NewsState>(
      builder: (context, state) {
        if (state.news != null && state.news!.isNotEmpty) {
          return Column(
            children: state.news!
                .map(
                  (n) => Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Card(
                      child: InkWell(
                        onTap: () {
                          final Uri toLaunch = Uri.parse(n.url);
                          _launchInBrowser(toLaunch);
                        },
                        child: Ink(
                          padding: EdgeInsets.all(10.0),
                          child: Text(n.title),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          );
        }

        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => _stockCubit,
        ),
        BlocProvider(
          create: (_) => _newsCubit,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Financial Mobile App"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20.0, left: 20.0),
                child: Row(
                  children: <Widget>[
                    stockNameWidget(context),
                    Spacer(),
                    IconButton(
                      padding: EdgeInsets.only(right: 20.0),
                      onPressed: () async {
                        final watchListsRef = await watchListsCollection
                            .where("uid",
                                isEqualTo: FirebaseAuth
                                    .instance.currentUser?.uid
                                    .toString())
                            .get();

                        if (watchListsRef.docs.isEmpty) {
                          await watchListsCollection.add({
                            "uid": FirebaseAuth.instance.currentUser?.uid
                                .toString(),
                            "list": ["${widget.ticker}"]
                          });
                          setState(() {
                            addedToWatchlist = true;
                          });
                        } else {
                          List<dynamic> currentWatchList =
                              watchListsRef.docs.first.get("list");
                          if (widget.ticker != null) {
                            if (!currentWatchList
                                .contains("${widget.ticker}")) {
                              currentWatchList.add("${widget.ticker}");
                              setState(() {
                                addedToWatchlist = true;
                              });
                            } else {
                              currentWatchList.remove("${widget.ticker}");
                              setState(() {
                                addedToWatchlist = false;
                              });
                            }
                          }
                          final userWatchListRef =
                              watchListsRef.docs.first.reference;
                          userWatchListRef
                              .update({"list": currentWatchList}).then((value) {
                            developer
                                .log("DocumentSnapshot successfully updated!");
                            setState(() {
                              watchListsCollection = FirebaseFirestore.instance
                                  .collection("watchlists");
                            });
                          }).onError((error, stackTrace) {
                            developer.log("Error updating document $error");
                          });
                        }
                      },
                      icon: Icon(
                        Icons.star,
                        size: 40,
                        color: addedToWatchlist ? Colors.yellow : Colors.grey,
                      ),
                    ),
                    BlocBuilder<StockCubit, StockState>(
                      builder: (context, state) {
                        double latestPrice = 0;
                        if (state.stock?.prices != null &&
                            state.stock!.prices.isNotEmpty) {
                          latestPrice = double.parse(
                              state.stock!.prices.values.last["close"]);
                        }

                        return IconButton(
                          padding: EdgeInsets.only(right: 20.0),
                          onPressed: () {
                            Share.share('${widget.ticker} \$$latestPrice');
                          },
                          icon: Icon(
                            Icons.share,
                            size: 40,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0, bottom: 20.0),
                child: Row(
                  children: [
                    Text(
                      "${widget.ticker}",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              BlocBuilder<StockCubit, StockState>(
                builder: (context, state) {
                  return Padding(
                    padding: EdgeInsets.only(left: 20.0, bottom: 20.0),
                    child: Row(
                      children: [
                        Text(
                          "${state.stock?.prices.entries.first.key.split(" ").first}, 5m interval",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                },
              ),
              StockPriceChart(),
              newsWidget(context),
            ],
          ),
        ),
      ),
    );
  }
}
