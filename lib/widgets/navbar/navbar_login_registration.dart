import 'package:flutter/material.dart';
import 'package:huzzl_web/responsive_sizes.dart';
import 'package:responsive_builder/responsive_builder.dart';

class NavBarLoginRegister extends StatelessWidget {
  NavBarLoginRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizeInfo) {
      return Padding(
        padding: EdgeInsets.all(ResponsiveSizes.paddingSmall(sizeInfo)),
        child: Row(
          children: [
            SizedBox(
              child: Image.asset('assets/images/huzzl.png',
                  width: ResponsiveSizes.huzzlTextLogo(sizeInfo)),
            ),
          ],
        ),
      );
    });
  }
}
