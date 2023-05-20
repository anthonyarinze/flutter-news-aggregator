class NewsArticle {
  final String image;
  final String category;
  final String title;
  final String author;
  final String date;

  NewsArticle({
    required this.image,
    required this.category,
    required this.title,
    required this.author,
    required this.date,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
        image: json['image'],
        category: json['category'],
        title: json['title'],
        author: json['author'],
        date: json['date']);
  }
}
