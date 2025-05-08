import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:recipe/common/api/fireAuth.dart';
import 'package:recipe/pages/register/register_info_view.dart';
import 'package:recipe/pages/widget/buttonComponent.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _LoginViewState();
}

class _LoginViewState extends State<RegisterView> {
  TextEditingController controllerAccount = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerConfirmPassword = TextEditingController();
  bool ifShowPassword = true;
  bool ifShowConfirmPassword = true;
  late Timer timer;

  verifyEmail() {
    EasyLoading.showToast("Please check your email for verification.");
    timer = Timer.periodic(Duration(seconds: 3), (timer) async {
      await FirebaseAuth.instance.currentUser!.reload();
      var verified = FirebaseAuth.instance.currentUser!.emailVerified;
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print("timer.${verified}.................");
        if (verified) {
          EasyLoading.dismiss();
          EasyLoading.showToast("Your email has been verified");
          timer.cancel();
          Future.delayed(Duration(seconds: 1), () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => RegisterInfoView(
                  email: controllerAccount.text,
                ),
              ),
            );
          });
        }
      } else {
        EasyLoading.showToast("User registration failed");
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
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
              'Sign up',
              style: TextStyle(
                color: Color(0xFF282828),
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 24),
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
                  Image.asset(
                    "assets/email.png",
                    width: 20,
                    height: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: controllerAccount,
                      decoration: InputDecoration(
                        hintText: "Your Email",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Color(0xFF595959),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
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
                  Image.asset(
                    "assets/password.png",
                    width: 20,
                    height: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: controllerPassword,
                      obscureText: ifShowPassword,
                      decoration: InputDecoration(
                        hintText: "Your password",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Color(0xFF595959),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  InkWell(
                    onTap: () {
                      setState(() {
                        ifShowPassword = !ifShowPassword;
                      });
                    },
                    child: Image.asset(
                      "assets/visibility.png",
                      width: 20,
                      height: 20,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
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
                  Image.asset(
                    "assets/password.png",
                    width: 20,
                    height: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: controllerConfirmPassword,
                      obscureText: ifShowConfirmPassword,
                      decoration: const InputDecoration(
                        hintText: "Confirm password",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Color(0xFF595959),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  InkWell(
                    onTap: () {
                      setState(() {
                        ifShowConfirmPassword = !ifShowConfirmPassword;
                      });
                    },
                    child: Image.asset(
                      "assets/visibility.png",
                      width: 20,
                      height: 20,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 36),
            InkWell(
              onTap: () async {
                if (controllerAccount.text.trim().isEmpty) {
                  return EasyLoading.showToast("Account cannot be empty");
                }
                if (controllerPassword.text.trim().isNotEmpty &&
                    controllerPassword.text.trim() ==
                        controllerConfirmPassword.text.trim()) {
                  User? user = await FireAuth.registerUsingEmailPassword(
                    email: controllerAccount.text.trim(),
                    password: controllerConfirmPassword.text.trim(),
                  );
                  print(user);
                  if (user != null) {
                    await user.sendEmailVerification();
                    verifyEmail();
                  }
                } else {
                  EasyLoading.showToast(
                      "The passwords entered twice do not match");
                }
              },
              child: ButtonComponent(
                btnColor: const Color(0xff282828),
                text: "SIGN UP",
                btnWidth: (MediaQuery.of(context).size.width - 64),
                borderRadius: 12,
                textColor: Colors.white,
              ),
            ),
            const SizedBox(height: 36),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: MediaQuery.of(context).size.width - 64,
                alignment: Alignment.centerLeft,
                child: const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Already have an account?  ',
                        style: TextStyle(
                          color: Color(0xFF110C26),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: 'Sign in',
                        style: TextStyle(
                          color: Color(0xFFFF5C00),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
