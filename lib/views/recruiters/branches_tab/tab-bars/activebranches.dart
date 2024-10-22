import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/user-provider.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/branch-manager-staff-model.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/branch-provider.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/hiringmanager-provider.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/widgets/cards/activebranchCard.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/widgets/searchmanager.dart';
import 'package:provider/provider.dart';
import 'package:side_panel/side_panel.dart';
import 'package:shimmer/shimmer.dart';

class ActiveBranchesCategory extends StatefulWidget {
  final Function(Branch) onCardTap; // Callback for card taps

  const ActiveBranchesCategory({Key? key, required this.onCardTap})
      : super(key: key);

  @override
  State<ActiveBranchesCategory> createState() => _ActiveBranchesCategoryState();
}

class _ActiveBranchesCategoryState extends State<ActiveBranchesCategory> {
  @override
  void initState() {
    super.initState();
    // Fetch branches only once when the widget is initialized
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final loggedInUserId = userProvider.loggedInUserId;

    // Call fetchActiveBranches only once
    if (loggedInUserId != null) {
      Provider.of<BranchProvider>(context, listen: false)
          .fetchActiveBranches(loggedInUserId)
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
        const Gap(20),
        if (ControllerManager().searchManagerController.text.isNotEmpty)
          Text(
            "Search Results (${branchProvider.searchActiveBranchCount})",
            style: const TextStyle(color: Colors.grey),
          )
        else
          const SizedBox.shrink(),
        const Gap(10),
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
                      child: ActiveBranchCard(branch: branch),
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
              ),
      ],
    );
  }
}
