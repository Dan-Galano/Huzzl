import 'package:flutter/material.dart';
import 'package:huzzl_web/views/admins/controllers/menu_app_controller.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_boxbutton.dart';
import 'package:huzzl_web/widgets/buttons/gray/grayfilled_boxbutton.dart';

Future<void> validationModal(BuildContext context, String docId, MenuAppController adminController) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Validate Business Documents"),
          contentPadding: const EdgeInsets.all(20),
          scrollable: true,
          content: SizedBox(
            width: double.maxFinite, // Constrain width for ListView
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(),
                const Text("Documents by Patrick:"),
                const SizedBox(height: 10),
                FutureBuilder<List<String>>(
                  future:
                      adminController.listFiles('BusinessDocuments/$docId/'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(
                          child: Text("Error loading documents"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text("No documents available"));
                    }

                    return SizedBox(
                      height: 300, // Specify a height for ListView
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final imageUrl = snapshot.data![index];
                          print("IMAGE: ${imageUrl}");
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Image(
                              image: NetworkImage(imageUrl),
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                child: Text("Failed to load image"),
                              ),
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            (loadingProgress
                                                .expectedTotalBytes!)
                                        : null,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BlueFilledBoxButton(
                  onPressed: () {},
                  text: "Accept",
                  width: 150,
                ),
                const SizedBox(width: 15),
                GrayFilledBoxButton(
                  onPressed: () {},
                  text: "Reject",
                  width: 100,
                ),
              ],
            ),
          ],
        );
      },
    );
    print("USER ID : $docId");
  }