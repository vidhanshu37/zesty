import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:zesty/custom_widget/elevatedButton_cust.dart';
import 'package:zesty/screens/login_process/otpscreen.dart';
import 'package:zesty/utils/constants/media_query.dart';
import 'package:zesty/utils/constants/text_string.dart';


class signin extends StatelessWidget{
  //final formkey = GlobalKey<FormState>();
  String phone = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Positioned(
                top: 20,
                left: 20,
                right: 20,
                child: Image.asset("assets/images/pic1.jpg",height: ZMediaQuery(context).height * 0.30,)
            ),
            Positioned(
              top: ZMediaQuery(context).height * 0.30 + 40,
                left: 5,
                child: Text(ZText.startApp,style: Theme.of(context).textTheme.headlineLarge,)
            ),

            Positioned(
                top: ZMediaQuery(context).height * 0.30 + 68,
                left: 5,
                child: Text(ZText.loginOrSignup,style: Theme.of(context).textTheme.labelMedium)
            ),

            Positioned(
              top: ZMediaQuery(context).height * 0.30 + 120,
                left: 5,
                child: Text("Enter phone number",style: Theme.of(context).textTheme.bodyLarge,)
            ),

            Positioned(
              top: ZMediaQuery(context).height * 0.30 + 145,
              left: 5,
              right: 5,
              child: IntlPhoneField(
                decoration: InputDecoration(
                  hintText: "00000 00000",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
                initialCountryCode: 'IN',
                onChanged: (phone) {
                  print(phone.completeNumber);
                },
              ),
            ),

            Positioned(
              bottom: 55,
              left: 5,
              right: 5,
              child: ZElevatedButton(title: "Continue",
                  width: ZMediaQuery(context).width,
                  onPress: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => otpverify(phone: phone,),));
                // InternationalPhoneNumberInput(onInputChanged: (PhoneNumber number){
              }),
            ),

            Positioned(
                bottom: 15,
                left: 5,
                right: 5,
                child: Text(ZText.termsConditions,style: Theme.of(context).textTheme.labelMedium)),
          ],
        ),
      ),
    );
  }
}