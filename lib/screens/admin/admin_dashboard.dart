import 'package:Ebook_App/screens/admin/books.dart';
import 'package:Ebook_App/screens/admin/admin_homepage.dart';
import 'package:Ebook_App/screens/admin/admin_profile.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  static const routeName = '/admindashboard';

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;

  Widget currentPage(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return AdminHomePage();

        break;
      case 1:
        return Books();
        break;
      case 2:
        return AdminProfile();
        break;
      default:
        return AdminHomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPage(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        iconSize: 20,
        selectedFontSize: 13,
        unselectedFontSize: 12,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            title: Text('Book'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
