import 'package:Ebook_App/screens/client/client_homepage.dart';

import 'package:Ebook_App/screens/client/favourites.dart';

import 'package:Ebook_App/screens/client/more_info.dart';
import 'package:flutter/material.dart';

class ClientDashboard extends StatefulWidget {
  static const routeName = '/clientdashboard';

  @override
  _ClientDashboardState createState() => _ClientDashboardState();
}

class _ClientDashboardState extends State<ClientDashboard> {
  int _currentIndex = 0;

  Widget currentPage(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return ClientHomePage();

        break;

      case 1:
        return FavouriteBook();
        break;

      case 2:
        return MoreInfo();
        break;
      default:
        return ClientHomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPage(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        iconSize: 20,
        backgroundColor: Colors.white,
        selectedFontSize: 13,
        unselectedFontSize: 12,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            title: Text('Favourite'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            title: Text('More'),
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
