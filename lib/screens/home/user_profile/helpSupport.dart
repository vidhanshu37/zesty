import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zesty/custom_widget/elevatedButton_cust.dart';

import '../../../utils/constants/colors.dart';

class Helpsupport extends StatefulWidget {
  const Helpsupport({super.key});

  @override
  State<Helpsupport> createState() => _HelpsupportState();
}

class _HelpsupportState extends State<Helpsupport> {
  final TextEditingController emailController = TextEditingController();

  final List<Map<String, String>> faqs = [
    {
      "question": "What is Zesty Customer Care Number?",
      "answer": "We value our customer's time and hence moved away from a single customer care number to a comprehensive chat-based support system for quick and easy resolution. You no longer have to go through the maze of an IVRS call support. Just search for your issue in the help section on this page and initiate a chat with us. A customer care executive will be assigned to you shortly."
    },
    {
      "question": "I am unable to place a cash on delivery order",
      "answer": "COD option may not be available due to below reasons: \n\n 1.High value order \n 2.If order is placed from a desktop application\n 3.Any recent history of canceling a COD order \n 4.New or inactive accounts \n\n To enable COD in the future, consider placing a few prepaid orders. Meanwhile, you can choose from our secure and convenient payment options. \n\n In case if your reason is not listed here, please write to us at support @zestyy377.in"
    },
    {
      "question": "I want to Provide feedback",
      "answer": ""
    },
    {
      "question": "Is single order from many restaurants possible?",
      "answer": "We currently do not support this functionality. However, you can place orders for individual items from different restaurants."
    },
  ];
  
  Future<void> sendEmail() async {
    final String email = "zestyy377@gmail.com";
    final String subject = Uri.encodeComponent("Help & Support Query");
    final String body = Uri.encodeComponent(emailController.text);

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=$subject&body=$body',
    );

    if (await canLaunchUrl(emailUri)){
      await launchUrl(emailUri);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email send Successfully")));
    } else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Could not open email app")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              Text("Register your request",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              SizedBox(height: 15,),
              const SizedBox(height: 5),
              TextFormField(
                maxLines: 5,
                controller: emailController,
                maxLength: 200,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                    hintText: "Mention your query",
                    counterStyle: TextStyle(fontSize: 10)
                ),
              ),
              SizedBox(height: 15,),
              ZElevatedButton(title: "Submit", onPress: (){
                sendEmail();
              }),
              SizedBox(height: 15,),
              Container(
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: faqs.map((faq) {
                    return ExpansionTile(
                      title: Text(faq["question"]!, style: TextStyle(fontSize: 13,),overflow: TextOverflow.ellipsis,maxLines: 2,),
                        iconColor: Colors.black, // Change expanded icon color
                        collapsedIconColor: Colors.black, // Change collapsed icon color
                      children: [
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: faq["question"] == "I want to Provide feedback"
                              ? ElevatedButton(
                              onPressed: (){
                                print("Clicked");
                                sendEmail();
                          }, child: Text("Send Email"))
                              : Text(faq["answer"]!,overflow: TextOverflow.ellipsis,maxLines: 15,style: TextStyle(fontSize: 12,color: TColors.darkerGrey),)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
