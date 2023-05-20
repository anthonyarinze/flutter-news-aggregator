import 'package:flutter/material.dart';
import 'package:news_aggregator/components/headlines_card.dart';
import 'package:news_aggregator/components/news_card.dart';
import 'package:news_aggregator/provider/theme_provider.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
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
              const Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0, bottom: 10.0),
                  child: Text(
                    "Major headlines",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: PageView.builder(
                      itemCount: imgList.length,
                      pageSnapping: true,
                      controller: _pageController,
                      onPageChanged: (page) {
                        setState(() {
                          activePage = page;
                        });
                      },
                      itemBuilder: (context, index) {
                        bool active = index == activePage;
                        return MajorHeadlines(
                          images: AssetImage(imgList.first),
                          index: index,
                          active: active,
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: indicators(imgList.length, activePage),
                  ),
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
                  const NewsCard(),
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
