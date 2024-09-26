import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class TitleRow extends StatefulWidget {
  TitleRow({super.key, required this.date, required this.title, required this.color});

  DateTime date;
  String title;
  Color color;

  @override
  State<TitleRow> createState() => _TitleRowState();
}

class _TitleRowState extends State<TitleRow> {
  String formattedDate = '';

  @override
  void initState() {
    super.initState();
    formattedDate = DateFormat('dd MMM yyyy').format(widget.date);
  }
  @override
  Widget build(BuildContext context) {
    return Row(
              children: [
                Container(
                  child: Text(
                    formattedDate.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Color(0xff373030),
                    ),
                  ),
                ),
                const Gap(100),
                Text(
                  widget.title,
                  style: TextStyle(
                    color: widget.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
                const Gap(100),
                Expanded(
                  child: Container(
                    height: 2,
                    color: widget.color,
                  ),
                )
              ],
            );
  }
}