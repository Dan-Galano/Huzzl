import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({super.key});

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
    Colors.cyanAccent,
    Colors.blueAccent,
  ];

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
          .orderBy('dateSubscribed')
          .get();

      Map<int, int> subscribersByMonth = {};

      for (var doc in subscribersSnapshot.docs) {
        Timestamp timestamp = doc['dateSubscribed'];
        DateTime dateSubscribed = timestamp.toDate();
        print(
            "PRINT FETCHED DATE BABY (${DateTime.now().millisecond}): $dateSubscribed");
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
        : Stack(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 2.20,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 18,
                    left: 12,
                    top: 24,
                    bottom: 12,
                  ),
                  child: LineChart(showAvg ? avgData() : mainData()),
                ),
              ),
              // Positioned(
              //   top: -15,
              //   right: -10,
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: SizedBox(
              //       width: 60,
              //       height: 34,
              //       child: TextButton(
              //         onPressed: () {
              //           setState(() {
              //             showAvg = !showAvg;
              //           });
              //         },
              //         child: Text(
              //           'avg',
              //           style: TextStyle(
              //             fontSize: 12,
              //             color: showAvg
              //                 ? Colors.black.withOpacity(0.5)
              //                 : Colors.black,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          );
  }

  LineChartData mainData() {
    List<FlSpot> spots = subscribersByMonth.entries
        .map((entry) =>
            FlSpot(entry.key.toDouble(), (entry.value * 499).toDouble()))
        .toList();

    var maxRevenue = subscribersByMonth.values.isNotEmpty
        ? subscribersByMonth.values
            .map((count) => count * 499)
            .reduce((a, b) => a > b ? a : b)
        : 499.0;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: maxRevenue / 5, // Adjust to reduce grid lines
        verticalInterval: 1,
      ),
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
        leftTitles: AxisTitles(
          axisNameWidget: const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Text(
              "Revenue (PHP)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 42,
            interval:
                maxRevenue / 5, // Increase interval for less frequent labels
            getTitlesWidget: (value, meta) {
              return Text('₱${value.toInt()}',
                  style: const TextStyle(fontSize: 12));
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 1,
      maxX: 12,
      minY: 0,
      maxY: maxRevenue.toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, bar, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: Colors.blue,
                strokeWidth: 1,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    double avg = calculateAverage();
    return LineChartData(
      gridData: const FlGridData(
        show: true,
        drawHorizontalLine: true,
        horizontalInterval: 1,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          axisNameWidget: const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              "Month",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) => bottomTitleWidgets(value),
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
      minX: 1,
      maxX: 12,
      minY: 0,
      maxY: avg + 1, // Adjusting to give space for the average line
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(
            12,
            (index) => FlSpot(index + 1.0, avg),
          ),
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
      ],
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
