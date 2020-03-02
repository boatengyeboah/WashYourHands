import 'package:flutter/material.dart';

class WashTab extends StatefulWidget {
  WashTab({Key key}) : super(key: key);

  @override
  _WashTabState createState() => _WashTabState();
}

class _WashTabState extends State<WashTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wash'),
      ),
    );
  }
}
