import 'package:flutter/material.dart';
import 'package:saving_our_planet/api_client.dart';
import 'package:saving_our_planet/news.dart';
import 'package:saving_our_planet/spacing.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class NewsTab extends StatefulWidget {
  NewsTab({Key key}) : super(key: key);

  @override
  _NewsTabState createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
  List<News> newsList = [];

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future fetchData() async {
    List<News> news = await ApiClient.fetchNews();
    setState(() {
      this.newsList = news;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
      ),
      body: Container(
        padding: inset3,
        child: RefreshIndicator(
          onRefresh: fetchData,
          child: ListView(
            children: this.newsList.map((news) {
              if (news.thumbnailUrl == null) {
                return Container();
              }
              return Container(
                padding: inset3v,
                child: GestureDetector(
                  onTap: () {
                    launch(news.url);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        height: 180.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            news.thumbnailUrl,
                            height: 180.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        margin: inset2t,
                        child: Text(
                          news.sourceName,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle
                              .copyWith(color: Colors.grey),
                        ),
                      ),
                      Container(
                        margin: inset2t,
                        child: Text(
                          news.title,
                          style: Theme.of(context).textTheme.subhead.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Container(
                        margin: inset1t,
                        child: Text(news.description),
                      ),
                      Container(
                        margin: inset1t,
                        child: Text(
                          timeago.format(news.publishedAt),
                          style: Theme.of(context)
                              .textTheme
                              .subtitle
                              .copyWith(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
