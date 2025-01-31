import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';

class Rough extends StatefulWidget {
  const Rough({super.key});

  @override
  State<Rough> createState() => _RoughState();
}

class _RoughState extends State<Rough> {

  final ScrollController scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    
    scrollController.addListener(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Center(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Text("data"),
           Container(
             height: 400,
               child: Flutter3DViewer(
                   src: 'assets/icons/burger.glb',
                 activeGestureInterceptor: true,
                 enableTouch: true,
               )),
         ],
       ),
     ),
    );
  }
}
