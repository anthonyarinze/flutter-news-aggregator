import 'package:flutter/material.dart';
import 'package:news_aggregator/pages/home_page.dart';
import 'package:news_aggregator/provider/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'News Aggregator',
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(useMaterial3: true),
            darkTheme: ThemeData.dark(),
            themeMode: themeProvider.currentTheme,
            home: const Scaffold(
              body: HomePage(),
            ),
          );
        },
      ),
    );
  }
}
