import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:huzzl_web/views/admins/controllers/menu_app_controller.dart';
import 'package:huzzl_web/views/admins/models/my_files.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class FileInfoCard extends StatefulWidget {
  const FileInfoCard({
    Key? key,
    required this.info,
  }) : super(key: key);

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
  int? count;

  @override
  void initState() {
    // TODO: implement initState
    adminProvider = Provider.of<MenuAppController>(context, listen: false);
    getCounterFunction();
    super.initState();
  }

  void getCounterFunction() async{
    counterRecruiter = await adminProvider.recruitersCount();
    counterJobPosting = await adminProvider.jobPostCount();
    counterJobseeker = await adminProvider.jobseekersCount();

    if(widget.info.title == "Recruiter"){
      setState(() {
        count = counterRecruiter;
      });
    }else if (widget.info.title == "Job-seeker"){
      setState(() {
        count = counterJobseeker;
      });
    }else {
      setState(() {
        count = counterJobPosting;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    if(count == null){
      return Center(child: CircularProgressIndicator(),);
    }
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(defaultPadding * 0.75),
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
              Icon(Icons.more_vert, color: Colors.black)
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
                widget.info.title! == "Job Post" ? "$count Posts" : "$count Users",
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
    Key? key,
    this.color = primaryColor,
    required this.percentage,
  }) : super(key: key);

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
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage! / 100),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
