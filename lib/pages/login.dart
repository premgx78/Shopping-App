import 'package:flutter/material.dart';
import 'package:project1/widget/support_widget.dart';
import 'package:project1/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project1/pages/bottomnav.dart';
import 'package:project1/pages/home.dart';

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

userLogin()async{
  try{
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

    Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNav()));
  } on FirebaseAuthException catch(e){
    if(e.code == 'user-not-found'){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "User not found!",
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    } else if(e.code == 'wrong-password'){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Incorrect Password",
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }
  }

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
      child: Container(
        margin:  EdgeInsets.only(top: 33.0, left: 20.0, right: 20.0, bottom: 40.0),
        child: Form(
          key: _formkey,
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("assets/images/CART.jpeg"),
            SizedBox(height: 20.0),
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
              padding: EdgeInsets.only(left: 20.0,),
              decoration: BoxDecoration(color: Color(0xFFF4F5F9), borderRadius: BorderRadius.circular(10.0)),
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Password';
                  }
                  return null;
                },
                decoration: InputDecoration (border: InputBorder.none, hintText: "Password",),
              ),
            ),
            SizedBox(height: 10.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Forgot Password", style: TextStyle(color: Colors.blue, fontSize: 18.0, fontWeight: FontWeight.w500),),
              ],
            ),
            SizedBox(height: 20.0,),
            GestureDetector(
              onTap: (){
                if (_formkey.currentState!.validate()) {
                  setState(() {
                    email = emailController.text;
                    password = passwordController.text;
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
