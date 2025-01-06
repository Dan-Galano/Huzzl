import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSample8 extends StatefulWidget {
  const BarChartSample8({super.key});

  final Color barBackgroundColor = const Color(0xffa1afd2);
  final Color barColor = const Color(0xff38a0b3);

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartSample8> {
  Map<int, int> subscribersByMonth = {};
  bool isLoading = true;
  bool showAvg = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    subscribersByMonth = await fetchSubscribersByMonth();
    setState(() {
      isLoading = false;
    });
  }

  Future<Map<int, int>> fetchSubscribersByMonth() async {
    try {
      var subscribersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('subscriptionType', isEqualTo: 'premium')
          .get();

      Map<int, int> subscribersByMonth = {};

      for (var doc in subscribersSnapshot.docs) {
        Timestamp timestamp = doc['dateSubscribed'];
        DateTime dateSubscribed = timestamp.toDate();
        int month = dateSubscribed.month;

        // Increment the count for the month
        if (subscribersByMonth.containsKey(month)) {
          subscribersByMonth[month] = subscribersByMonth[month]! + 1;
        } else {
          subscribersByMonth[month] = 1;
        }
      }

      return subscribersByMonth;
    } catch (e) {
      print("Error fetching users (subscribers): $e");
      return {};
    }
  }

  double calculateAverage() {
    if (subscribersByMonth.isEmpty) return 0.0;

    int totalSubscribers = subscribersByMonth.values.fold(0, (a, b) => a + b);
    return totalSubscribers / subscribersByMonth.length;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : AspectRatio(
            aspectRatio: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const SizedBox(
                    height: 32,
                  ),
                  Expanded(
                    child: BarChart(
                      actualData(),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: widget.barColor,
          borderRadius: BorderRadius.zero,
          width: 22,
          borderSide: BorderSide(color: widget.barColor, width: 2.0),
        ),
      ],
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC'
    ];

    // Check to ensure value is within the correct range
    if (value.toInt() >= 1 && value.toInt() <= 12) {
      Widget text = Text(
        months[value.toInt() - 1],
        style: style,
      );

      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 16,
        child: text,
      );
    } else {
      return Container();
    }
  }

  BarChartData actualData() {
    return BarChartData(
      maxY: (subscribersByMonth.values.isNotEmpty
              ? subscribersByMonth.values.reduce(max)
              : 0)
          .toDouble(),
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          axisNameWidget: const Text('Month'),
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(
          axisNameWidget: Text('Revenue'),
          sideTitles: SideTitles(
            reservedSize: 30,
            interval: 1,
            showTitles: true,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(12, (index) {
        int month = index + 1;
        double count = subscribersByMonth[month]?.toDouble() ?? 0;
        return makeGroupData(month, count);
      }),
      gridData: const FlGridData(show: false),
    );
  }
}
