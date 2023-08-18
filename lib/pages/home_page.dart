import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_aggregator/components/newspaper_sheet.dart';
import 'package:news_aggregator/provider/theme_provider.dart';
import 'package:news_aggregator/utils/dio_manager/dio_manager.dart';
import 'package:provider/provider.dart';

import '../components/news_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  int activePage = 0;
  int selectedIndex = 0;
  String? apiKey = dotenv.env['API_KEY'];
  String? baseUrl = dotenv.env['TECH_CRUNCH'];
  String? fallbackUrl = dotenv.env['FALLBACK_URL'];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  Future fetchArticles() async {
    final response = await DioManager().get("$baseUrl$apiKey");
    return response;
  }

  void updateBaseUrl(String newUrl) {
    setState(() {
      baseUrl = newUrl;
    });
  }

  List<Map<String, dynamic>> cardData = [
    {"name": "Tech Crunch", "url": dotenv.env['TECH_CRUNCH']},
    {"name": "Apple News", "url": dotenv.env['APPLE_NEWS']},
    {"name": "Tesla News", "url": dotenv.env['TESLA_NEWS']},
    {"name": "Business Headlines", "url": dotenv.env['USA_NEWS']},
    {"name": "Wall Street Journal", "url": dotenv.env['WSJ_NEWS']},
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      drawer: Drawer(
        child: ListView.builder(
          itemCount: cardData.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(cardData[index]['name']),
              onTap: () {
                updateBaseUrl(cardData[index]['url']);
                selectedIndex = index;
                Navigator.pop(context); // Close the drawer
              },
              tileColor: selectedIndex == index ? const Color(0xFF353C47) : null,
              selectedTileColor: const Color(0xFF353C47),
              textColor: selectedIndex == index ? Colors.white : null,
            );
          },
        ),
      ),
      appBar: AppBar(
        scrolledUnderElevation: 2.0,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Newsly'),
            Row(
              children: [
                const Icon(Icons.search, size: 30),
                const SizedBox(width: 10.0),
                IconButton(
                  onPressed: () {
                    setState(() {
                      themeProvider.toggleTheme();
                    });
                  },
                  icon: Icon(
                    themeProvider.isDarkMode ? Icons.sunny : Icons.nightlight,
                    size: 30,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.0, top: 20.0),
                      child: Text(
                        "Recommended",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: fetchArticles(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Column(
                          children: [
                            if (snapshot.data != null) Text(snapshot.data!.length.toString()),
                            SelectableText('Error: ${snapshot.error}'),
                          ],
                        );
                      } else if (snapshot.hasData) {
                        final Brightness brightness = Theme.of(context).brightness;
                        final bool isDarkMode = brightness == Brightness.dark;
                        return SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            itemCount: snapshot.data['totalResults'],
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () => showModalBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
                                  enableDrag: true,
                                  showDragHandle: true,
                                  isScrollControlled: true,
                                  backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
                                  builder: (context) => NewsPaperSheet(
                                    isDarkMode: isDarkMode,
                                    title: snapshot.data['articles'][index]['title'] ?? "N/A",
                                    publishedAt: snapshot.data['articles'][index]['publishedAt'] ?? "N/A",
                                    author: snapshot.data['articles'][index]['author'] ?? "N/A",
                                    publisher: snapshot.data['articles'][index]['source']['name'],
                                    content: snapshot.data['articles'][index]['content'],
                                    uri: snapshot.data['articles'][index]['url'],
                                  ),
                                ),
                                child: NewsCard(
                                  networkImage: snapshot.data['articles'][index]['urlToImage'] ?? fallbackUrl,
                                  title: snapshot.data['articles'][index]['title'] ?? "N/A",
                                  author: snapshot.data['articles'][index]['author'] ?? "N/A",
                                  date: snapshot.data['articles'][index]['publishedAt'] ?? "N/A",
                                ),
                              );
                            },
                          ),
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
