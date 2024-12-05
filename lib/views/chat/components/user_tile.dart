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
  });

  @override
  _UserTileState createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    var lasttime = timeago.format(widget.last_time, locale: 'en');

    // Check if the user has "firstName" and "lastName" or "hiringManagerFirstName" and "hiringManagerLastName"
    String displayName = '';
    if ((widget.userData["firstName"]?.isNotEmpty ?? false) &&
        (widget.userData["lastName"]?.isNotEmpty ?? false)) {
      displayName =
          "${widget.userData["firstName"]} ${widget.userData["lastName"]}";
    } else if ((widget.userData["hiringManagerFirstName"]?.isNotEmpty ??
            false) &&
        (widget.userData["hiringManagerLastName"]?.isNotEmpty ?? false)) {
      displayName =
          "${widget.userData["hiringManagerFirstName"]} ${widget.userData["hiringManagerLastName"]}";
    } else {
      // If both are not found, fall back to a generic representation (like email or a placeholder)
      displayName = widget.userData["email"] ?? "Unknown User";
    }

    // Check if there is no conversation (no last message or time)
    bool hasConversation = widget.last_msg.isNotEmpty;

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
                ? Colors.orange.withOpacity(0.3)
                : _isHovered
                    ? Colors.grey.withOpacity(0.5)
                    : const Color.fromARGB(151, 238, 238, 238),
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
                    child: (widget.userData["firstName"]?.isNotEmpty == true ||
                            widget.userData["lastName"]?.isNotEmpty == true ||
                            widget.userData["hiringManagerFirstName"]
                                    ?.isNotEmpty ==
                                true ||
                            widget.userData["hiringManagerLastName"]
                                    ?.isNotEmpty ==
                                true)
                        ? Text(
                            "${(widget.userData["firstName"] ?? widget.userData["hiringManagerFirstName"] ?? '').toUpperCase()[0]}${(widget.userData["lastName"] ?? widget.userData["hiringManagerLastName"] ?? '').toUpperCase()[0]}",
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
                              ? Text(displayName,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold))
                              : Text(displayName,
                                  style: TextStyle(fontSize: 12))
                          : SizedBox(),
                      if (widget.sizeInfo.isDesktop && hasConversation)
                        Text(
                          widget.last_msg.length > 30
                              ? '${widget.last_msg.substring(0, 30)}...'
                              : widget.last_msg,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 10),
                        ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  if (widget.sizeInfo.isDesktop && hasConversation)
                    Text(lasttime,
                        style:
                            TextStyle(color: Colors.grey[700], fontSize: 10)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
