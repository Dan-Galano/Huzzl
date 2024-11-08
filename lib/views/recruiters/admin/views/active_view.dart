import 'package:flutter/material.dart';

class CompanyAdminsActive extends StatelessWidget {
  final dynamic userData;
  const CompanyAdminsActive({required this.userData, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical, // Enable vertical scrolling
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Enable horizontal scrolling
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
                columnSpacing:
                    20, // Adjust this to control spacing between columns
                columns: [
                  DataColumn(label: Text("Firstname")),
                  DataColumn(label: Text("Lastname")),
                  DataColumn(label: Text("Role")),
                  DataColumn(label: Text("Email")),
                  DataColumn(label: Text("Phone")),
                  DataColumn(label: Text("Action")),
                ],
                rows: [
                  DataRow(
                    selected: true,
                    color: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.selected)) {
                          return Colors.green.withOpacity(0.2);
                        }
                        return Colors.yellow.withOpacity(0.3);
                      },
                    ),
                    cells: [
                      DataCell(Text("${userData["hiringManagerFirstName"]}")),
                      DataCell(Text("${userData["hiringManagerLastName"]}")),
                      DataCell(Text("Admin")),
                      DataCell(Text("${userData["email"]}")),
                      DataCell(Text("09483623503")),
                      DataCell(
                        IconButton(
                          onPressed: () async {
                            final RenderBox button =
                                context.findRenderObject() as RenderBox;
                            final RenderBox overlay = Overlay.of(context)
                                .context
                                .findRenderObject() as RenderBox;

                            final position = button.localToGlobal(Offset.zero,
                                ancestor: overlay);

                            await showMenu(
                              context: context,
                              position: RelativeRect.fromLTRB(
                                position.dx,
                                position.dy,
                                overlay.size.width -
                                    position.dx -
                                    button.size.width,
                                overlay.size.height - position.dy,
                              ),
                              items: [
                                PopupMenuItem(
                                  value: 'archived',
                                  child: Row(
                                    children: [
                                      Icon(Icons.feedback_outlined,
                                          color: Colors.grey),
                                      SizedBox(width: 8),
                                      Text('Archived'),
                                    ],
                                  ),
                                ),
                              ],
                            ).then((value) {
                              if (value == 'move_to_reserved') {
                                //   showMoveToReservedConfirmationDialog(context);
                                // } else if (value == 'view_previous_feedback') {
                                //   showFeedbackViewDialog(context, this);
                              }
                            });
                          },
                          icon: Image.asset(
                              'assets/images/three-dot-icon-data-table.png'),
                        ),
                      ),
                    ],
                  ),
                  // More rows...
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
