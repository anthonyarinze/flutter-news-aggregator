import 'package:flutter/material.dart';

class MajorHeadlines extends StatelessWidget {
  final dynamic images;
  final dynamic index;
  final dynamic active;
  const MajorHeadlines({super.key, this.images, this.index, this.active});

  @override
  Widget build(BuildContext context) {
    double margin = active ? 10 : 20;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      margin: EdgeInsets.all(margin),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: images[index],
        ),
      ),
    );
  }
}
