import 'dart:io';
import 'package:demo10/constant/base_constants.dart';
import 'package:demo10/pages/social/timeline_vm.dart';
import 'package:demo10/repository/api.dart';
import 'package:demo10/utils/sp_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class TimelinePublishPage extends StatefulWidget {
  @override
  State<TimelinePublishPage> createState() => _TimelinePublishPage();
}

class _TimelinePublishPage extends State<TimelinePublishPage> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool _posting = false;
  List<XFile> _images = []; // 选中的图片文件

  // 选择多张图片
  Future<void> pickImages() async {
    final List<XFile> imgs = await _picker.pickMultiImage();
    if (imgs.isNotEmpty) {
      setState(() {
        _images.addAll(imgs);
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text("Create Post")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// 输入框
            TextField(
              controller: _controller,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: "Write something...",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 16),

            /// 图片预览
            _images.isNotEmpty
                ? SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _images.length,
                      itemBuilder: (_, index) {
                        return Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Image.file(
                                File(_images[index].path),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),

                            /// 删除按钮
                            Positioned(
                              right: 5,
                              top: 5,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _images.removeAt(index);
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.black54,
                                  child: Icon(
                                    Icons.close,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                : Container(),

            SizedBox(height: 16),

            /// 选择图片按钮
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: pickImages,
                  icon: Icon(Icons.image),
                  label: Text("Add Images"),
                ),
              ],
            ),

            SizedBox(height: 16),

            /// 发布按钮
            /// 发布按钮
            ElevatedButton(
              onPressed: _posting
                  ? null
                  : () async {
                      setState(() {
                        _posting = true;
                      });

                      try {
                        int? id = await SpUtils.getInt(
                          BaseConstants.SP_User_Id,
                        );
                        await Api.instance.postTimeline(
                          id,
                          _controller.text,
                          _images,
                          DateTime.now().toString(),
                        );
                        await context.read<TimelineViewModel>().load(
                          20,
                          null,
                          null,
                        );

                        if (mounted) {
                          Navigator.pop(context, true);
                        }
                      } finally {
                        if (mounted) {
                          setState(() {
                            _posting = false;
                          });
                        }
                      }
                    },
              child: _posting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text("Post"),
            ),
          ],
        ),
      ),
    );
  }
}
