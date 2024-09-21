import 'package:flutter/material.dart';
import 'package:huzzl_web/views/recruiters/home/branches-tab.dart';
import 'package:huzzl_web/views/recruiters/home/branches_tab/branches.dart';
import 'package:huzzl_web/views/recruiters/home/candidates-tab.dart';
import 'package:huzzl_web/views/recruiters/home/interview-tab.dart';
import 'package:huzzl_web/views/recruiters/home/jobs-tab.dart';
import 'package:huzzl_web/views/recruiters/home/manager-tab.dart';
import 'package:huzzl_web/widgets/navbar/navbar_login_registration.dart';

class RecruiterHomeScreen extends StatefulWidget {
  const RecruiterHomeScreen({super.key});

  @override
  State<RecruiterHomeScreen> createState() => _RecruiterHomeScreenState();
}

class _RecruiterHomeScreenState extends State<RecruiterHomeScreen> {
  int? _selectedIndex = 0; // Default the first tab na (Managers)

  void changeDestination(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget buildContent() {
    switch (_selectedIndex) {
      case 0:
        return buildManagersContent(context);
      case 1:
        return BranchesScreen();
      case 2:
        return buildJobsContent();
      case 3:
        return buildCandidatesContent();
      case 4:
        return buildInterviewsContent();
      default:
        return Text("No content available");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const NavBarLoginRegister(),
        actions: [
          IconButton(
            onPressed: () {},
            icon:
                Image.asset('assets/images/chat-icon-recruiter.png', width: 25),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {},
            icon: Image.asset('assets/images/notif-icon-recruiter.png',
                width: 25),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {},
            icon: Image.asset('assets/images/building-icon-recruiter.png',
                width: 25),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: const Color(0xFF23294F),
            selectedIndex: _selectedIndex,
            onDestinationSelected: changeDestination,
            minWidth: 200,
            labelType: NavigationRailLabelType.none,
            leading: const SizedBox(height: 20),
            useIndicator: true,
            indicatorColor: Colors.orange,
            destinations: <NavigationRailDestination>[
              NavigationRailDestination(
                icon: _buildNavItem(
                    'assets/images/manager-tab.png', 'Managers', 0),
                label: const SizedBox.shrink(),
              ),
              NavigationRailDestination(
                icon: _buildNavItem(
                    'assets/images/branches-tab.png', 'Branches', 1),
                label: const SizedBox.shrink(),
              ),
              NavigationRailDestination(
                icon: _buildNavItem('assets/images/jobs-tab.png', 'Jobs', 2),
                label: const SizedBox.shrink(),
              ),
              NavigationRailDestination(
                icon: _buildNavItem(
                    'assets/images/candidates-tab.png', 'Candidates', 3),
                label: const SizedBox.shrink(),
              ),
              NavigationRailDestination(
                icon: _buildNavItem(
                    'assets/images/interview-tab.png', 'Interviews', 4),
                label: const SizedBox.shrink(),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // Expanded makes sure the content takes up the remaining space
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  // Text("Header for all"),
                  Expanded(
                    child: buildContent(), // contents goes here
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String iconPath, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: isSelected ? Colors.orange : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Image.asset(
            iconPath,
            width: 24,
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: "Galano",
            ),
          ),
        ],
      ),
    );
  }
}
