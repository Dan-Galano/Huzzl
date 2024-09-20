import 'package:flutter/material.dart';
import 'package:huzzl_web/views/recruiters/branches/branches_widgets.dart';

class BranchesScreen extends StatefulWidget {
  const BranchesScreen({super.key});

  @override
  _BranchesScreenState createState() => _BranchesScreenState();
}

class _BranchesScreenState extends State<BranchesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Two tabs
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          navBar(),
          Divider(
            thickness: 1,
            color: Colors.grey[400],
          ),
          Expanded(
            child: Row(
              children: [
                // Sidebar
                Container(
                  width: 350,
                  color: const Color(0xffACACAC),
                  padding: const EdgeInsets.all(30),
                  child: ListView(
                    children: const [
                      Text(
                        'Sidebar (Branches tab)',
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 32,
                          color: Color(0xff373030),
                          fontFamily: 'Galano',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: double.infinity,
                  color: Colors.grey[300],
                ),
                // Main Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                     LayoutBuilder(
  builder: (context, constraints) {
    // Check the available width of the screen
    double screenWidth = constraints.maxWidth;

    // Adjust the width of the TextField and spacing based on screen width
    double textFieldWidth = screenWidth * 0.4; // Adjust based on your needs
    double spacing = screenWidth > 600 ? 20 : 10; // Larger spacing for larger screens

    return Row(
      children: [
        SizedBox(width: spacing),
        const Text(
          'Branches',
          style: TextStyle(
            decoration: TextDecoration.none,
            fontSize: 32,
            color: Color(0xff373030),
            fontFamily: 'Galano',
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(width: spacing),
        SizedBox(
          width: textFieldWidth, // Use responsive width
          child: TextField(
            decoration: searchTextFieldDecoration('Search'),
          ),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF0038FF),
            padding: EdgeInsets.all(screenWidth > 600 ? 20 : 10), // Adjust padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Add new branch',
            style: TextStyle(
              fontSize: 17,
              color: Colors.white,
              fontFamily: 'Galano',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(
          width: screenWidth > 600 ? 30 : 10, // Adjust based on screen size
        ),
      ],
    );
  },
),
   // Add Tabs for Active and Archive
                        TabBar(
                          controller: _tabController,
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: Colors.orange,
                          labelStyle: TextStyle(
                            fontSize: 18, // Font size of the selected tab
                            fontWeight: FontWeight
                                .bold, // Font weight of the selected tab
                            fontFamily: 'Galano', // Use your custom font
                          ),
                          unselectedLabelStyle: TextStyle(
                            fontSize: 16, // Font size of the unselected tabs
                            fontWeight: FontWeight
                                .normal, // Font weight of the unselected tabs
                            fontFamily: 'Galano', // Use your custom font
                          ),
                          tabs: [
                            Tab(text: '4 Active'),
                            Tab(text: '0 Archived'),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              // Active Tab Content
                              ActiveBranchesView(),
                              // Archive Tab Content
                              ArchiveBranchesView(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Branch {
  final String name;
  final String manager;
  final String dateEstablished;

  Branch(
      {required this.name,
      required this.manager,
      required this.dateEstablished});
}

// Sample  Active Branches List
class ActiveBranchesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Branch Manager and Date Established Text
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 200,
                child: Text(""),
              ),
              SizedBox(
                width: 200,
                child: Text(
                  "Branch Manager",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Galano',
                  ),
                ),
              ),
              Text(
                "Date Established",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Galano',
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              BranchTile(
                  name: 'Jollibee - Urdaneta Bypass',
                  manager: 'Add branch manager',
                  date: '05/12/2024',
                  location: 'San Vicente, Urdaneta City, Pangasinan'),
              BranchTile(
                  name: 'Jollibee - Urdaneta Magic Mall',
                  manager: 'Juan Karlos',
                  date: '06/17/2024',
                  location: 'Nancaysan, Urdaneta City, Pangasinan'),
              BranchTile(
                  name: 'Jollibee - Urdaneta SM',
                  manager: 'Ebe Dancel',
                  date: '05/18/2024',
                  location: 'Nancaysan, Urdaneta City, Pangasinan'),
              BranchTile(
                  name: 'Jollibee - Urdaneta CB Mall',
                  manager: 'Dionela',
                  date: '02/28/2024',
                  location: 'San Vicente, Urdaneta City, Pangasinan'),
            ],
          ),
        ),
      ],
    );
  }
}

// Example Archive Branches List (if any)
class ArchiveBranchesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No Archived Branches',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey,
          fontFamily: 'Galano',
        ),
      ),
    );
  }
}

// Branch List Tile widget
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
              content: Container(
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
                          "Branch Manager",
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
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Text(
                          "Co-Managers (17)",
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
                        itemCount: 17,
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
          if (widget.manager != "Add branch manager") {
            _showBranchDetailsDialog(context);
          }
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
