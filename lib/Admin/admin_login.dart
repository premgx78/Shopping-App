import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_admin.dart';
import 'package:project1/widget/support_widget.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}
TextEditingController usernameController = new TextEditingController();
TextEditingController userpasswordController = new TextEditingController();
class _AdminLoginState extends State<AdminLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(
              top: 33, left: 20, right: 20, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset("assets/images/BAG.jpeg"),

              Center(
                child: Text(
                  "Admin Panel",
                  style: AppWidget.semiBoldTextFieldStyle(),
                ),
              ),
              const SizedBox(height: 10),

              /// NAME
              Text("Username", style: AppWidget.semiBoldTextFieldStyle()),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Username",
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
                  controller: userpasswordController,
                  obscureText: true,
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
                  loginAdmin();
                },
                child: Center(
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width / 3.5,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        "LOGIN",
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
            ],
          ),
        ),
      ),
    );
  }

  loginAdmin() {
    FirebaseFirestore.instance.collection("Admin").get().then((snapshot) {
      snapshot.docs.forEach((result) {
        if (result.data()['username'] != usernameController.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.redAccent,
                content: Text("Your id is not correct"),));
        }
        else
        if (result.data()['password'] != userpasswordController.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.redAccent,
                content: Text("Your password is not correct"),));
        }
        else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeAdmin()));
        }
      });
    });
  }
}