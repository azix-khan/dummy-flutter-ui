import 'package:flutter/material.dart';

class PagesBody extends StatelessWidget {
  final Widget? widget;
  final String? title;
  final String? content;

  const PagesBody({Key? key, this.widget, this.title, this.content})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // big container with image
        Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(40),
          color: Colors.white60,
          // color: Colors.cyan[900],
          child: widget,
        ),
        // small container with title and content
        Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                title!,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  // color: Colors.grey[400],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                content!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black38,
                  // color: Colors.grey[400],
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
