import 'package:flutter/material.dart';
import 'package:saving_our_planet/spacing.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourcesTab extends StatefulWidget {
  ResourcesTab({Key key}) : super(key: key);

  @override
  _ResourcesTabState createState() => _ResourcesTabState();
}

class _ResourcesTabState extends State<ResourcesTab> {
  List<_ResourceData> resourceDataList = [];

  @override
  void initState() {
    this.resourceDataList.add(_ResourceData(
        title: '1. How to protect yourself?',
        thumbnail: 'https://i.ytimg.com/vi/bPITHEiFWLc/maxresdefault.jpg',
        url: 'https://youtu.be/bPITHEiFWLc'));

    this.resourceDataList.add(_ResourceData(
        title: '2. What are the symptoms?',
        thumbnail:
            'https://www.cdc.gov/coronavirus/2019-ncov/images/2019-coronavirus.png',
        url: 'https://www.cdc.gov/coronavirus/2019-ncov/about/symptoms.html'));

    this.resourceDataList.add(_ResourceData(
        title: '3. Timeline of the Coronavirus',
        thumbnail:
            'https://www.thinkglobalhealth.org/sites/default/files/2020-01/SK.JB-CoV-Timeline-1.29.20-InCover-RTS300G7-THREE-FOUR.jpg',
        url:
            'https://www.thinkglobalhealth.org/article/updated-timeline-coronavirus'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Useful Resources'),
      ),
      body: Container(
        margin: inset3,
        child: ListView(
          children: this.resourceDataList.map((resourceData) {
            return Container(
              padding: inset3v,
              child: GestureDetector(
                onTap: () {
                  launch(resourceData.url);
                },
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            child: Text(
                              resourceData.title,
                              style:
                                  Theme.of(context).textTheme.subhead.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 100.0,
                      height: 100.0,
                      margin: inset2l,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          resourceData.thumbnail,
                          height: 180.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _ResourceData {
  final String thumbnail;
  final String title;
  final String url;

  _ResourceData({this.thumbnail, this.title, this.url});
}
