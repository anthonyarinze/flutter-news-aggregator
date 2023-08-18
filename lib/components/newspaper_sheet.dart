import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

class NewsPaperSheet extends StatelessWidget {
  const NewsPaperSheet({
    super.key,
    required this.isDarkMode,
    required this.title,
    required this.publishedAt,
    required this.author,
    required this.publisher,
    required this.content,
    required this.uri,
  });

  final bool isDarkMode;
  final String title;
  final String publishedAt;
  final String author;
  final String publisher;
  final String content;
  final String uri;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.48,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              softWrap: true,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                'Published on ${publishedAt.substring(0, 10)}',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white54,
                    child: Icon(Icons.create_outlined, color: isDarkMode ? Colors.white : Colors.black),
                  ),
                  const SizedBox(width: 10.0),
                  Text(
                    author.length > 10 ? '${author.substring(0, 10)}...' : author,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    ' ~ $publisher',
                    style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Text(
              "${content.substring(0, 100)}...",
              maxLines: 1500,
              softWrap: true,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Link(
                uri: Uri.parse(uri),
                target: LinkTarget.self,
                builder: (context, followLink) => ElevatedButton.icon(
                  onPressed: followLink,
                  icon: const Icon(Icons.web_outlined, color: Colors.white),
                  label: const Text(
                    'Read more',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(color: Colors.blue),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
