import 'package:flutter/material.dart';
import 'package:project1/widget/support_widget.dart';

class ProductDetail extends StatefulWidget {
String image, name, detail, price;
ProductDetail({required this.image, required this.name, required this.detail, required this.price});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(top: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              padding: const EdgeInsets.only(left: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back_ios_new_outlined),
              ),
            ),

            Center(
              child: Image.network(
                widget.image,
                height: 400,
              ),
            ),
            Expanded(
                child:
            Container(
              padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0,),
              decoration: BoxDecoration(
                color: Color(0xfff2f2f2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),),
              ),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.name, style: AppWidget.boldTextFieldStyle(),),
                      Text("\$"+widget.price,
                          style: TextStyle(
                              color: Color(0xDF5F5FFF),
                              fontSize: 30,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                  SizedBox(height: 20.0,),
                  Text("Details", style: AppWidget.semiBoldTextFieldStyle(),),
                  SizedBox(height: 10.0,),
                  Text(widget.detail),
              SizedBox(height: 100.0,),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                decoration: BoxDecoration(
                  color: const Color(0xDF5F5FFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: MediaQuery.of(context).size.width,
                child: const Center(
                  child: Text(
                    "Buy Now",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
                ],
              )
            ))
          ],
        ),
      ),
    );
  }
}
