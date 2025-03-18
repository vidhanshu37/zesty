import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as math;
import 'package:zesty/utils/constants/media_query.dart';

import '../../../utils/constants/colors.dart';
import '../zesty_Mart/single_Product/tableRow.dart';

class ZestyLiteActive extends StatefulWidget {
  const ZestyLiteActive({
    super.key,
    this.radius = 120,
    this.totalOrder = 20,
    this.zestyOrder = 0,
    this.zestyMartOrder = 0,
    this.strokeWidth = 15,
  });

  final double strokeWidth;
  final double radius;
  final int zestyOrder;
  final int totalOrder;
  final int zestyMartOrder;

  @override
  State<ZestyLiteActive> createState() => _ZestyLiteActiveState();
}

class _ZestyLiteActiveState extends State<ZestyLiteActive> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _zestyOrder;
  late Animation<double> _totalOrder;
  late Animation<double> _zestyMartOrder;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: Duration(seconds: 3));

    final curveAnimation = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);

    // final total = (widget.zestyOrder + widget.zestyMartOrder + widget.totalOrder ) / 360;
    // _zestyOrder = Tween<double>(begin: 0, end: widget.zestyOrder / total).animate(curveAnimation);
    // _zestyMartOrder = Tween<double>(begin: 0, end: (widget.zestyOrder + widget.zestyMartOrder) / total).animate(curveAnimation);
    // _totalOrder = Tween<double>(begin: 0, end: (widget.zestyOrder + widget.zestyMartOrder + widget.totalOrder) / total).animate(curveAnimation);

    final total = 20 / 360;
    _zestyOrder = Tween<double>(begin: 0, end: widget.zestyOrder / total).animate(curveAnimation);
    _zestyMartOrder = Tween<double>(begin: 0, end: (widget.zestyOrder + widget.zestyMartOrder) / total).animate(curveAnimation);
    _totalOrder = Tween<double>(begin: 0, end: (widget.zestyOrder + widget.zestyMartOrder + (20 - (widget.zestyOrder + widget.zestyMartOrder))) / total).animate(curveAnimation);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: ZMediaQuery(context).height * 0.04,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Text("Zesty",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: TColors.darkGreen),),
                Text("Zesty",style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w800, color: TColors.black),),
                SizedBox(width: 6,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                  decoration: BoxDecoration(
                    border: Border.all(color: TColors.black,width: 2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text("LITE",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: TColors.black),),
                ),
              ],
            ),
            Center(child: Text("Heavy Benefits, Lite Price!",style: TextStyle(fontSize: 17,color: Colors.black),)),
            SizedBox(height: ZMediaQuery(context).height * 0.10,),
            SizedBox.fromSize(
              size: Size.fromRadius(widget.radius),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child){
                  return CustomPaint(
                    painter: _ProgressPainter(
                        strokeWidth: widget.strokeWidth,
                        zestyOrderProgress: _zestyOrder.value,
                        zestyMartOrderProgress: _zestyMartOrder.value,
                        totalOrderProgress: _totalOrder.value
                    ),
                    child: child,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(widget.zestyOrder.toString(), style: TextStyle(fontSize: 20),),
                        Text(" Food ", style: TextStyle(fontSize: 12))
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(widget.zestyMartOrder.toString(), style: TextStyle(fontSize: 20),),
                        Text("ZestyMart",  style: TextStyle(fontSize: 12))
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text((20 - (widget.zestyOrder + widget.zestyMartOrder)).toString(), style: TextStyle(fontSize: 20),),
                        Text("Remain",  style: TextStyle(fontSize: 12))
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: ZMediaQuery(context).height * 0.08,),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade200
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Food",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: TColors.darkGreen),),
                    SizedBox(height: 13,),
                    Text("10 free deliveries",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),),
                    SizedBox(height: 3,),
                    Text("on all restauants up to 7 km,",style: TextStyle(fontSize: 13,color: Colors.grey),),
                    SizedBox(height: 3,),
                    Text("on orders above ₹199",style: TextStyle(fontSize: 13,color: Colors.grey),),
                    SizedBox(height: 10,),
                    Text("Up to 5% extra discounts",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),),
                    SizedBox(height: 3,),
                    Text("over & above other offers",style: TextStyle(fontSize: 13,color: Colors.grey),),
                    SizedBox(height: 10,),
                    Text("No surge fee, ever!",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),),
                    SizedBox(height: 3,),
                    Text("even during rain or peak hours",style: TextStyle(fontSize: 13,color: Colors.grey),),
                    SizedBox(height: 20,),
                    Divider(),
                    SizedBox(height: 13,),
                    Text("Instamart",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: TColors.darkGreen),),
                    SizedBox(height: 10,),
                    Text("10 free deliveries",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),),
                    SizedBox(height: 3,),
                    Text("on all orders above ₹199",style: TextStyle(fontSize: 13,color: Colors.grey),),
                    SizedBox(height: 10,),
                    Text("No surge fee, ever!",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),),
                    SizedBox(height: 3,),
                    Text("even during rain or peak hours",style: TextStyle(fontSize: 13,color: Colors.grey),),
                    SizedBox(height: 15,),
                  ],
                ),
              ),
            ),
            SizedBox(height: ZMediaQuery(context).height * 0.05,),
          ],
        ),
      ),
    );
  }
}

class _ProgressPainter extends CustomPainter {
  const _ProgressPainter({
    required this.strokeWidth,
    required this.zestyOrderProgress,
    required this.zestyMartOrderProgress,
    required this.totalOrderProgress,
  });

  final double zestyOrderProgress;
  final double zestyMartOrderProgress;
  final double totalOrderProgress;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    Paint zestyOrderPaint = Paint()
        ..color = Colors.black
        ..strokeCap = StrokeCap.butt
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

    Paint zestyMartOrderPaint = Paint()
      ..color = Colors.black38
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    Paint totalOrderPaint = Paint()
      ..color = Colors.black26
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width / 2),
      math.radians(-90),
      math.radians(zestyOrderProgress),
      false,
      zestyOrderPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width / 2),
      math.radians(-90),
      math.radians(zestyMartOrderProgress),
      false,
      zestyMartOrderPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: size.width / 2),
      math.radians(-90),
      math.radians(totalOrderProgress),
      false,
      totalOrderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}