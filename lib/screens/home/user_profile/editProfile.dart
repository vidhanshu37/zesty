import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zesty/utils/constants/colors.dart';
import 'package:zesty/utils/local_storage/HiveOpenBox.dart';
import 'package:http/http.dart' as http;

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({super.key});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  var box = Hive.box(HiveOpenBox.storeAddress);
  String savedName = "abc";
  String savedEmail = "abc@gmail.com";
  String savedPhone = "9876543210";

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String? editingField;
  bool isUpdateEnabled = false;

  @override
  void initState() {
    super.initState();
    savedName = box.get(HiveOpenBox.userName, defaultValue: "Zesty");
    savedPhone = box.get(HiveOpenBox.userMobile);
    if (box.get(HiveOpenBox.userEmail) != "abc") {
      savedEmail = box.get(HiveOpenBox.userEmail, defaultValue: "Please register your email");
    } else {
      savedEmail = "Register your email";
    }
    nameController.text = savedName;
    emailController.text = savedEmail;
    phoneController.text = savedPhone;
  }

  void startEditing(String field) {
    setState(() {
      editingField = field;
      isUpdateEnabled = false;
    });
  }

  bool isValidEmail(String email) {
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  void checkIfUpdated() {
    setState(() {
      bool isPhoneValid = phoneController.text.length == 10;
      bool isEmailValid = isValidEmail(emailController.text);

      isUpdateEnabled = (editingField == "Name" && nameController.text != savedName) ||
          (editingField == "Email" && emailController.text != savedEmail && isEmailValid) ||
          (editingField == "Phone" && phoneController.text != savedPhone && isPhoneValid);
    });
  }

  Future<void> updateAddress(context) async {
    var box = Hive.box(HiveOpenBox.storeAddress);
    final url = Uri.parse('https://zesty-backend.onrender.com/user/update-user');

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": savedName,
          "email": savedEmail,
          "mobile": savedPhone,
          "id": box.get(HiveOpenBox.userId),
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Updated!")));
        box.put(HiveOpenBox.userName, savedName);
        box.put(HiveOpenBox.userMobile, savedPhone);
        box.put(HiveOpenBox.userEmail, savedEmail);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.statusCode.toString())));
      }
    } catch (e) {
      print("error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("e.toString()")));
    }
  }

  void updateValues() {
    if (nameController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        phoneController.text.trim().isNotEmpty) {
      if (editingField == "Email" && !isValidEmail(emailController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid email format")));
        return;
      }

      updateAddress(context);
      setState(() {
        if (editingField == "Name") savedName = nameController.text;
        if (editingField == "Email") savedEmail = emailController.text;
        if (editingField == "Phone") savedPhone = phoneController.text;

        editingField = null;
        isUpdateEnabled = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Not Valid!")));
    }
  }

  void cancelEditing() {
    setState(() {
      if (editingField == "Name") nameController.text = savedName;
      if (editingField == "Email") emailController.text = savedEmail;
      if (editingField == "Phone") phoneController.text = savedPhone;

      editingField = null;
      isUpdateEnabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "EDIT ACCOUNT",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: TColors.grey,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildEditableField("Name", nameController),
            const SizedBox(height: 16),
            buildEditableField("Email", emailController),
            const SizedBox(height: 16),
            buildPhoneField(),
            const Spacer(),
            if (editingField != null)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isUpdateEnabled ? updateValues : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        isUpdateEnabled ? const Color(0xFF70B943) : Colors.grey.shade400,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text("Update",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: cancelEditing,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.Green.withOpacity(0.4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide.none),
                      child: const Text("Cancel",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget buildEditableField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: editingField == label ? TColors.darkGreen : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: editingField == label,
                  onChanged: (_) => checkIfUpdated(),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  ),
                  cursorColor: TColors.black,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              if (editingField != label)
                TextButton(
                  onPressed: () => startEditing(label),
                  child: const Text("EDIT",
                      style: TextStyle(color: TColors.darkGreen, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Phone Number",
            style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: editingField == "Phone" ? TColors.darkGreen : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text("+91", style: TextStyle(fontSize: 16, color: Colors.black)),
              ),
              Expanded(
                child: TextField(
                  controller: phoneController,
                  enabled: editingField == "Phone",
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (value.length > 10) {
                      phoneController.text = value.substring(0, 10);
                      phoneController.selection = TextSelection.fromPosition(
                          TextPosition(offset: phoneController.text.length));
                    }
                    checkIfUpdated();
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  cursorColor: TColors.black,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              // if (editingField != "Phone")
                // TextButton(
                //   onPressed: () => startEditing("Phone"),
                //   child: const Text("EDIT",
                //       style: TextStyle(color: TColors.darkGreen, fontWeight: FontWeight.bold)),
                // ),
            ],
          ),
        ),
      ],
    );
  }
}
