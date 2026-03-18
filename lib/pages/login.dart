import 'package:flutter/material.dart';
import 'package:project1/widget/support_widget.dart';
import 'package:project1/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project1/pages/bottomnav.dart';
import 'package:project1/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project1/pages/services/shared_pref.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
String email="", password="";

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

bool _obscurePassword = true;

userLogin() async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    String uid = userCredential.user!.uid;

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();

    if (!userDoc.exists) {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection("users")
          .where("Email", isEqualTo: email)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        userDoc = query.docs.first;
      }
    }

    if (userDoc.exists) {
      await SharedPreferenceHelper().saveUserId(uid);
      await SharedPreferenceHelper().saveUserEmail(userDoc["Email"]);
      await SharedPreferenceHelper().saveUserName(userDoc["Name"]);
      await SharedPreferenceHelper().saveUserImage(userDoc["Image"]);
    }

    if (!mounted) return; // ADDED
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => BottomNav()));

  } on FirebaseAuthException catch (e) {
    print("❌ Auth error code: ${e.code}"); // keep this to verify

    String message = "Login failed. Please try again.";
    if (e.code == 'user-not-found' ||
        e.code == 'wrong-password' ||
        e.code == 'invalid-credential' ||
        e.code == 'invalid-email') {
      message = "Invalid email or password.";
    } else if (e.code == 'user-disabled') {
      message = "This account has been disabled.";
    } else if (e.code == 'too-many-requests') {
      message = "Too many attempts. Try again later.";
    }

    if (!mounted) return; // ADDED
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(message, style: const TextStyle(fontSize: 18)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

forgotPassword() async {
  // show dialog to enter email
  TextEditingController resetEmailController = TextEditingController();

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Reset Password"),
      content: TextField(
        controller: resetEmailController,
        decoration: const InputDecoration(
          hintText: "Enter your email",
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            if (resetEmailController.text.trim().isEmpty) {
              return;
            }
            try {
              await FirebaseAuth.instance.sendPasswordResetEmail(
                email: resetEmailController.text.trim(),
              );
              Navigator.pop(context);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text(
                    "Password reset email sent! Check your inbox.",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              );
            } on FirebaseAuthException catch (e) {
              Navigator.pop(context);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.redAccent,
                  content: Text(
                    e.code == 'user-not-found'
                        ? "No account found with this email."
                        : "Something went wrong. Try again.",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              );
            }
          },
          child: const Text(
            "Send",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
      child: Container(
        margin:  EdgeInsets.only(left: 20.0, right: 20.0, bottom: 40.0),
        child: Form(
          key: _formkey,
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("assets/images/CART.jpeg"),
            Center(
              child: Text(
                "Sign In",
                style: AppWidget.semiBoldTextFieldStyle(),
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "Please enter the details below to\ncontinue.",
              textAlign: TextAlign.center,
              style: AppWidget.lightTextFieldStyle(),
            ),
            SizedBox(height: 40.0,),
            Text("Email", style: AppWidget.semiBoldTextFieldStyle(),),
            SizedBox(height: 10.0,),
            Container(
              padding: EdgeInsets.only(left: 20.0,),
              decoration: BoxDecoration(color: Color(0xFFF4F5F9), borderRadius: BorderRadius.circular(10.0)),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Email';
                  }
                  return null;
                },
                controller: emailController,
                decoration: InputDecoration (border: InputBorder.none, hintText: "abc@gmail.com",),
              ),
            ),
            SizedBox(height: 20.0,),
            Text("Password", style: AppWidget.semiBoldTextFieldStyle(),),
            SizedBox(height: 10.0,),
            Container(
              padding: const EdgeInsets.only(left: 20.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F5F9),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextFormField(
                controller: passwordController,
                obscureText: _obscurePassword, // CHANGED
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Password';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Password",
                  suffixIcon: IconButton( // ADDED
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: (){
                    forgotPassword();
                  },
                  child: Text("Forgot Password",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0,),
            GestureDetector(
              onTap: () {
                if (_formkey.currentState!.validate()) {
                  setState(() {
                    email = emailController.text.trim();
                    password = passwordController.text.trim();
                  });
                  userLogin();
                }
              },
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width/3.5,
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(20.0), ),
                  child: Center(
                    child: Text("LOGIN", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold,),),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?  ", style: AppWidget.lightTextFieldStyle(),),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                    );
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18.0,
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
