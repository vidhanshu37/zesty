import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zesty/custom_widget/elevatedButton_cust.dart';
import 'package:zesty/screens/home/home.dart';
import 'package:zesty/screens/location_access/locationAccess.dart';
import 'package:zesty/screens/login_process/signin.dart';
import 'package:zesty/utils/constants/colors.dart';
import 'package:zesty/utils/constants/media_query.dart';
import 'package:zesty/utils/constants/text_string.dart';
import 'package:zesty/utils/http/userExistAPI.dart';
import 'package:zesty/utils/local_storage/HiveOpenBox.dart';

class otpverify extends StatefulWidget{

  final String phone, verificationId;
  otpverify({
    required this.phone,
    required this.verificationId
  });

  @override
  State<otpverify> createState() => _otpverifyState();
}

class _otpverifyState extends State<otpverify> {

  List<TextEditingController> _otpcontroller = List.generate(4, (_) => TextEditingController());

  String getOtp(){
    return _otpcontroller.map((e) => e.text).join();
  }

  final List<FocusNode> focusnode = List.generate(4, (_) => FocusNode());
  bool _isResendAvailable = false;
  int _timer = 30;

  @override
  void initState() {
    super.initState();
    _startTimer();
    // checkUserStatus();
    userExistPhone(widget.phone);
  }

  /// Check user exists or not
  int responseCode = 0;
  Map<String, dynamic>? userExistData = {};

  Future<void> userExistPhone(phoneNumber) async {
    final url = Uri.parse(
        'https://zesty-backend.onrender.com/user/check-exist');
    try {
      final response = await http.post(
        url,
          headers: {
            "Content-Type": "application/json",
          },
        body: jsonEncode({
          "mobile": phoneNumber,
        })
      );
      userExistData = jsonDecode(response.body);
      responseCode = response.statusCode;
    } catch (e) {
      responseCode = 500;
    }
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
    if(value.isNotEmpty && index < _otpcontroller.length - 1){
      FocusScope.of(context).requestFocus(focusnode[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(focusnode[index - 1]);
    }
  }


  /// Validate OTP and determine user exist or not
  Future<void> validateOtp(String phnNumber, String verificationId, String userOtp) async {
    String url = "https://cpaas.messagecentral.com/verification/v3/validateOtp"
        "?countryCode=91"
        "&mobileNumber=$phnNumber"
        "&verificationId=$verificationId"
        "&customerId=C-5B7E17DA1EBF403"
        "&code=$userOtp";

    Map<String, String> headers = {
      "authToken":
      "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJDLTVCN0UxN0RBMUVCRjQwMyIsImlhdCI6MTczODQxMDk3NSwiZXhwIjoxODk2MDkwOTc1fQ.P5dM1uCoon3VEmnz0jvngUdyGiJoZYRM574VPyiKLQxwJZJctRCoQDOtG0UgIoI9SKMhht5l2rMT0ecg-iBpBQ",
      "Content-Type": "text/plain",
    };

    try {
      var response = await http.get(Uri.parse(url), headers: headers);

      final body = response.body;
      final decode = jsonDecode(body);

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        /// SUCCESS

        if(responseCode == 200) {
            var box = Hive.box(HiveOpenBox.storeAddress);
            box.put(HiveOpenBox.storeAddressTitle, userExistData?['userExist']['address']);
            box.put(HiveOpenBox.storeAddressSubTitle, "");
            box.put(HiveOpenBox.storeAddressLat, userExistData?['userExist']['latitute']);
            box.put(HiveOpenBox.storeAddressLong, userExistData?['userExist']['longitude']);
            box.put(HiveOpenBox.userId, userExistData?['userExist']['_id']);
            box.put(HiveOpenBox.userEmail, userExistData?['userExist']['email']);
            box.put(HiveOpenBox.userMobile, userExistData?['userExist']['mobile']);
            box.put(HiveOpenBox.userZestyLite, userExistData?['userExist']['zestyLite']);
            box.put(HiveOpenBox.userZestyMoney, userExistData?['userExist']['zestyMoney']);
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => HomeScreen(address: userExistData?['userExist']['address'], subAddress: "")), (predicate) => false);
        } else if (responseCode == 405) {
          var box = Hive.box(HiveOpenBox.storeLatLongTable);
          box.put(HiveOpenBox.mobile, widget.phone);
          Navigator.push(context, MaterialPageRoute(builder: (context) => LocationAccess(),));
        }
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseCode.toString())));

      } else {
        // print("Error: ${response.statusCode}, ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(decode['message'])));
      }
    } catch (e) {
      print("Exception: $e");
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
                ZElevatedButton(title: "Verify & Continue", onPress: (){
                  String otp = getOtp();
                  // print("Enter otp: $otp");
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(otp)));
                  validateOtp(widget.phone, widget.verificationId, otp);
                  //
                }),
              ],
            ),
          ),]
      ) ,
    );
  }


  // custom widget for otp box
  Widget _otpTextField(int index){
    return Container(
      width: 50,
      height: 50,
      child: TextField(
        cursorColor: Colors.black,
        controller: _otpcontroller[index],
        focusNode: focusnode[index],
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
                  color: TColors.darkerGrey,
              )
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                width: 2,
                color: TColors.grey,
              )
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                width: 2,
                color:  TColors.darkGrey,
              )
          ),
          counterText: '',
        ),
      ),
    );
  }
}




// user exist :
// post: /user/user-exist      body: mobile   statuscode: 200-success  405-notexist
// user register :
// post: /user/register - body: mobile, email, address, latitute, longitude- status code: 200-success  405-exist
