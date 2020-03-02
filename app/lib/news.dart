class News {
  final String title;
  final String description;
  final String url;
  final String sourceName;
  final DateTime publishedAt;
  final String thumbnailUrl;

  News({
    this.title,
    this.description,
    this.url,
    this.sourceName,
    this.publishedAt,
    this.thumbnailUrl,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title'],
      description: json['description'],
      url: json['url'],
      sourceName: json['source']['name'],
      publishedAt: DateTime.parse(json['publishedAt']),
      thumbnailUrl: json['urlToImage'],
    );
  }
}
