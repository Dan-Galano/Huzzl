import 'package:flutter/material.dart';
import 'package:huzzl_web/widgets/buttons/blue/blueoutlined_boxbutton.dart';
import 'package:huzzl_web/widgets/buttons/green/greenfilled_boxbutton.dart';
import 'package:huzzl_web/widgets/buttons/iconbox_leftsidebutton.dart';
import 'package:huzzl_web/widgets/buttons/iconbox_rightsidebutton.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_boxbutton.dart';
import 'package:huzzl_web/widgets/buttons/gray/grayfilled_boxbutton.dart';
import 'package:huzzl_web/widgets/buttons/iconbutton_back.dart';
import 'package:huzzl_web/widgets/buttons/orange/orange_textbutton.dart';
import 'package:huzzl_web/widgets/buttons/orange/orangefilled_boxbutton.dart';
import 'package:huzzl_web/widgets/buttons/orange/orangeoutlined_boxbutton.dart';
import 'package:huzzl_web/widgets/buttons/blue/blueoutlined_circlebutton.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/buttons/red/redfilled_boxbutton.dart';
import 'package:huzzl_web/widgets/buttons/tickbutton.dart';
import 'package:huzzl_web/widgets/textfield/lightblue_hinttext.dart';
import 'package:huzzl_web/widgets/textfield/lightblue_textfield.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Custom TextField Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom TextField Example'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LightBlueTextField(
              width: 670,
              controller: _controller,
            ),
            SizedBox(height: 10),
            LightBlueHinttext(
              width: 670,
              controller: _controller,
              hintText: 'Select an option',
            ),
            SizedBox(height: 10),
            BlueFilledCircleButton(
              onPressed: () {},
              text: 'Next',
              width: 100,
            ),
            SizedBox(height: 20),
            BlueOutlinedCircleButton(
              onPressed: () {},
              text: 'Outlined',
              width: 200,
            ),
            SizedBox(height: 20),
            BlueFilledBoxButton(
              onPressed: () {},
              text: 'Blue Filled Box Button',
              width: 400,
            ),
            SizedBox(height: 20),
            BlueOutlinedBoxButton(
              onPressed: () {},
              text: 'Blue Filled Box Button',
              width: 400,
            ),
            SizedBox(height: 20),
            OrangeOutlinedBoxButton(
              onPressed: () {},
              text: 'CANCEL',
            ),
            SizedBox(height: 20),
            OrangeTextButton(
              onPressed: () {},
              text: 'Back',
            ),
            SizedBox(height: 20),
            IconButtonback(
              onPressed: () {
                print('Icon button pressed!');
              },
              iconImage: AssetImage('assets/images/backbutton.png'),
            ),
            SizedBox(height: 20),
            OrangeFilledBoxButton(
              onPressed: () {},
              text: 'Add new interview',
              width: 300,
            ),
            SizedBox(height: 20),
            RedFilledBoxButton(
              onPressed: () {},
              text: 'Delete',
              width: 200,
            ),
            SizedBox(height: 20),
            GreenFilledBoxButton(
              onPressed: () {},
              text: 'Success',
              width: 200,
            ),
            SizedBox(height: 20),
            GrayFilledBoxButton(
              onPressed: () {},
              text: 'Cancel Deletion',
              width: 400,
            ),
            SizedBox(height: 20),
            IconBoxRightsideButton(
              onPressed: () {},
              text: 'Icon right',
              iconImage: AssetImage('assets/images/rightarrow.png'),
              width: 150,
            ),
            SizedBox(height: 20),
            IconBoxLeftsideButton(
              onPressed: () {},
              text: 'Icon left',
              iconImage: AssetImage('assets/images/rightarrow.png'),
              width: 150,
            ),
            SizedBox(height: 20),
            TickButton(
              onPressed: () {},
              text: 'Tick Button',
              width: 140,
            ),
          ],
        ),
      ),
    );
  }
}
