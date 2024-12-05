import 'package:flutter/material.dart';
import 'package:huzzl_web/views/admins/controllers/menu_app_controller.dart';
import 'package:huzzl_web/views/admins/models/my_files.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class FileInfoCard extends StatefulWidget {
  const FileInfoCard({
    super.key,
    required this.info,
  });

  final CloudStorageInfo info;

  @override
  State<FileInfoCard> createState() => _FileInfoCardState();
}

class _FileInfoCardState extends State<FileInfoCard> {
  late int counterRecruiter;
  late int counterJobseeker;
  late int counterJobPosting;
  late MenuAppController adminProvider;

  //will show
  int count = 0;

  @override
  void initState() {
    super.initState();
    adminProvider = Provider.of<MenuAppController>(context, listen: false);
    getCounterFunction();
  }

  Future<void> getCounterFunction() async {
    print('Get Counter Function');
    counterJobseeker = adminProvider.totalJobseekers;

    if (widget.info.title == "Recruiter") {
      //FETCH_DISABLER
      await adminProvider.recruitersCount();
      counterRecruiter = adminProvider.totalRecruiters;
      setState(() {
        print("RECRUITERS BABY: $counterRecruiter");
        count = counterRecruiter;
      });
    } else if (widget.info.title == "Job-seeker") {
      //FETCH_DISABLER
      await adminProvider.jobseekersCount();
      counterJobseeker = adminProvider.totalJobseekers;
      setState(() {
        print("JOP POSTS BABY: $counterJobseeker");
        count = counterJobseeker;
      });
    } else {
      //FETCH_DISABLER
      await adminProvider.jobPostCount();
      counterJobPosting = adminProvider.totalJobPosts;
      setState(() {
        print("JOP POSTS BABY: $counterJobPosting");
        count = counterJobPosting;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (count <= 0) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(defaultPadding * 0.75),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: widget.info.color!.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Image.asset(widget.info.svgSrc!
                    // colorFilter: ColorFilter.mode(
                    //     info.color ?? Colors.black, BlendMode.srcIn),
                    ),
              ),
              // const Icon(Icons.more_vert, color: Colors.black)
            ],
          ),
          Text(
            widget.info.title!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          ProgressLine(
            color: widget.info.color,
            percentage: count,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.info.title! == "Job Post"
                    ? "$count Posts"
                    : "$count Users",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.black),
              ),
              // Text(
              //   info.totalStorage!,
              //   style: Theme.of(context)
              //       .textTheme
              //       .bodySmall!
              //       .copyWith(color: Colors.black),
              // ),
            ],
          )
        ],
      ),
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    super.key,
    this.color = primaryColor,
    required this.percentage,
  });

  final Color? color;
  final int? percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage! / 100),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
