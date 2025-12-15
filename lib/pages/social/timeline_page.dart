import 'package:demo10/manager/LoginSuccessManager.dart';
import 'package:demo10/pages/social/store/timeline_vm.dart';
import 'package:demo10/pages/social/timelinePublish_page.dart';
import 'package:demo10/repository/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimelinePage extends StatefulWidget {
  @override
  State<TimelinePage> createState() => _TimelinePage();
}

class _TimelinePage extends State<TimelinePage> {
  // 模拟帖子
  List<String> posts = [];

  //vm
  TimelineViewModel timelineViewModel = new TimelineViewModel();

  // key: post index, value: like count of CURRENT USER
  Map<int, int> likeCount = {};

  final String userAvatar = "https://i.pravatar.cc/150?img=3"; // 模拟当前用户头像

  //点赞
  void hitLike() {}

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final vm = TimelineViewModel();
        vm.load();
        return vm;
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Timeline")),
        //发帖按钮
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            // 跳转到发帖页面
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TimelinePublishPage()),
            );
          },
        ),
        body: Consumer<TimelineViewModel>(
          builder: (context, vm, child) {
            final posts = vm.timelinePosts;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                int currentLikes = likeCount[index] ?? 0;

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 发帖人名字
                        Text(
                          posts[index].userName,
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 12),

                        /// 帖子内容
                        Text(
                          posts[index].context,
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 12),

                        /// 图片区域
                        if (posts[index].imgUrls.isNotEmpty)
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: posts[index].imgUrls.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 6,
                                  mainAxisSpacing: 6,
                                ),
                            itemBuilder: (context, i) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  posts[index].imgUrls[i],
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),

                        /// 右下角爱心按钮
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(
                              Icons.favorite_border,
                              color: Colors.red,
                              size: 28,
                            ),
                            onPressed: () {
                              setState(() {
                                likeCount[index] = (likeCount[index] ?? 0) + 1;
                              });
                            },
                          ),
                        ),

                        /// 如果有点赞才显示头像 + 次数区域
                        if (currentLikes > 0) ...[
                          Divider(),
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundImage:
                                    LoginSuccessManager.instance.avatarImage!,
                              ),
                              SizedBox(width: 6),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "$currentLikes",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
