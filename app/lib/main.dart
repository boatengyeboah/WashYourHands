import 'dart:async';

import 'package:flutter/material.dart';
import 'package:saving_our_planet/main_tabs.dart';
import 'package:saving_our_planet/pref_keys.dart';
import 'package:saving_our_planet/set_country.dart';
import 'package:shared_preferences/shared_preferences.dart';

const int _bluePrimaryValue = 0xFF002952;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear(); // TODO: Remove this.
  Widget initialWidget =  MainTabs();
  
  if (!prefs.containsKey(COUNTRY_DATA_SET_KEY)) {
    initialWidget = SetCountry();
  }

  runZoned(() {
    runApp(MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: MaterialColor(
          _bluePrimaryValue,
          <int, Color>{
            50: Color(0xFFE3F2FD),
            100: Color(0xFFBBDEFB),
            200: Color(0xFF90CAF9),
            300: Color(0xFF64B5F6),
            400: Color(0xFF42A5F5),
            500: Color(_bluePrimaryValue),
            600: Color(0xFF1E88E5),
            700: Color(0xFF1976D2),
            800: Color(0xFF1565C0),
            900: Color(0xFF0D47A1),
          },
        ),
      ),
      home:initialWidget,
    ));
  });
}
