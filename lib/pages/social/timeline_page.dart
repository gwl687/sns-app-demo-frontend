import 'package:demo10/constants.dart';
import 'package:demo10/pages/social/store/timeline_vm.dart';
import 'package:demo10/pages/social/timelineIntered_page.dart';
import 'package:demo10/pages/social/timelinePublish_page.dart';
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

  // 点赞总次数
  Map<int, int> totalLikeCount = {};

  final String userAvatar = "https://i.pravatar.cc/150?img=3"; // 模拟当前用户头像

  @override
  void initState() {
    super.initState();
    //final vm = context.read<TimelineViewModel>();
    //context.read<TimelineViewModel>();
    //vm.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          return RefreshIndicator(
            onRefresh: () async {
              await vm.load();
            },
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                bool hasLikedByme = false;
                //根据点赞数排序后的postId:<imageprovider:likeCount>map
                final sortedAvatars = vm.avatars[index]!.entries.toList()
                  ..sort((a, b) => b.value.compareTo(a.value));
                if (vm.heartColorChange.containsKey(index) &&
                    vm.heartColorChange[index] == true) {
                  hasLikedByme = true;
                }
                final lastCommentUserId =
                    posts[index].comments?.isNotEmpty == true
                    ? posts[index].comments!.last.userId
                    : null;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TimelinePageIntered(postIndex: index),
                      ),
                    );
                  },
                  child: Card(
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              /// 爱心上面的次数
                              Text(
                                (vm.heartLikeCount[index] ?? 0).toString(),
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(height: 12),

                              ///爱心
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon: Icon(
                                    hasLikedByme
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: hasLikedByme
                                        ? Colors.red
                                        : Colors.grey,
                                    size: 28,
                                  ),
                                  onPressed: () {
                                    vm.likeHit(index, posts[index].timelineId);
                                  },
                                ),
                              ),
                            ],
                          ),

                          /// 如果有点赞才显示头像 + 次数区域
                          if (vm.avatars.length > 0) ...[
                            const Divider(),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: sortedAvatars.map((entry) {
                                final userId = entry.key;
                                final likeCount = entry.value;
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundImage:
                                          (vm.userAvatarMap[userId] != null &&
                                              vm
                                                  .userAvatarMap[userId]!
                                                  .isNotEmpty)
                                          ? NetworkImage(
                                              vm.userAvatarMap[userId]!,
                                            )
                                          : NetworkImage(
                                              Constants.DefaultAvatarurl,
                                            ),
                                    ),

                                    const SizedBox(height: 4),
                                    Text(
                                      likeCount.toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),

                            const SizedBox(height: 6),
                            //总点赞数
                            Text(
                              "TOTALLIKES: ${vm.totalLikeCount[index] ?? 0}",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                          ],

                          /// 如果有评论，显示最新一条
                          if (posts[index].comments.isNotEmpty &&
                              lastCommentUserId != null) ...[
                            const Divider(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      (vm.userAvatarMap[lastCommentUserId] !=
                                              null &&
                                          vm
                                              .userAvatarMap[lastCommentUserId]!
                                              .isNotEmpty)
                                      ? NetworkImage(
                                          vm.userAvatarMap[lastCommentUserId]!,
                                        )
                                      : NetworkImage(
                                          Constants.DefaultAvatarurl,
                                        ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        posts[index].comments.last.comment,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        posts[index].comments.last.createdAt
                                            .toString(),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
