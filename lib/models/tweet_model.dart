class Tweet {
  final String id;
  final String text;
  final String favorites;
  final String retweets;
  final String date;

  Tweet({this.id, this.text, this.favorites, this.retweets, this.date});

  factory Tweet.fromJson(Map<String, dynamic> json) {
    return Tweet(
      id: json['id'] as String,
      text: json['text'] as String,
      favorites: json['favorites'] as String,
      retweets: json['retweets'] as String,
      date: json['date'] as String,
    );
  }

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "text": text,
        "favorites": favorites,
        "retweets": retweets,
        "date": date
      };
}
