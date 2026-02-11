import 'package:flutter/material.dart';
import 'package:project1/widget/support_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project1/pages/services/database.dart';
import 'package:project1/pages/product_detail.dart';

class CategoryProduct extends StatefulWidget {
  final String category;

  const CategoryProduct({super.key, required this.category});

  @override
  State<CategoryProduct> createState() => _CategoryProductState();
}

class _CategoryProductState extends State<CategoryProduct> {
  Stream? CategoryStream;

  getOnTheLoad() async {
    CategoryStream =
    await DatabaseMethods().getProducts(widget.category);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getOnTheLoad();
  }

  Widget allProducts() {
    return StreamBuilder(
        stream: CategoryStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0),
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds =
                snapshot.data.docs[index];

                return Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0,),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10.0,),
                      Image.network(
                        ds["Image"],
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 10),
                      Text(
                        ds["Name"],
                        style: AppWidget.semiBoldTextFieldStyle(),
                      ),
                      Spacer(),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\$${ds["Price"]}",
                            style: TextStyle(
                                color: Color(0xDF5F5FFF),
                                fontSize: 20,
                                fontWeight:
                                FontWeight.bold),
                          ),
                          SizedBox(
                            width: 30.0,
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetail(detail: ds["Detail"], image: ds["Image"], name: ds["Name"], price: ds["Price"])));
                            },
                            child: Container(
                              padding:
                              EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color:
                                  Color(0xDF5F5FFF),
                                  borderRadius:
                                  BorderRadius.circular(
                                      7)),
                              child: Icon(Icons.add,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: Color(0xfff2f2f2),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, ),
        child: Column(
          children: [
            Expanded(child: allProducts()),
          ],
        ),
      ),
    );
  }
}
