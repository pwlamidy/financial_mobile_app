import 'dart:math';

import 'package:financial_mobile_app/blocs/stock/stock_cubit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StockPriceChart extends StatefulWidget {
  const StockPriceChart({super.key});

  @override
  State<StatefulWidget> createState() => StockPriceChartState();
}

class StockPriceChartState extends State<StockPriceChart> {
  final Color gainBarColor = const Color(0xff53fdd7);
  final Color lossBarColor = const Color(0xffff5182);
  final double width = 7;
  final double minPriceInterval = 0;
  final double maxPriceInterval = 20;
  final double maxY = 20;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  // For scaling
  double minPrice = 0;
  double maxPrice = 0;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();

    List<BarChartGroupData> items = [];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
  }

  double _scalePrice(double price) {
    return (price - minPrice) / (maxPrice - minPrice) * maxY;
  }

  List<BarChartGroupData> _buildBarGroups(Map<String, dynamic> stockPrices) {
    List<BarChartGroupData> barGroups = [];
    int i = 0;

    stockPrices.forEach((key, value) {
      barGroups.add(makeGroupData(
        i++,
        _scalePrice(double.parse(value["low"])),
        _scalePrice(double.parse(value["high"])),
        _scalePrice(double.parse(value["open"])),
        _scalePrice(double.parse(value["close"])),
      ));
    });

    return barGroups;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StockCubit, StockState>(
      listener: (context, state) {
        Map<String, dynamic>? stockPrices = state.stock?.prices;

        double newMinPrice = double.maxFinite;
        double newMaxPrice = double.minPositive;
        stockPrices?.forEach((key, value) {
          newMinPrice = min(double.parse(value["low"]), newMinPrice);
          newMaxPrice = max(double.parse(value["high"]), newMaxPrice);
        });

        setState(() {
          minPrice = newMinPrice;
          maxPrice = newMaxPrice;
        });
      },
      builder: (context, state) {
        Map<String, dynamic>? stockPrices = state.stock?.prices;

        if (stockPrices == null) {
          return Container();
        }

        return AspectRatio(
          aspectRatio: 1,
          child: Card(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            color: const Color(0xff2c4260),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        maxY: maxY,
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.grey,
                            getTooltipItem: (a, b, c, d) => null,
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                              getTitlesWidget: (value, titleMeta) =>
                                  bottomTitles(value, titleMeta,
                                      stockPrices.keys.toList()),
                              reservedSize: 42,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 1,
                              getTitlesWidget: (value, titleMeta) => leftTitles(
                                value,
                                titleMeta,
                                stockPrices.values.toList(),
                              ),
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        barGroups: _buildBarGroups(stockPrices),
                        gridData: FlGridData(show: true),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget leftTitles(double value, TitleMeta meta, List<dynamic> stockPrices) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    String text;
    if (value == minPriceInterval) {
      text = '${minPrice.floor() + 0.0}';
    } else if (value == (maxPriceInterval + minPriceInterval) / 2) {
      text = '${(maxPrice.ceil() + minPrice.floor()) / 2}';
    } else if (value == maxPriceInterval) {
      text = '${maxPrice.ceil() + 0.0}';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(
      double value, TitleMeta meta, List<String> stockPricesTitle) {
    final titles = stockPricesTitle;

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(
      int x, double low, double high, double open, double close) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: high,
          fromY: low,
          color: open > close ? gainBarColor : lossBarColor,
          width: width,
        ),
      ],
    );
  }

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }
}
