import 'package:project1/widget/support_widget.dart';
import 'package:flutter/material.dart';
import 'package:project1/pages/category_products.dart';
import 'package:project1/pages/services/shared_pref.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List categories=[
    "assets/images/Electronics.jpeg",
    "assets/images/Clothes.jpeg",
    "assets/images/Home.jpeg",
    "assets/images/Beauty.jpeg",
    "assets/images/Books.jpeg",
    "assets/images/Sports.jpeg"
  ];

  List CategoryName = [
    "Electronics",
    "Clothes",
    "Home & Appliances",
    "Beauty",
    "Books",
    "Sports",
  ];

  String? name, image;

  getthesharedpref()async{
    name = await SharedPreferenceHelper().getUserName();
    image = await SharedPreferenceHelper().getUserImage();
    setState(() {

    });
  }

  ontheload()async{
    await getthesharedpref();
    setState(() {

    });
  }

  @override
  void initState(){
    ontheload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      body: name == null? Center(child: CircularProgressIndicator()): Container(
        margin: EdgeInsets.only(top: 50.0, left: 25.0, right : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hey, "+name!,
                      style: TextStyle(color: Colors.redAccent,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600,),
                    ),
                    Text("Good Morning", style: TextStyle(
                        color: Colors.black,
                        fontSize: 23,
                        fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(image!, height: 60, width: 60, fit: BoxFit.cover,),
                )
              ],
            ),
            SizedBox(height: 25.0,),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              width: MediaQuery.of(context).size.width,
              child: TextField(
                decoration: InputDecoration(border: InputBorder.none, hintText: "Search Products", hintStyle: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold), prefixIcon: Icon(Icons.search, color: Colors.black,)),
              ),
            ),
            SizedBox(height: 20.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Categories", style: AppWidget.semiBoldTextFieldStyle()),
                Text("See All", style: TextStyle(color: Color(0xDF5F5FFF), fontSize: 20, fontWeight: FontWeight.bold))
              ],
            ),
            SizedBox(height: 20.0,),
            Row(
              children: [
                Container(
                  height: 135,
                  padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Color(0xDF5F5FFF),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
          "All",
          style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold),),),
      ),
                Expanded(
                    child: Container(
                     height: 135,
                      child: ListView.builder(
                        itemCount: categories.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index){
                        return CategoryTile (image: categories [index], name: CategoryName[index],);
                        }),
                    ),
                ),
              ],
            ),
            SizedBox(height: 20.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("All Products", style: AppWidget.semiBoldTextFieldStyle()),
                Text("See All", style: TextStyle(color: Color(0xDF5F5FFF), fontSize: 20, fontWeight: FontWeight.bold))
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 20.0,),

                  Container(
                    height: 210,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 20.0,),
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10),),
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/images/Headphone.jpeg",
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                              Text("Headphone",style: AppWidget.semiBoldTextFieldStyle()),
                              SizedBox(height: 10.0,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                Text("\$100", style: TextStyle(color: Color(0xDF5F5FFF), fontSize: 20, fontWeight: FontWeight.bold),),
                                SizedBox(width: 40.0,),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(color: Color(0xDF5F5FFF), borderRadius: BorderRadius.circular(7)),
                                  child: Icon(Icons.add, color: Colors.white,),
                                )
                              ],)
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 20.0,),
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10),),
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/images/Shoes.jpeg",
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                              Text("Shoes",style: AppWidget.semiBoldTextFieldStyle()),
                              SizedBox(height: 10.0,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("\$120", style: TextStyle(color: Color(0xDF5F5FFF), fontSize: 20, fontWeight: FontWeight.bold),),
                                  SizedBox(width: 40.0,),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(color: Color(0xDF5F5FFF), borderRadius: BorderRadius.circular(7)),
                                    child: Icon(Icons.add, color: Colors.white,),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 20.0,),
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10),),
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/images/Headphone.jpeg",
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                              Text("Headphone",style: AppWidget.semiBoldTextFieldStyle()),
                              SizedBox(height: 10.0,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("\$100", style: TextStyle(color: Color(0xDF5F5FFF), fontSize: 20, fontWeight: FontWeight.bold),),
                                  SizedBox(width: 40.0,),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(color: Color(0xDF5F5FFF), borderRadius: BorderRadius.circular(7)),
                                    child: Icon(Icons.add, color: Colors.white,),
                                  )
                                ],)
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 20.0,),
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10),),
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/images/Shoes.jpeg",
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                              Text("Shoes",style: AppWidget.semiBoldTextFieldStyle()),
                              SizedBox(height: 10.0,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("\$120", style: TextStyle(color: Color(0xDF5F5FFF), fontSize: 20, fontWeight: FontWeight.bold),),
                                  SizedBox(width: 40.0,),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(color: Color(0xDF5F5FFF), borderRadius: BorderRadius.circular(7)),
                                    child: Icon(Icons.add, color: Colors.white,),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 20.0,),
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10),),
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/images/Headphone.jpeg",
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                              Text("Headphone",style: AppWidget.semiBoldTextFieldStyle()),
                              SizedBox(height: 10.0,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("\$100", style: TextStyle(color: Color(0xDF5F5FFF), fontSize: 20, fontWeight: FontWeight.bold),),
                                  SizedBox(width: 40.0,),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(color: Color(0xDF5F5FFF), borderRadius: BorderRadius.circular(7)),
                                    child: Icon(Icons.add, color: Colors.white,),
                                  )
                                ],)
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 20.0,),
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10),),
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/images/Shoes.jpeg",
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                              Text("Shoes",style: AppWidget.semiBoldTextFieldStyle()),
                              SizedBox(height: 10.0,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("\$120", style: TextStyle(color: Color(0xDF5F5FFF), fontSize: 20, fontWeight: FontWeight.bold),),
                                  SizedBox(width: 40.0,),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(color: Color(0xDF5F5FFF), borderRadius: BorderRadius.circular(7)),
                                    child: Icon(Icons.add, color: Colors.white,),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 20.0,),
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10),),
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/images/Headphone.jpeg",
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                              Text("Headphone",style: AppWidget.semiBoldTextFieldStyle()),
                              SizedBox(height: 10.0,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("\$100", style: TextStyle(color: Color(0xDF5F5FFF), fontSize: 20, fontWeight: FontWeight.bold),),
                                  SizedBox(width: 40.0,),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(color: Color(0xDF5F5FFF), borderRadius: BorderRadius.circular(7)),
                                    child: Icon(Icons.add, color: Colors.white,),
                                  )
                                ],)
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 20.0,),
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10),),
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/images/Shoes.jpeg",
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              ),
                              Text("Shoes",style: AppWidget.semiBoldTextFieldStyle()),
                              SizedBox(height: 10.0,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("\$120", style: TextStyle(color: Color(0xDF5F5FFF), fontSize: 20, fontWeight: FontWeight.bold),),
                                  SizedBox(width: 40.0,),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(color: Color(0xDF5F5FFF), borderRadius: BorderRadius.circular(7)),
                                    child: Icon(Icons.add, color: Colors.white,),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class CategoryTile extends StatelessWidget {
  String image, name;
  CategoryTile({required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
  return GestureDetector(
    onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryProduct(category: name)));
    },
    child: Container(
      padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      height: 90,
      width: 90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(image, height: 50, width: 50, fit: BoxFit.cover,),
          SizedBox(height: 20.0,),
          Icon(Icons.arrow_forward)
        ],
      ),
    )
  );
  }
  }