import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project1/widget/support_widget.dart';
import 'package:project1/pages/services/database.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  String? value;
  final List<String> categoryitem = [
    'Electronics', 'Clothes', 'Home & Appliances', 'Beauty', 'Books', 'Sports'
  ];

  // Pick image from gallery
  Future<void> getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  // Upload product to Firebase
  Future<void> uploadItem() async {
    if (selectedImage != null && nameController.text.isNotEmpty && value != null) {
      String addId = DateTime.now().millisecondsSinceEpoch.toString();

      // Reference firebaseStorageRef =
      // FirebaseStorage.instance.ref().child("blogImage").child(addId);
      // UploadTask task = firebaseStorageRef.putFile(selectedImage!);
      //
      // TaskSnapshot snapshot = await task;
      // String downloadUrl = await snapshot.ref.getDownloadURL();

      String firstletter = nameController.text.substring(0,1).toUpperCase();

      Map<String, dynamic> addProduct = {
        "Name": nameController.text,
        // "Image": downloadUrl,
        "SearchKey": firstletter,
        "UpdatedName": nameController.text.toUpperCase(),
        "Category": value,
        "Price": priceController.text,
        "Detail": detailController.text,
      };

      await DatabaseMethods().addProduct(addProduct, value!).then((value) async{
        await DatabaseMethods().addAllProducts(addProduct);
        selectedImage = null;
        nameController.text = "";
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "Product has been upload Successfully!",
            style: TextStyle(fontSize: 20.0),
          )));
      });

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Please fill all fields and select an image"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
        title: Text("Add Product", style: AppWidget.semiBoldTextFieldStyle()),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Upload The Product Image", style: AppWidget.lightTextFieldStyle()),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: getImage,
                child: Center(
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: selectedImage != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(selectedImage!, fit: BoxFit.cover),
                    )
                        : const Icon(Icons.camera_alt_outlined),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Text("Product Name", style: AppWidget.lightTextFieldStyle()),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
              const SizedBox(height: 20),
              Text("Product Price", style: AppWidget.lightTextFieldStyle()),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: priceController,
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
              const SizedBox(height: 20),
              Text("Product Details", style: AppWidget.lightTextFieldStyle()),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  maxLines: 4,
                  controller: detailController,
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
              const SizedBox(height: 20),
              Text("Product Category", style: AppWidget.lightTextFieldStyle()),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: const Text("Select Category"),
                    value: value,
                    isExpanded: true,
                    dropdownColor: Colors.white,
                    iconSize: 36,
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                    items: categoryitem.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item, style: AppWidget.normalTextFieldStyle()),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        value = newValue;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: uploadItem,
                  child: const Text("Add Product", style: TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
