import 'package:flutter/material.dart';
import 'package:huzzl_web/views/admins/responsive.dart';
import 'package:huzzl_web/views/admins/screens/dashboard/components/header.dart';
import 'package:huzzl_web/views/admins/screens/industries/components/industries.dart';

import '../../constants.dart';

class ManageIndustriesScreen extends StatelessWidget {
  const ManageIndustriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(
              name: "Manage Industries",
            ),
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      const IndustriesTable(),
                      if (Responsive.isMobile(context))
                        const SizedBox(height: defaultPadding),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  const SizedBox(width: defaultPadding),
              ],
            )
          ],
        ),
      ),
    );
  }
}
