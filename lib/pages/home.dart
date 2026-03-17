import 'package:project1/widget/support_widget.dart';
import 'package:flutter/material.dart';
import 'package:project1/pages/category_products.dart';
import 'package:project1/pages/services/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project1/pages/services/database.dart';
import 'package:project1/pages/product_detail.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool search = false;
  List categories = [
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

  List queryResultSet = [];
  List tempSearchStore = [];
  TextEditingController searchcontroller = new TextEditingController();

  initiateSearch(String value) async {
    if (value.isEmpty) {
      setState(() {
        search = false;
        queryResultSet = [];
        tempSearchStore = [];
      });
      return;
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    setState(() {
      search = true;
    });

    if (queryResultSet.isEmpty && value.length == 1) {
      QuerySnapshot snapshot =
      await DatabaseMethods().search(capitalizedValue);
      queryResultSet = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    }

    tempSearchStore = queryResultSet.where((element) {
      return element['UpdatedName']
          .toString()
          .startsWith(capitalizedValue);
    }).toList();

    setState(() {});
  }

  String? name, image;

  getthesharedpref() async {
    name = await SharedPreferenceHelper().getUserName();
    image = await SharedPreferenceHelper().getUserImage();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      body: name == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView( // CHANGED: wraps everything for full page scroll
        child: Container(
          margin: const EdgeInsets.only(top: 50.0, left: 25.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hey, $name",
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Text(
                        "Good Morning",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 23,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                      image!,
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 25.0),

              // Search Field
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                width: MediaQuery.of(context).size.width,
                child: TextField(
                  controller: searchcontroller,
                  onChanged: (val) {
                    initiateSearch(val.toUpperCase());
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search Products",
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    prefixIcon: search? GestureDetector(
                        onTap: (){
                          search = false;
                          tempSearchStore = [];
                          queryResultSet = [];
                          searchcontroller.text = "";
                          setState(() {

                          });
                        },
                        child: Icon(Icons.close)): Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),

              // Search Results
              if (search)
                ListView(
                  shrinkWrap: true, // IMPORTANT inside SingleChildScrollView
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  children: tempSearchStore.map((element) {
                    return buildResultCard(element);
                  }).toList(),
                )
              else ...[
                // Categories Header
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Categories",
                          style: AppWidget.semiBoldTextFieldStyle()),
                      const Text(
                        "See All",
                        style: TextStyle(
                            color: Color(0xDF5F5FFF),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),

                // Categories Row
                Row(
                  children: [
                    Container(
                      height: 135,
                      padding: const EdgeInsets.all(20.0),
                      margin: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xDF5F5FFF),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Center(
                        child: Text(
                          "All",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 135,
                        child: ListView.builder(
                          itemCount: categories.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return CategoryTile(
                              image: categories[index],
                              name: CategoryName[index],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),

                // All Products Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("All Products",
                        style: AppWidget.semiBoldTextFieldStyle()),
                    const Text(
                      "See All",
                      style: TextStyle(
                          color: Color(0xDF5F5FFF),
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),

                // CHANGED: Products Grid instead of horizontal ListView
                GridView.count(
                  crossAxisCount: 2,         // 2 columns
                  shrinkWrap: true,           // fits inside SingleChildScrollView
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.78,    // controls card height — tweak if needed
                  children: [
                    buildProductCard("assets/images/Headphone.jpeg", "Headphone", 100),
                    buildProductCard("assets/images/Shoes.jpeg", "Shoes", 120),
                    buildProductCard("assets/images/Headphone.jpeg", "Headphone", 100),
                    buildProductCard("assets/images/Shoes.jpeg", "Shoes", 120),
                  ],
                ),
                const SizedBox(height: 20.0),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget buildResultCard(Map data) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetail(image: data["Image"], name: data["Name"], detail: data["Detail"], price: data["Price"])));
      },
      child: Container(
        padding: EdgeInsets.only(left: 20.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        height: 100,
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                data["Image"] ?? "",
                height: 70,
                width: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 50),
              ),
            ),
            const SizedBox(width: 20),
            Text(
              data["Name"],
              style: AppWidget.semiBoldTextFieldStyle(),
            ),
          ],
        ),
      ),
    );
  }

  // CHANGED: removed fixed sizes, let GridView control the dimensions
  Widget buildProductCard(String img, String name, int price) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            img,
            height: 100,
            width: double.infinity,
            fit: BoxFit.contain,
          ),
          Text(name, style: AppWidget.semiBoldTextFieldStyle()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("\$$price",
                  style: const TextStyle(
                      color: Color(0xDF5F5FFF),
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: const Color(0xDF5F5FFF),
                    borderRadius: BorderRadius.circular(7)),
                child: const Icon(Icons.add, color: Colors.white),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final String image, name;
  const CategoryTile({super.key, required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CategoryProduct(category: name)));
        },
        child: Container(
          padding: const EdgeInsets.all(20.0),
          margin: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          height: 90,
          width: 90,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                image,
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20.0),
              const Icon(Icons.arrow_forward)
            ],
          ),
        ));
  }
}