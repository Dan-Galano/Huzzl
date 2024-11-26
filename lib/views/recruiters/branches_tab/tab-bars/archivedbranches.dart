import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/user-provider.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/branch-manager-staff-model.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/branch-provider.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/hiringmanager-provider.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/widgets/cards/archivedbranchCard.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/widgets/searchmanager.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/cards/shortlisted_card.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ArchiveBranchesCategory extends StatefulWidget {
  final Function(Branch) onCardTap; // Callback for card taps

  const ArchiveBranchesCategory({Key? key, required this.onCardTap})
      : super(key: key);

  @override
  State<ArchiveBranchesCategory> createState() =>
      _ArchiveBranchesCategoryState();
}

class _ArchiveBranchesCategoryState extends State<ArchiveBranchesCategory> {
  @override
  void initState() {
    super.initState();
    // Fetch branches only once when the widget is initialized
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final loggedInUserId = userProvider.loggedInUserId;

    // Call fetchArchiveBranches only once
    if (loggedInUserId != null) {
      Provider.of<BranchProvider>(context, listen: false)
          .fetchArchiveBranches(loggedInUserId)
          .then((_) {
        print("Branches fetched successfully.");
      }).catchError((e) {
        print("Error fetching branches: $e");
      });

      // Fetch hiring managers once
      Provider.of<HiringManagerProvider>(context, listen: false)
          .fetchAllHiringManagers()
          .then((_) {
        print("Hiring managers fetched successfully.");
      }).catchError((e) {
        print("Error fetching hiring managers: $e");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final branchProvider = Provider.of<BranchProvider>(context);
    if (branchProvider.isLoading) {
      // Shimmer effect for the list of loading cards
      return Column(
        children: [
          const Gap(30),
          Expanded(
            child: ListView.builder(
              itemCount: 4, // Show 5 shimmer loading items
              itemBuilder: (BuildContext context, int index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[200]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color:
                          Colors.grey[200], // Grey background for the shimmer
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    height: 110, // Height of each placeholder card
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(20),
        if (ControllerManager().searchManagerController.text.isNotEmpty)
          Text(
            "Search Results (${branchProvider.searchArchiveBranchCount})",
            style: TextStyle(color: Colors.grey),
          )
        else
          SizedBox.shrink(),
        Gap(10),
        if (branchProvider.archiveBranchCount > 0)
          branchProvider.branches.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: branchProvider.branches.length,
                    itemBuilder: (BuildContext context, int index) {
                      final branch = branchProvider.branches[index];
                      return GestureDetector(
                        onTap: () {
                          widget.onCardTap(branch);
                          print("Selected Branch ID: ${branch.id}");
                        },
                        child: ArchiveBranchCard(branch: branch),
                      );
                    },
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 70),
                  child: Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/huzzl_notfound.png',
                          height: 150,
                        ),
                      ],
                    ),
                  ),
                )
        else
          Padding(
            padding: const EdgeInsets.only(top: 70),
            child: Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/empty_box.png',
                    width: 140,
                  ),
                  Gap(20),
                  Text(
                    "Archived branches will appear here.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          )
      ],
    );
  }
}
