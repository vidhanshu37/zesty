import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:zesty/custom_widget/elevatedButton_cust.dart';
import 'package:zesty/screens/login_process/otpscreen.dart';
import 'package:zesty/utils/constants/text_string.dart';


class signin extends StatelessWidget{
  final formkey = GlobalKey<FormState>();
  String phone = '';

  // void submitForm() {
  //   if(formkey.currentState?.validate() ?? false){
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Form is valid")));
  //   } else{
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Form is invalid")));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:[ Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: formkey,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 150,),
                Text(ZText.startApp,style: Theme.of(context).textTheme.headlineLarge,),
                const SizedBox(height: 10,),
                Text(ZText.loginOrSignup,style:
                Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 40,),
                IntlPhoneField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(

                      borderSide: BorderSide(),
                    ),
                  ),
                  initialCountryCode: 'IN',

                  onChanged: (phone) {

                    print(phone.completeNumber);
                  },
                ),
                // InternationalPhoneNumberInput(onInputChanged: (PhoneNumber number){
                //   phone = number.phoneNumber ?? '' ;
                //   print(number.phoneNumber);
                // },
                //   selectorConfig: SelectorConfig(
                //     selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                //   ),
                //   initialValue: PhoneNumber(isoCode: 'IN'),
                //   maxLength: 10,
                //   selectorTextStyle: TextStyle(color: Colors.black),
                //   textFieldController: TextEditingController(),
                //   formatInput: false,
                //   cursorColor: Colors.black,
                //   keyboardType: TextInputType.numberWithOptions(signed: true,decimal: true),
                //   inputDecoration: InputDecoration(
                //     fillColor: Color(0xFFFFFFFF),
                //     focusedBorder: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(5),
                //         borderSide: BorderSide(color: Color(0xFF343848))),
                //     enabledBorder: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(10),
                //         borderSide: BorderSide(color: Color(0xFF343835))),
                //     border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(10),
                //         borderSide:
                //         BorderSide(color: Color(0xFF343835), width: 2)),
                //     hintText: "Enter Phone Number",
                //     hintStyle: TextStyle(color: Colors.black),
                //   ),
                //   validator: (value) {
                //     if(value == null || value.isEmpty){
                //       return 'Please enter your phone number';
                //     }
                //   },
                // ),

                const SizedBox(height: 100,),
                ZElevatedButton(title: "Continue", onPress: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => otpverify(phone: phone,),));
                }),
                const SizedBox(height: 10,),
                Text(ZText.termsConditions,style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
          ),
        ),]
      ),
    );
  }
}