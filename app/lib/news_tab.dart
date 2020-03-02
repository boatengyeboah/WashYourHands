import 'package:flutter/material.dart';

class NewsTab extends StatefulWidget {
  NewsTab({Key key}) : super(key: key);

  @override
  _NewsTabState createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
      ),
    );
  }
}
