import 'package:flutter/material.dart';

import 'home.dart';
import 'order.dart';
import 'profile.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0;

  late List<Widget> pages;

  late Home homePage;
  late Order orderPage;
  late Profile profilePage;

  @override
  void initState() {
    homePage = Home();
    orderPage = Order();
    profilePage = Profile();

    pages = [homePage, orderPage, profilePage];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentTabIndex],
      extendBody: true,
      floatingActionButton: Container(
        height: 65,
        width: 65,
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              currentTabIndex = 0;
            });
          },
          backgroundColor: currentTabIndex == 0 ? Colors.white : Colors.black,
          elevation: 2,
          shape: CircleBorder(),
          child: Icon(
            Icons.home,
            color: currentTabIndex == 0 ? Colors.black : Colors.white,
            size: 32,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        color: Colors.white,
        elevation: 10,
        height: 50,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side - Orders
              IconButton(
                onPressed: () {
                  setState(() {
                    currentTabIndex = 1;
                  });
                },
                icon: Icon(
                  Icons.shopping_bag_outlined,
                  color: currentTabIndex == 1
                      ? Colors.black
                      : Colors.grey,
                  size: 30,
                ),
              ),

              // Space for FAB
              SizedBox(width: 60),

              // Right side - Profile
              IconButton(
                onPressed: () {
                  setState(() {
                    currentTabIndex = 2;
                  });
                },
                icon: Icon(
                  Icons.person_outline,
                  color: currentTabIndex == 2
                      ? Colors.black
                      : Colors.grey,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}