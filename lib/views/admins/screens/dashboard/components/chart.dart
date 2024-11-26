import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/views/admins/controllers/menu_app_controller.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class Chart extends StatefulWidget {
  Chart({
    Key? key,
  }) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  late int counterRecruiter;
  late int counterJobseeker;
  late int counterJobPosting;
  late MenuAppController adminProvider;

  double? recruiterCount;
  double? jobseekerCount;
  double? jobPostingCount;

  int totalUsage = 0;

  @override
  void initState() {
    super.initState();
    adminProvider = Provider.of<MenuAppController>(context, listen: false);
    getCounterFunction();
  }

  void getCounterFunction() async {
    counterRecruiter = await adminProvider.recruitersCount();
    counterJobPosting = await adminProvider.jobPostCount();
    counterJobseeker = await adminProvider.jobseekersCount();

    setState(() {
      recruiterCount = counterRecruiter.toDouble();
      jobseekerCount = counterJobseeker.toDouble();
      jobPostingCount = counterJobPosting.toDouble();

      totalUsage = counterRecruiter + counterJobPosting + counterJobseeker;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (recruiterCount == null || jobseekerCount == null || jobPostingCount == null) {
      return const Center(child: CircularProgressIndicator(),);
    }
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: _getChartSections(),
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: defaultPadding),
                Text(
                  recruiterCount != null ? "$totalUsage" : "0", 
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        height: 0.5,
                      ),
                ),
                const Text("Usage")
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Dynamically generate chart sections based on fetched data
  List<PieChartSectionData> _getChartSections() {
    return [
      PieChartSectionData(
        color: primaryColor,
        value: recruiterCount ?? 0,
        showTitle: false,
        radius: 25,
      ),
      PieChartSectionData(
        color: Colors.red,
        value: jobPostingCount ?? 0,
        showTitle: false,
        radius: 22,
      ),
      PieChartSectionData(
        color: Color(0xFFFFA113),
        value: jobseekerCount ?? 0,
        showTitle: false,
        radius: 19,
      ),
    ];
  }
}
