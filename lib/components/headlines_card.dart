import 'package:flutter/material.dart';

class MajorHeadlines extends StatelessWidget {
  final ImageProvider images;
  final int index;
  final bool active;
  const MajorHeadlines({
    super.key,
    required this.images,
    required this.index,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double margin = active ? 10 : 20;
    return AnimatedContainer(
      width: size.width / 1.2,
      height: size.height / 3.5,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      margin: EdgeInsets.all(margin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: images,
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.black.withOpacity(0.5),
        ),
        child: const Center(
          child: Text(
            'Your Text Here',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
