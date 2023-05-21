import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:news_aggregator/components/news_card.dart';
import 'package:news_aggregator/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  int activePage = 0;
  final List<String> imgList = [
    "images/star.jpg",
    "images/star.jpg",
    "images/star.jpg",
    "images/star.jpg",
    "images/star.jpg",
  ];

  Future<List<Widget>> fetchArticles() async {
    String? apiKey = dotenv.env['API_KEY'];
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //Check if cached data exists
    if (prefs.containsKey('cachedArticles')) {
      //Retrieve cached data
      final cachedData = prefs.getString('cachedArticles').toString();
      final cachedArticles = jsonDecode(cachedData) as List<dynamic>;

      //transform cached data into widgets
      final newsCards = cachedArticles.map<Widget>((article) {
        String? image = article['urlToImage'] ?? '';
        String? title = article['title'] ?? '';
        String? author = article['source']['name'] ?? '';
        String? date = article['publishedAt'] ?? '';

        return NewsCard(
          networkImage: image!,
          title: title!,
          author: author!,
          date: date!,
        );
      }).toList();
      return newsCards;
    } else {
      var response = await http.get(
        Uri.parse(
            'https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=$apiKey'),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var articles = responseData['articles'];
        List<Widget> newsCards = [];

        for (var article in articles) {
          String? image = article['urlToImage'] ?? '';
          String? title = article['title'] ?? '';
          String? author = article['source']['name'] ?? '';
          String? date = article['publishedAt'] ?? '';

          Widget newsCard = NewsCard(
            networkImage: image!,
            title: title!,
            author: author!,
            date: date!,
          );

          newsCards.add(newsCard);
        }
        //cache the fetched articles
        prefs.setString('cachedArticles', jsonEncode(articles));

        return newsCards;
      } else {
        throw Exception('Failed to fetch news articles');
      }
    }
  }

  @override
  void initState() async {
    super.initState();
    await dotenv.load();
    _pageController = PageController(viewportFraction: 0.8);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    child: Icon(Icons.menu, size: 30),
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Icon(Icons.search, size: 30),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10.0),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              themeProvider.toggleTheme();
                            });
                          },
                          icon: Icon(
                            themeProvider.isDarkMode
                                ? Icons.sunny
                                : Icons.nightlight,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0, top: 20.0),
                      child: Text(
                        "Recommended",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  FutureBuilder<List<Widget>>(
                    future: fetchArticles(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        return Column(
                          children: snapshot.data!,
                        );
                      } else {
                        return const Text('No articles found');
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<Widget> indicators(int imageLength, int currentIndex) {
  const int maxVisibleIndicators = 5;
  final int visibleIndicators =
      imageLength > maxVisibleIndicators ? maxVisibleIndicators : imageLength;

  return List<Widget>.generate(visibleIndicators, (index) {
    final int relativeIndex = imageLength - visibleIndicators + index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
      margin: const EdgeInsets.all(3.0),
      width: currentIndex == relativeIndex ? 10 : 7,
      height: currentIndex == relativeIndex ? 10 : 7,
      decoration: BoxDecoration(
        color: currentIndex == relativeIndex ? Colors.black : Colors.black26,
        shape: BoxShape.circle,
      ),
    );
  });
}

List<Widget> indicatorss(imageLength, currentIndex) {
  return List<Widget>.generate(imageLength, (index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
      margin: const EdgeInsets.all(3.0),
      width: currentIndex == index ? 10 : 7,
      height: currentIndex == index ? 10 : 7,
      decoration: BoxDecoration(
        color: currentIndex == index ? Colors.black : Colors.black26,
        shape: BoxShape.circle,
      ),
    );
  });
}
