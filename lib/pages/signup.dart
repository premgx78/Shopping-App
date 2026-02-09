import 'package:flutter/material.dart';
import 'package:project1/widget/support_widget.dart';
import 'package:project1/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project1/pages/bottomnav.dart';
import 'package:random_string/random_string.dart';
import 'package:project1/pages/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project1/pages/services/shared_pref.dart';
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}
bool isLoading = false;
class _SignUpState extends State<SignUp> {
  String? name, email, password;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  Future<void> registration() async {
    if (name != null && email != null && password != null) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email!,
          password: password!,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Registered Successfully...",
              style: TextStyle(fontSize: 18),
            ),
          ),
        );
        String Id = randomAlphaNumeric(10);
        await SharedPreferenceHelper().saveUserEmail(emailController.text);
        await SharedPreferenceHelper().saveUserId(Id);
        await SharedPreferenceHelper().saveUserName(nameController.text);
        await SharedPreferenceHelper().saveUserImage("https://img.freepik.com/premium-vector/boy-with-blue-hoodie-blue-hoodie-with-hoodie-it_1230457-42660.jpg?semt=ais_user_personalization&w=740&q=80");
        Map<String, dynamic> userInfoMap = {
          "Name" : nameController.text,
          "Email" : emailController.text,
          "Id" : Id,
          "Image" : "https://img.freepik.com/premium-vector/boy-with-blue-hoodie-blue-hoodie-with-hoodie-it_1230457-42660.jpg?semt=ais_user_personalization&w=740&q=80",
        };
        await DatabaseMethods().addUserDetails(userInfoMap, Id);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNav()),);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text("The password is too weak"),
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text("Account already exists"),
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(
              top: 33, left: 20, right: 20, bottom: 40),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("assets/images/BAG.jpeg"),
                const SizedBox(height: 20),

                Center(
                  child: Text(
                    "Sign Up",
                    style: AppWidget.semiBoldTextFieldStyle(),
                  ),
                ),
                const SizedBox(height: 10),

                Center(
                  child: Text(
                    "Please enter the details below to continue.",
                    textAlign: TextAlign.center,
                    style: AppWidget.lightTextFieldStyle(),
                  ),
                ),
                const SizedBox(height: 40),

                /// NAME
                Text("Name", style: AppWidget.semiBoldTextFieldStyle()),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F5F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Name';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Full Name",
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// EMAIL
                Text("Email", style: AppWidget.semiBoldTextFieldStyle()),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F5F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Email';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "abc@gmail.com",
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// PASSWORD
                Text("Password", style: AppWidget.semiBoldTextFieldStyle()),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F5F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Password';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Password",
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                /// SIGNUP BUTTON
                GestureDetector(
                  onTap: () {
                    if (_formkey.currentState!.validate()) {
                      setState(() {
                        name = nameController.text.trim();
                        email = emailController.text.trim();
                        password = passwordController.text.trim();
                      });
                      registration();
                    }
                  },
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3.5,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text(
                          "SIGN UP",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// LOGIN NAVIGATION
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?  ",
                      style: AppWidget.lightTextFieldStyle(),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()),
                        );
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}