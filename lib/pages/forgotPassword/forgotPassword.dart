import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:recipe/pages/widget/buttonComponent.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _LoginViewState();
}

class _LoginViewState extends State<ForgotPassword> {
  TextEditingController controllerAccount = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  bool ifShowPassword = true;
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
            const Text(
              'Forgot Password',
              style: TextStyle(
                color: Color(0xFF282828),
                fontSize: 24,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              width: MediaQuery.of(context).size.width - 64,
              height: 56,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFDDDDDD),
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: controllerAccount,
                      decoration: const InputDecoration(
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
            const SizedBox(height: 36),
            InkWell(
              onTap: () async {
                EasyLoading.show(status: 'loading...');
                await FirebaseAuth.instance.sendPasswordResetEmail(
                    email: controllerAccount.text.trim());
                Navigator.of(context).pop();
                EasyLoading.showToast(
                    "Please go to your email to verify and set a new password");
              },
              child: ButtonComponent(
                btnColor: const Color(0xff282828),
                text: "Reset Password",
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
