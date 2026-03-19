import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project1/widget/support_widget.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

import 'package:project1/pages/services/database.dart';
import 'package:project1/pages/services/shared_pref.dart';

const String secretkey = "sk_test_51SzfixBYCPFHYKhK516x58YwAuzY7qkUdzOumC88V62bqVtd74XHV1i4AjSnGU6HQ4WsEjkwyPvHRpIl6xdByGe900PyLVOwWT";

class ProductDetail extends StatefulWidget {
  String image, name, detail, price;

  ProductDetail({
    required this.image,
    required this.name,
    required this.detail,
    required this.price,
  });

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  String? name, mail, image;

  Map<String, dynamic>? paymentIntent;

  getthesharedpref() async {
    name = await SharedPreferenceHelper().getUserName();
    mail = await SharedPreferenceHelper().getUserEmail();
    image = await SharedPreferenceHelper().getUserImage();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
  }

  @override
  void initState() {
    super.initState();
    ontheload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(top: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Back Button
            Container(
              padding: const EdgeInsets.only(left: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back_ios_new_outlined),
              ),
            ),

            /// Product Image
            Center(
              child: Image.network(
                widget.image,
                height: 400,
              ),
            ),

            /// Bottom Container
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                    top: 10.0, left: 20.0, right: 20.0),
                decoration: const BoxDecoration(
                  color: Color(0xfff2f2f2),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// Product Name + Price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              widget.name,
                              style: AppWidget.boldTextFieldStyle(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "\$${widget.price}",
                            style: const TextStyle(
                                color: Color(0xDF5F5FFF),
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),

                      const SizedBox(height: 20),

                      Text(
                        "Details",
                        style: AppWidget.semiBoldTextFieldStyle(),
                      ),

                      const SizedBox(height: 10),

                      Text(widget.detail),

                      const SizedBox(height: 30),

                      /// BUY BUTTON
                      GestureDetector(
                        onTap: () {
                          makePayment(widget.price);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
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
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// PAYMENT FUNCTION

  Future<void> makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'USD');

      if (paymentIntent == null || paymentIntent!['client_secret'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text("Payment setup failed. Check your Stripe key."),
          ),
        );
        return;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'Prem',
        ),
      );

      displayPaymentSheet();

    } catch (e, s) {
      print('Exception: $e$s');
    }
  }

  /// SHOW PAYMENT SHEET

  displayPaymentSheet() async {
    try {

      await Stripe.instance.presentPaymentSheet();

      /// SAVE ORDER
      Map<String, dynamic> orderInfoMap = {
        "ProductName": widget.name,
        "Price": widget.price,
        "Name": name,
        "Email": mail,
        "UserImage": image,
        "ProductImage": widget.image,
        "Status": "On the way"
      };

      await DatabaseMethods().orderDetails(orderInfoMap);

      /// SUCCESS DIALOG
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 10),
                  Text("Payment Successful"),
                ],
              )
            ],
          ),
        ),
      );

      paymentIntent = null;

    } on StripeException catch (e) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          content: Text("Payment Cancelled"),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  /// CREATE PAYMENT INTENT

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretkey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );

      print("Stripe response code: ${response.statusCode}");
      print("Stripe response body: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text("Stripe Error: ${jsonDecode(response.body)['error']['message']}"),
            duration: const Duration(seconds: 5),
          ),
        );
        return null;
      }

    } catch (err) {
      print('Error charging user: ${err.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Network Error: ${err.toString()}"),
          duration: const Duration(seconds: 5),
        ),
      );
      return null;
    }
  }

  /// CALCULATE AMOUNT

  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount) * 100);
    return calculatedAmount.toString();
  }
}