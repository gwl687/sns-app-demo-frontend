import 'package:demo10/repository/api.dart';
import 'package:demo10/constants.dart';
import 'package:demo10/utils/sp_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimelinePublishPage extends StatefulWidget {
  @override
  State<TimelinePublishPage> createState() => _TimelinePublishPage();
}

class _TimelinePublishPage extends State<TimelinePublishPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Post")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: "Write something...",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                int? id = await SpUtils.getInt(Constants.SP_User_Id);
                List<String> imgUrls = [];
                //推送给粉丝
                Api.instance.postTimeline(id, _controller.text, imgUrls);
                Navigator.pop(context, _controller.text);
              },
              child: Text("Post"),
            ),
          ],
        ),
      ),
    );
  }
}
