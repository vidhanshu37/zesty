import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../../utils/local_storage/HiveOpenBox.dart';

class TrackOrder extends StatefulWidget {
  const TrackOrder({super.key});

  @override
  State<TrackOrder> createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {

  var box = Hive.box(HiveOpenBox.storeAddress);
  
  late IO.Socket socket;

  String display = "helo";
  @override
  void initState() {
    super.initState();
    socket = IO.io('https://zesty-backend.onrender.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();
    socket.emit("user_join", box.get(HiveOpenBox.userId));

    socket.on("order", (data) {
      print("Order updated: ${data['orderStatus']}");
      display = data['orderStatus'];
      setState(() {}); // Refresh UI
    });
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Your Orders")),
        body: Center(child: ElevatedButton(onPressed: (){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(box.get(HiveOpenBox.userId))));
        }, child: Text("click")),)
    );
  }
}
