import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/admins/models/company_information.dart';

void showCompanyDetailsModal(BuildContext context, CompanyInformation company) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Center(
                  child: Text(
                    company.companyName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 12.0),

                // CEO Information
                const Divider(color: Colors.blueAccent, thickness: 1.0),
                Text(
                  "CEO: ${company.ceoFirstName} ${company.ceoLastName}",
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 8.0),

                // Industry
                Text(
                  "Industry: ${company.industry}",
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 8.0),

                // Description
                Text(
                  "Description:",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                Text(
                  company.companyDescription,
                  style: const TextStyle(fontSize: 15, color: Colors.black54),
                ),
                const SizedBox(height: 12.0),

                // Location
                Text(
                  "Location:",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                Text(
                  "${company.city}, ${company.region}, ${company.province}",
                  style: const TextStyle(fontSize: 15, color: Colors.black54),
                ),
                const SizedBox(height: 16.0),

                // Business Documents
                const Divider(color: Colors.orangeAccent, thickness: 1.0),
                const Text(
                  "Business Documents:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.orangeAccent,
                  ),
                ),
                ...company.businessDocuments.map(
                  (doc) => Card(
                    elevation: 2.0,
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        doc,
                        style: const TextStyle(color: Colors.black87),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.open_in_new_rounded,
                            color: Colors.orangeAccent),
                        onPressed: () {
                          // Handle document download
                          print("Downloading: $doc");
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // "Later" Button
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Later",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const Gap(10),

                    // "Deny" Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                      ),
                      onPressed: () {
                        // Handle deny action
                        print("Denied");
                        Navigator.of(context).pop();
                      },
                      child: const Text("Deny"),
                    ),
                    const Gap(10),

                    // "Approve" Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                      ),
                      onPressed: () {
                        // Handle approve action
                        print("Approved");
                        Navigator.of(context).pop();
                      },
                      child: const Text("Approve"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
