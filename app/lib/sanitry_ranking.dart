class SanitryRankingResponse {
  final List<SanitryRanking> byCities;
  final List<SanitryRanking> byCountries;

  SanitryRankingResponse({this.byCities, this.byCountries});
}

class SanitryRanking {
  final int score;
  final String name;

  SanitryRanking({this.score, this.name});

  factory SanitryRanking.fromJson(Map<String, dynamic> json) {
    return SanitryRanking(
      score: json['score'],
      name: json['name'],
    );
  }
}
