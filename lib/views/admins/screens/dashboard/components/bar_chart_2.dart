import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSample2 extends StatefulWidget {
  const BarChartSample2({super.key});

  @override
  State<BarChartSample2> createState() => _BarChartSample2State();
}

class _BarChartSample2State extends State<BarChartSample2> {
  Map<int, int> subscribersByMonth = {};
  bool isLoading = true;

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

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : AspectRatio(
            aspectRatio: 1.70,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BarChart(mainData()),
            ),
          );
  }

  BarChartData mainData() {
    List<BarChartGroupData> barGroups = subscribersByMonth.entries
        .map((entry) => BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value.toDouble(),
                  color: Colors.blueAccent,
                ),
              ],
            ))
        .toList();

    int maxCount = subscribersByMonth.values.isNotEmpty
        ? subscribersByMonth.values.reduce((a, b) => a > b ? a : b)
        : 1;

    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: maxCount.toDouble(),
      barGroups: barGroups,
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) => bottomTitleWidgets(value),
          ),
        ),
        leftTitles: const AxisTitles(
          axisNameWidget: Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Text(
              "Subscribers",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      gridData: const FlGridData(show: true),
    );
  }

  Widget bottomTitleWidgets(double value) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
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

    if (value >= 1 && value <= 12) {
      return Text(months[value.toInt() - 1], style: style);
    } else {
      return const Text('');
    }
  }
}
