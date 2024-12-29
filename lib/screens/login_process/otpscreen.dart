import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zesty/custom_widget/elevatedButton_cust.dart';
import 'package:zesty/screens/login_process/signin.dart';
import 'package:zesty/utils/constants/text_string.dart';

class otpverify extends StatefulWidget{

  final String phone;
  otpverify({required this.phone});

  @override
  State<otpverify> createState() => _otpverifyState();
}

class _otpverifyState extends State<otpverify> {


  List<TextEditingController> _otpcontroller = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> focusnode = List.generate(4, (_) => FocusNode());
  bool _isResendAvailable = false;
  int _timer = 30;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(Duration(seconds: 1),(){
      if(_timer > 0){
        setState(() {

          _timer--;
        });
        _startTimer();
      } else{
        setState(() {
          _isResendAvailable = true;
        });
      }
    });
  }

  void _resendOTP() {
    setState(() {
      _timer = 0030;

      _isResendAvailable = false;
      _startTimer();
    });
  }

  void _handleotpinput(String value,int index){
    if(value.isNotEmpty){
      if(index < _otpcontroller.length - 1){

        FocusScope.of(context).requestFocus(focusnode[index+1]);
      } else{
        FocusScope.of(context).unfocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [ Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30,),
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => signin(),));
                  },
                ),
                const SizedBox(height: 7,),
                Text(ZText.lable,style: Theme.of(context).textTheme.headlineLarge),
                SizedBox(height: 7,),
                Text("Enter OTP sent to ${widget.phone} vio sms",style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                  List.generate(4, (index) => _otpTextField(index),),),
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Didn't receive OTP ?",style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(width: 40,),
                    _isResendAvailable ? InkWell(
                      onTap: _resendOTP,
                      child: Text("Resend" ,style: Theme.of(context).textTheme.titleLarge),
                    ) : Text('00:$_timer',style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
                const SizedBox(height: 50,),
                ZElevatedButton(title: "Verify & Continue", onPress: (){})
              ],
            ),
          ),]
      ) ,
    );
  }

  Widget _otpTextField(int index){
    return Container(
      width: 50,
      height: 50,
      child: TextField(
        controller: _otpcontroller[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) => _handleotpinput(value,index),
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                  width: 2,
                  color: Colors.grey
              )
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                width: 2,
                color: Colors.grey,
              )
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                width: 2,
                color: Colors.black,
              )
          ),
          counterText: '',
        ),
      ),
    );
  }
}