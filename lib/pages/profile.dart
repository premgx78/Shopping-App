import 'package:flutter/material.dart';
import 'package:project1/widget/support_widget.dart';
import 'package:project1/pages/services/shared_pref.dart';
import 'package:project1/widget/support_widget.dart';
import 'package:project1/pages/services/auth.dart';
import 'package:project1/pages/onboarding.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? image, name, email;
  getthesharedpref()async{
    image = await SharedPreferenceHelper().getUserImage();
    name = await SharedPreferenceHelper().getUserName();
    email = await SharedPreferenceHelper().getUserEmail();
    setState(() {

    });

  }

  @override
  void initState() {
    getthesharedpref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyanAccent,
        title: Text("Profile", style: AppWidget.boldTextFieldStyle()),
      ),
      backgroundColor: Colors.cyanAccent,
      body: name == null? Center(child: CircularProgressIndicator()): Container(
        child:Column(
          children: [
            Center(
              child: ClipRRect(borderRadius: BorderRadius.circular(15),
                child: Image.network(image!,
                  height: 250.0,
                  width: 250.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20.0,),
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: [
                      Icon(Icons.person_outline, size: 35,),
                      SizedBox(width: 10.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Name", style: AppWidget.lightTextFieldStyle(),),
                          Text(name!, style: AppWidget.semiBoldTextFieldStyle(),),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.mail_outline, size: 35),
                      SizedBox(width: 10.0),
                      // Wrap Column with Expanded so it takes remaining space
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Email",
                              style: AppWidget.lightTextFieldStyle(),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // horizontal scroll
                              child: Text(
                                email!,
                                style: AppWidget.semiBoldTextFieldStyle(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0,),
            GestureDetector(
              onTap: () async{
                await AuthMethods().SignOut().then((value) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Onboarding()),);
                });
              },
              child: Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Material(
                  elevation: 3.0,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        Icon(Icons.logout, size: 35,),
                        SizedBox(width: 10.0,),
                        Text("LogOut", style: AppWidget.semiBoldTextFieldStyle(),),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_outlined),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0,),
            GestureDetector(
              onTap: () async{
                await AuthMethods().deleteUser().then((value) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Onboarding()),);
                });
              },
              child: Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Material(
                  elevation: 3.0,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        Icon(Icons.delete_outlined, size: 35,),
                        SizedBox(width: 10.0,),
                        Text("Delete", style: AppWidget.semiBoldTextFieldStyle(),),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_outlined),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
