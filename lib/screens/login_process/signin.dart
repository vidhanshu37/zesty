import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:zesty/custom_widget/elevatedButton_cust.dart';
import 'package:zesty/screens/login_process/otpscreen.dart';
import 'package:zesty/utils/constants/colors.dart';
import 'package:zesty/utils/constants/media_query.dart';
import 'package:zesty/utils/constants/text_string.dart';

class signin extends StatefulWidget {
  @override
  State<signin> createState() => _signinState();
}

class _signinState extends State<signin> {
  //final formkey = GlobalKey<FormState>();
  String phnNumber = '';
  FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Positioned(
                top: 70,
                left: 20,
                right: 20,
                child: Image.asset(
                  "assets/images/mobile.jpeg",
                  height: ZMediaQuery(context).height * 0.30,
                )),
            Positioned(
                top: ZMediaQuery(context).height * 0.30 + 80,
                left: 5,
                child: Text(
                  ZText.startApp,
                  style: Theme.of(context).textTheme.headlineLarge,
                )),
            Positioned(
                top: ZMediaQuery(context).height * 0.30 + 108,
                left: 5,
                child: Text(ZText.loginOrSignup,
                    style: Theme.of(context).textTheme.labelMedium)),
            Positioned(
                top: ZMediaQuery(context).height * 0.30 + 160,
                left: 5,
                child: Text(
                  "Enter phone number",
                  style: Theme.of(context).textTheme.bodyLarge,
                )),
            Positioned(
              top: ZMediaQuery(context).height * 0.30 + 185,
              left: 5,
              right: 5,
              child: IntlPhoneField(
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: "00000 00000",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: TColors.error
                    )
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: TColors.error
                      ),
                  ),
                ),
                initialCountryCode: 'IN',
                onChanged: (phone) {
                  print(phone.completeNumber);
                  phnNumber = phone.number.toString();
                  if(phone.number.length == 10) {
                    _focusNode.unfocus();
                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("data")));
                  }
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(phone.completeNumber.toString())));
                },
              ),
            ),
            Positioned(
              top: ZMediaQuery(context).height - 130,
              left: 5,
              right: 5,
              child: ZElevatedButton(
                  title: "Continue",
                  width: ZMediaQuery(context).width,
                  onPress: () {
                    if(phnNumber.length == 10) {
                      sendRequest(phnNumber, context);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => otpverify(
                      //         phone: phnNumber,
                      //         verificationId: "abc",
                      //       ),
                      //     ));
                    }

                    // InternationalPhoneNumberInput(onInputChanged: (PhoneNumber number){
                  }),
            ),
            Positioned(
                top : ZMediaQuery(context).height - 70,
                left: 5,
                right: 5,
                child: Text(ZText.termsConditions,
                    style: Theme.of(context).textTheme.labelMedium)),
          ],
        ),
      ),
    );
  }
}

Future<void> sendRequest(String phnNumber, BuildContext context) async {
  final String url =
      "https://cpaas.messagecentral.com/verification/v3/send?countryCode=91&customerId=C-FFEEE70F02E0486&flowType=SMS&mobileNumber=$phnNumber";

  final String authToken =
      "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJDLUZGRUVFNzBGMDJFMDQ4NiIsImlhdCI6MTc0NDI4NTEwOSwiZXhwIjoxOTAxOTY1MTA5fQ.Plp4E339P0w1XpvRbrPCLnm7SS_VhvzL297szITxV6yTLhWJgVpJdvEY1GtJ3X0U95IElmKXL2QNingV0zVhMw";

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "text/plain",
        "authToken": authToken,
      },
      body: "",
    );

    if (response.statusCode == 200) {
      // print("Request successful: ${response.body}");
      final body = response.body;
      final decode = jsonDecode(body);
      final verificationId = decode['data']['verificationId'];
      // ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text("Request successful: $verificationId")));

      // redirect otp screen
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => otpverify(
              phone: phnNumber,
              verificationId: verificationId,
            ),
          ));
    } else {
      // print("Request failed: ${response.statusCode}, ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
              "Request failed: ${response.statusCode}, ${response.body}")));
    }
  } catch (e) {
    print("Error occurred: $e");
  }
}

