import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserTile extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String text;
  final void Function()? onTap;
  final bool isSelected;
  final String last_msg;
  final SizingInformation sizeInfo;
  final int unreadCount;
  final DateTime last_time;

  const UserTile({
    super.key,
    required this.text,
    required this.onTap,
    required this.userData,
    required this.sizeInfo,
    required this.last_msg,
    required this.last_time,
    this.isSelected = false,
    this.unreadCount = 0,
  });

  @override
  _UserTileState createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    var lasttime = timeago.format(widget.last_time, locale: 'en_short');
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: widget.isSelected
                ? Colors.orange
                    .withOpacity(0.3) // Pale orange for selected tile
                : _isHovered
                    ? Colors.grey.withOpacity(0.3) // Darker gray on hover
                    : const Color.fromARGB(151, 238, 238, 238), // Default color
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.symmetric(vertical: 5),
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Color(0xFFff9800).withOpacity(0.3),
                    child: (widget.userData["hiringManagerFirstName"]
                                    ?.isNotEmpty ==
                                true ||
                            widget.userData["hiringManagerLastName"]
                                    ?.isNotEmpty ==
                                true)
                        ? Text(
                            "${(widget.userData["hiringManagerFirstName"] ?? '').toUpperCase()[0]}${(widget.userData["hiringManagerLastName"] ?? '').toUpperCase()[0]}",
                            style: TextStyle(
                                color: Color(0xFFfd7206),
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                          )
                        : Icon(
                            Icons.person,
                            size: 12,
                            color: Color(0xFFfd7206),
                          ),
                  ),
                  Gap(10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.sizeInfo.isDesktop
                          ? widget.isSelected
                              ? Text(
                                  "${(widget.userData["hiringManagerFirstName"] ?? '')} ${(widget.userData["hiringManagerLastName"] ?? '')}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold))
                              : Text(
                                  "${(widget.userData["hiringManagerFirstName"] ?? '')} ${(widget.userData["hiringManagerLastName"] ?? '')}",
                                  style: TextStyle(fontSize: 12))
                          : SizedBox(),
                      if (widget.sizeInfo.isDesktop)
                        Text(
                          widget.last_msg.length > 30
                              ? '${widget.last_msg.substring(0, 30)}...'
                              : widget.last_msg,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 10),
                        )
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  if (widget.sizeInfo.isDesktop)
                    Text(lasttime,
                        style:
                            TextStyle(color: Colors.grey[700], fontSize: 10)),
                  // if (widget.unreadCount > 0)
                  //   Container(
                  //     padding: EdgeInsets.all(6),
                  //     decoration: BoxDecoration(
                  //       color: Color(0xFFfd7206),
                  //       shape: BoxShape.circle,
                  //     ),
                  //     child: Text(
                  //       widget.unreadCount.toString(),
                  //       style: TextStyle(color: Colors.white, fontSize: 10),
                  //     ),
                  //   ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
