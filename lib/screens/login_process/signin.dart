import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:zesty/custom_widget/elevatedButton_cust.dart';
import 'package:zesty/screens/login_process/otpscreen.dart';
import 'package:zesty/utils/constants/media_query.dart';
import 'package:zesty/utils/constants/text_string.dart';

class signin extends StatefulWidget {
  @override
  State<signin> createState() => _signinState();
}

class _signinState extends State<signin> {
  //final formkey = GlobalKey<FormState>();
  String phnNumber = '';

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
                child: Image.asset(
                  "assets/images/pic1.jpg",
                  height: ZMediaQuery(context).height * 0.30,
                )),
            Positioned(
                top: ZMediaQuery(context).height * 0.30 + 40,
                left: 5,
                child: Text(
                  ZText.startApp,
                  style: Theme.of(context).textTheme.headlineLarge,
                )),
            Positioned(
                top: ZMediaQuery(context).height * 0.30 + 68,
                left: 5,
                child: Text(ZText.loginOrSignup,
                    style: Theme.of(context).textTheme.labelMedium)),
            Positioned(
                top: ZMediaQuery(context).height * 0.30 + 120,
                left: 5,
                child: Text(
                  "Enter phone number",
                  style: Theme.of(context).textTheme.bodyLarge,
                )),
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
                  phnNumber = phone.number.toString();
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(phone.completeNumber.toString())));
                },
              ),
            ),
            Positioned(
              bottom: 75,
              left: 5,
              right: 5,
              child: ZElevatedButton(
                  title: "Continue",
                  width: ZMediaQuery(context).width,
                  onPress: () {
                    if(phnNumber.length == 10) {
                      // sendRequest(phnNumber, context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => otpverify(
                              phone: phnNumber,
                              verificationId: "abc",
                            ),
                          ));
                    }

                    // InternationalPhoneNumberInput(onInputChanged: (PhoneNumber number){
                  }),
            ),
            Positioned(
                bottom: 25,
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
      "https://cpaas.messagecentral.com/verification/v3/send?countryCode=91&customerId=C-5B7E17DA1EBF403&flowType=SMS&mobileNumber=$phnNumber";

  final String authToken =
      "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJDLTVCN0UxN0RBMUVCRjQwMyIsImlhdCI6MTczODM5NDY3NywiZXhwIjoxODk2MDc0Njc3fQ.SGccOO6IMCqRtqN7FIGp_CxyaxyK1sc49BHZJhYrKAAxh7pAPtoqacYL190DyipZ07WHVW_AxR8P7X2Pnjx2fg";

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
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Request successful: $verificationId")));

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

