import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:demo10/pages/social/timelinePublish_page.dart';

class TimelinePage extends StatefulWidget {
  @override
  State<TimelinePage> createState() => _TimelinePage();
}

class _TimelinePage extends State<TimelinePage> {
  List<String> posts = [
    "First post!",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Timeline")),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(posts[index]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => TimelinePublishPage()),
          );
          if (result != null && result is String && result.isNotEmpty) {
            setState(() {
              posts.insert(0, result);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
