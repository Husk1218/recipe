import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:recipe/pages/TabView/home.dart';
import 'package:recipe/pages/widget/buttonComponent.dart';

class RegisterInfoView extends StatefulWidget {
  final String email;
  const RegisterInfoView({super.key, required this.email});

  @override
  State<RegisterInfoView> createState() => _LoginViewState();
}

class _LoginViewState extends State<RegisterInfoView> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerNumber = TextEditingController();
  TextEditingController controllerSchool = TextEditingController();

  Widget InputTips(String text) {
    return Text(
      text,
      style: TextStyle(
          color: Color(0xFF595959), fontSize: 14, fontWeight: FontWeight.w400),
    );
  }

  Future<void> addUserDetails(
      String userId, String name, String phoneNumber, String school) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users
        .doc(userId)
        .set({
          'name': name,
          'phoneNumber': phoneNumber,
          'email': widget.email,
          'school': school,
        }, SetOptions(merge: true))
        .then((value) => print("User detail add success"))
        .catchError((error) => print("add user detail failed: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tell us more about you',
              style: TextStyle(
                color: Color(0xFF282828),
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputTips('Your Name'),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  width: MediaQuery.of(context).size.width - 64,
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFFDDDDDD),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controllerName,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Color(0xFF595959),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputTips('Your Phone Number'),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  width: MediaQuery.of(context).size.width - 64,
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFFDDDDDD),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controllerNumber,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Color(0xFF595959),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputTips('Your School'),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  width: MediaQuery.of(context).size.width - 64,
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFFDDDDDD),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controllerSchool,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Color(0xFF595959),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 36),
            InkWell(
              onTap: () async {
                if (controllerName.text.trim().isEmpty ||
                    controllerNumber.text.trim().isEmpty ||
                    controllerSchool.text.trim().isEmpty) {
                  EasyLoading.showToast(
                      "Name PhoneNumber School cannot be empty");
                  return;
                } else {
                  if (FirebaseAuth.instance.currentUser != null) {
                    EasyLoading.show(status: 'loading...');
                    User? user = FirebaseAuth.instance.currentUser;
                    await addUserDetails(
                      user!.uid,
                      controllerName.text.trim(),
                      controllerNumber.text.trim(),
                      controllerSchool.text.trim(),
                    );
                    EasyLoading.dismiss();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => HomePage()),
                      (route) => false,
                    );
                  } else {
                    print("No user log in");
                  }
                }
              },
              child: ButtonComponent(
                btnColor: const Color(0xff282828),
                text: "START",
                btnWidth: (MediaQuery.of(context).size.width - 64),
                borderRadius: 12,
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
