import 'package:flutter/material.dart';
import '../../../constants.dart';
import 'chart.dart';
import 'storage_info_card.dart';

class StorageDetails extends StatelessWidget {
  const StorageDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Huzzl Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: defaultPadding),
          Chart(),
          // StorageInfoCard(
          //   svgSrc: "assets/icons/Documents.svg",
          //   title: "Recruiters",
          //   amountOfFiles: "1.3GB",
          //   numOfFiles: 1328,
          // ),
          // StorageInfoCard(
          //   svgSrc: "assets/icons/media.svg",
          //   title: "Job-seekers",
          //   amountOfFiles: "15.3GB",
          //   numOfFiles: 1328,
          // ),
          // StorageInfoCard(
          //   svgSrc: "assets/icons/folder.svg",
          //   title: "Job posts",
          //   amountOfFiles: "1.3GB",
          //   numOfFiles: 1328,
          // ),
          // StorageInfoCard(
          //   svgSrc: "assets/icons/unknown.svg",
          //   title: "Unknown",
          //   amountOfFiles: "1.3GB",
          //   numOfFiles: 140,
          // ),
        ],
      ),
    );
  }
}
