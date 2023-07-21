import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:message_app/routes/routes.dart';
import 'package:message_app/screens/helper.dart';
import 'package:message_app/widgets/button_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../widgets/textfield_widget.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  late String password;
  late String email;
  bool showSpinner = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
                  title: "Register",
                  color: Colors.blue[800]!,
                  onPressed: () async {
                    if (emailController.text == "" ||
                        passwordController.text == "") {
                      showSnackBar(context, "Please Fill In The two Fields",
                          Colors.blue[800]!);
                    } else {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        await _auth.createUserWithEmailAndPassword(
                            email: email, password: password);
                        Navigator.of(context).pushNamed(RouteManager.chatPage);
                        setState(() {
                          showSpinner = false;
                        });
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          setState(() {
                            showSpinner = false;
                          });
                          showSnackBar(
                              context,
                              "The password provided is too weak.",
                              Colors.blue[800]!);
                        } else if (e.code == 'email-already-in-use') {
                          setState(() {
                            showSpinner = false;
                          });
                          showSnackBar(
                              context,
                              "The account already exists for that email.",
                              Colors.blue[800]!);
                        }
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
