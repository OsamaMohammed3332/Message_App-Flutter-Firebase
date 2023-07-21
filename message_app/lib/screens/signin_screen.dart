import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:message_app/routes/routes.dart';
import 'package:message_app/screens/helper.dart';
import 'package:message_app/widgets/button_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../widgets/textfield_widget.dart';

class SingingScreen extends StatefulWidget {
  const SingingScreen({super.key});

  @override
  State<SingingScreen> createState() => _SingingScreenState();
}

class _SingingScreenState extends State<SingingScreen> {
  final _auth = FirebaseAuth.instance;
  late String password;
  late String email;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 50,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 180,
                  child: Image.asset("assets/images/logo.png"),
                ),
                const SizedBox(
                  height: 50,
                ),
                TextFieldWidget(
                  controller: emailController,
                  hint: "Enter your Email",
                  isSecure: false,
                  isEmail: true,
                  onChange: (String value) {
                    email = value;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFieldWidget(
                  controller: passwordController,
                  hint: "Enter your Password",
                  isSecure: true,
                  isEmail: false,
                  onChange: (String value) {
                    password = value;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                MyButton(
                  color: Colors.yellow[900]!,
                  title: "Sign in",
                  onPressed: () async {
                    if (emailController.text == "" ||
                        passwordController.text == "") {
                      showSnackBar(context, "Please Fill In The two Fields",
                          Colors.yellow[900]!);
                    } else {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        final user = await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                        if (user.user != null) {
                          Navigator.of(context)
                              .pushNamed(RouteManager.chatPage);
                          setState(() {
                            showSpinner = false;
                          });
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          setState(() {
                            showSpinner = false;
                          });
                          showSnackBar(context, "No user found for that email.",
                          Colors.yellow[900]!);
                        } else if (e.code == 'wrong-password') {
                          setState(() {
                            showSpinner = false;
                          });
                          showSnackBar(context, "Wrong password provided for that user.",
                          Colors.yellow[900]!);
                        }
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
