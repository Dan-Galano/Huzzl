import 'package:flutter/material.dart';
import 'package:huzzl_web/views/admins/models/my_files.dart';
import 'package:huzzl_web/views/admins/responsive.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import 'file_info_card.dart';

class MyFiles extends StatelessWidget {
  DateTime? startDate;
  DateTime? endDate;
  MyFiles({
    super.key,
    this.startDate,
    this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Text(
          "Huzzl Job Board & Aggregator",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: defaultPadding),
        startDate != null && endDate != null
            ? Responsive(
                mobile: FileInfoCardGridView(
                  startDate: startDate,
                  endDate: endDate,
                  crossAxisCount: size.width < 650 ? 2 : 4,
                  childAspectRatio:
                      size.width < 650 && size.width > 350 ? 1.3 : 1,
                ),
                tablet: FileInfoCardGridView(
                  startDate: startDate,
                  endDate: endDate,
                ),
                desktop: FileInfoCardGridView(
                  childAspectRatio: size.width < 1400 ? 1.1 : 1.4,
                  startDate: startDate,
                  endDate: endDate,
                ),
              )
            : Responsive(
                mobile: FileInfoCardGridView(
                  crossAxisCount: size.width < 650 ? 2 : 4,
                  childAspectRatio:
                      size.width < 650 && size.width > 350 ? 1.3 : 1,
                ),
                tablet: FileInfoCardGridView(),
                desktop: FileInfoCardGridView(
                  childAspectRatio: size.width < 1400 ? 1.1 : 1.4,
                ),
              ),
      ],
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  DateTime? startDate;
  DateTime? endDate;
  FileInfoCardGridView({
    super.key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
    this.startDate,
    this.endDate,
  });

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    if (startDate != null && endDate != null) {
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: demoMyFiles.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: defaultPadding,
          mainAxisSpacing: defaultPadding,
          childAspectRatio: childAspectRatio,
        ),
        itemBuilder: (context, index) => FileInfoCard(
            info: demoMyFiles[index], startDate: startDate, endDate: endDate),
      );
    } else {
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: demoMyFiles.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: defaultPadding,
          mainAxisSpacing: defaultPadding,
          childAspectRatio: childAspectRatio,
        ),
        itemBuilder: (context, index) => FileInfoCard(info: demoMyFiles[index]),
      );
    }
  }
}
