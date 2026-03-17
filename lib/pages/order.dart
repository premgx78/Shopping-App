import 'package:flutter/material.dart';
import 'package:project1/widget/support_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project1/pages/services/database.dart';
import 'package:project1/pages/product_detail.dart';
import 'package:project1/pages/services/shared_pref.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String? email;

  getthesharedpref()async{
    email = await SharedPreferenceHelper().getUserEmail();
    setState(() {

    });
  }
  
  Stream? orderStream;

  getontheload()async{
    await getthesharedpref();
    orderStream = await DatabaseMethods().getOrders(email!);
    setState(() {
      
    });
  }
  
  @override
  void initState() {
    getontheload();
    super.initState();
  }
  
  Widget allOrders() {
    return StreamBuilder(
        stream: orderStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds =
                snapshot.data.docs[index];

                return Container(
                  margin: EdgeInsets.only(bottom: 20.0,),
                  child: Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0,),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:
                      Row(
                        children: [
                          Image.network(
                            ds["Image"],
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                          Spacer(),
                          Padding(padding: const EdgeInsets.only(right: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ds["Product"],
                                style: AppWidget.semiBoldTextFieldStyle(),
                              ),

                              Text(
                                "\$" + ds["Price"],
                                style: const TextStyle(
                                    color: Color(0xDF5F5FFF),
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold),
                              ),

                              Text(
                                "Status : " + ds["Status"],
                                style: const TextStyle(
                                    color: Color(0xDF5F5FFF),
                                    fontSize: 2,
                                    fontWeight: FontWeight.bold),
                              ),

                            ],),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyanAccent,
      appBar: AppBar(
        backgroundColor: Colors.cyanAccent,
        title: Text("Current Orders", style: AppWidget.boldTextFieldStyle(),),),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0,),
        child: Column(
          children: [
            Expanded(child: allOrders())
          ],
        ),
      ),
    );
  }
}