import 'package:flutter/material.dart';

class ZestyMartPage extends StatefulWidget {
  const ZestyMartPage({super.key});

  @override
  State<ZestyMartPage> createState() => _ZestyMartPageState();
}

class _ZestyMartPageState extends State<ZestyMartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Zesty Mart",style: Theme.of(context).textTheme.headlineLarge,)),
    );
  }
}
