import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:saving_our_planet/disclaimer_tab.dart';
import 'package:saving_our_planet/map_tab.dart';
import 'package:saving_our_planet/news_tab.dart';
import 'package:saving_our_planet/resources_tab.dart';
import 'package:saving_our_planet/wash_tab.dart';

class MainTabs extends StatefulWidget {
  MainTabs({Key key}) : super(key: key);

  @override
  _MainTabsState createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> {
  List<Widget> pages = [];
  int currentIndex = 0;

  @override
  void initState() {
//    pages.add(MapTab());
    pages.add(NewsTab());
    pages.add(WashTab());
//    pages.add(ResourcesTab());
    pages.add(DisclaimerTab());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: currentIndex, // this will be set when a new tab is tapped
        onTap: (index) {
          setState(() {
            this.currentIndex = index;
          });
        },
        items: [
//          BottomNavigationBarItem(
//            icon: new Icon(Icons.map),
//            title: new Text('Home'),
//          ),
          BottomNavigationBarItem(
            icon: new Icon(FontAwesomeIcons.solidNewspaper),
            title: new Text('News'),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.handHolding),
            title: Text('Wash'),
          ),
//          BottomNavigationBarItem(
//            icon: Icon(FontAwesomeIcons.solidLightbulb),
//            title: Text('Resources'),
//          ),
          // BottomNavigationBarItem(
          //   icon: Icon(FontAwesomeIcons.info),
          //   title: Text('Disclaimer'),
          // ),
        ],
      ),
    );
  }
}
