import 'package:flutter/material.dart';
import 'package:zesty/custom_widget/elevatedButton_cust.dart';
import 'package:zesty/utils/theme/custom_themes/text_theme.dart';

import 'custom_widget/textfield_cust.dart';

class myHomePage extends StatefulWidget {
  const myHomePage({super.key});

  @override
  State<myHomePage> createState() => _myHomePageState();
}

class _myHomePageState extends State<myHomePage> {
  var controller = TextEditingController();
  var controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: CustomTextField(
                  labelText: "zesty",
                  onButtonPressed: () {},
                  controller: controller,
                  hintText: "Zesty",
                  prefixIcon: Icons.add,
                ),
              ),
              SizedBox(height: 15,),
              CustomTextField(
                labelText: "hello",
                onButtonPressed: () {},
                controller: controller2,
                hintText: "Zesty",
                prefixIcon: Icons.person,
              ),
              SizedBox(height: 120,),
              ZElevatedButton(title: "Hello", onPress: () {}),
              Text("This is vid!", style: Theme.of(context).textTheme.titleLarge,)
            ],
          ),
        ),
      ),
    );
  }
}
