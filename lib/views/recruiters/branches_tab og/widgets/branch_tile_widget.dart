import 'package:flutter/material.dart';
import 'package:huzzl_web/views/recruiters/branches_tab%20og/widgets/textfield_decorations.dart';

class BranchTile extends StatefulWidget {
  final String name;
  final String manager;
  final String date;
  final String location;

  BranchTile(
      {required this.name,
      required this.manager,
      required this.date,
      required this.location});

  @override
  State<BranchTile> createState() => _BranchTileState();
}

class _BranchTileState extends State<BranchTile> {
  bool _isHovered = false;
  bool _isAddManagerHovered = false;

  bool _isEditing = false;

  TextEditingController _branchNameController = TextEditingController();
  TextEditingController _branchLocationController = TextEditingController();

  late String _originalBranchName;
  late String _originalBranchLocation;

  @override
  void initState() {
    super.initState();
    // Initialize with the original data
    _originalBranchName = widget.name;
    _originalBranchLocation = widget.location;
    _branchNameController.text = widget.name;
    _branchLocationController.text = widget.location;
  }

  void _startEditing() {
    print("EDIT CLICKED");
    setState(() {
      _isEditing = true; // Switch to "edit" mode
    });
  }

  void _saveChanges() {
    setState(() {
      _originalBranchName = _branchNameController.text; // Save the new data
      _originalBranchLocation = _branchLocationController.text;
      _isEditing = false; // Exit "edit" mode
    });
  }

  void _cancelChanges() {
    setState(() {
      // Revert back to original data
      _branchNameController.text = _originalBranchName;
      _branchLocationController.text = _originalBranchLocation;
      _isEditing = false; // Exit "edit" mode
    });
  }

  void _showBranchDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Branch Details
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            leading: CircleAvatar(
                              foregroundColor: const Color(0xff373030),
                              backgroundColor: const Color(0xffD1E1FF),
                              child: Text(widget.name[0]),
                            ),
                            title: TextField(
                              controller: _branchNameController,
                              enabled: _isEditing,
                              decoration: inputTextFieldDecoration(1),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: TextField(
                                controller: _branchLocationController,
                                enabled: _isEditing,
                                decoration: inputTextFieldDecoration(2),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if (_isEditing) {
                                    _saveChanges();
                                  } else {
                                    _startEditing();
                                  }
                                });
                              },
                              style: ButtonStyle(
                                elevation: const WidgetStatePropertyAll(0),
                                backgroundColor: WidgetStatePropertyAll(
                                  _isEditing
                                      ? const Color(0xffD6E4FF)
                                      : const Color(0xffffeed4),
                                ),
                              ),
                              child: Text(
                                _isEditing ? 'Save' : 'Edit details',
                                style: TextStyle(
                                  color: _isEditing
                                      ? const Color(0xff3B7DFF)
                                      : const Color(0xffFF9600),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8), // Space between buttons
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if (_isEditing) {
                                    _cancelChanges();
                                  } else {
                                    // Archive action here
                                  }
                                });
                              },
                              style: ButtonStyle(
                                elevation: const WidgetStatePropertyAll(0),
                                backgroundColor: WidgetStatePropertyAll(
                                  _isEditing
                                      ? const Color(0xffe8e8e8)
                                      : const Color(0xfffcd0d0),
                                ),
                              ),
                              child: Text(
                                _isEditing ? 'Cancel' : 'Archive',
                                style: TextStyle(
                                  color: _isEditing
                                      ? const Color(0xff4D4D4D)
                                      : const Color(0xffB80000),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Text(
                          "Hiring Manager",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Manager Details
                    ListTile(
                      leading: CircleAvatar(
                        foregroundColor: const Color(0xff373030),
                        backgroundColor: const Color(0xffD1E1FF),
                        child: Text(widget.manager[0]),
                      ),
                      title: Text(
                        widget.manager == "Add branch manager"
                            ? "No branch manager yet."
                            : widget.manager,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        widget.manager == "Add branch manager"
                            ? "N/A"
                            : "dionela_153@gmail.com",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff3B7DFF),
                        ),
                      ),
                      trailing: Text(
                        widget.manager == "Add branch manager"
                            ? "N/A"
                            : "09123456789",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff373030),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (widget.manager != "Add branch manager") ...[
                      const Row(
                        children: [
                          Text(
                            "Staff (7)",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 7,
                          itemBuilder: (context, index) => ListTile(
                            leading: CircleAvatar(
                              foregroundColor: const Color(0xff373030),
                              backgroundColor: const Color(0xffD1E1FF),
                              child: Text(widget.manager[0]),
                            ),
                            title: Text(
                              widget.manager,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: const Text(
                              "dionela_153@gmail.com",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff3B7DFF),
                              ),
                            ),
                            trailing: const Text(
                              "09123456789",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff373030),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: () {},
                            child: const Text("View job posts in this branch"),
                            style: ButtonStyle(
                              elevation: const WidgetStatePropertyAll(0),
                              foregroundColor: WidgetStateProperty.all(
                                const Color(0xffFD7206),
                              ),
                              side: WidgetStateProperty.all(
                                const BorderSide(
                                  color: Color(0xffFD7206),
                                  width: 2,
                                ), // Outline color and thickness
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
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
        onTap: () {
          _showBranchDetailsDialog(context);
        },
        child: Card(
          elevation: _isHovered ? 8 : 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: _isHovered ? Colors.grey[200] : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Branch Info
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff373030),
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.person_outline,
                              size: 20, color: Colors.grey),
                          SizedBox(width: 5),
                          Text(
                            widget.location,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontFamily: 'Galano',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                //Manager Column
                widget.manager == "Add branch manager"
                    ? Expanded(
                        child: MouseRegion(
                        onEnter: (_) {
                          setState(() {
                            _isAddManagerHovered = true;
                          });
                        },
                        onExit: (_) {
                          setState(() {
                            _isAddManagerHovered = false;
                          });
                        },
                        child: GestureDetector(
                          onTap: () {
                            print('"Add Branch Manager" button tapped');
                          },
                          child: Center(
                            child: Text(
                              widget.manager,
                              style: TextStyle(
                                decoration: _isAddManagerHovered
                                    ? TextDecoration.underline
                                    : TextDecoration.none,
                                decorationColor: Colors.orange,
                                fontSize: 14,
                                color: Colors.orange,
                                fontFamily: 'Galano',
                              ),
                            ),
                          ),
                        ),
                      ))
                    : Expanded(
                        child: Center(
                        child: Text(
                          widget.manager,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                            fontFamily: 'Galano',
                          ),
                        ),
                      )),
                // Date Established Column
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.date,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Galano',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
