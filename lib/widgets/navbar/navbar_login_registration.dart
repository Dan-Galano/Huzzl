import 'package:flutter/material.dart';

class NavBarLoginRegister extends StatelessWidget {
  const NavBarLoginRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(        
        children: [
          SizedBox(
            child: Image.asset('assets/images/huzzl.png', width: 80),
          ),
        ],
      ),
    );
  }
}