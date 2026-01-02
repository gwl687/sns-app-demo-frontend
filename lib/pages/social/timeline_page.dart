import 'package:demo10/constant/base_constants.dart';
import 'package:demo10/pages/social/timeline_vm.dart';
import 'package:demo10/pages/social/timeline_detail_page.dart';
import 'package:demo10/pages/social/timeline_publish_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
          final postMap = vm.timelinePostsMap;
          return RefreshIndicator(
            onRefresh: () async {
              await vm.load(20, null);
            },
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                bool hasLikedByme = false;
                int timelineId = posts[index].timelineId;
                //根据点赞数排序后的postId:<imageprovider:likeCount>map
                final sortedAvatars = vm.avatars[timelineId]!.entries.toList()
                  ..sort((a, b) => b.value.compareTo(a.value));
                if (vm.heartColorChange.containsKey(timelineId) &&
                    vm.heartColorChange[timelineId] == true) {
                  hasLikedByme = true;
                }
                final lastCommentUserId = posts[index].comments.isNotEmpty
                    ? posts[index].comments.last.userId
                    : null;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            TimelinePageIntered(timelindId: timelineId),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                posts[index].userName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                DateFormat(
                                  'yyyy-MM-dd HH:mm',
                                ).format(posts[index].createdAt),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          /// 帖子内容
                          Text(
                            postMap[timelineId]!.context,
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 12),

                          /// 图片区域
                          if (postMap[timelineId]!.imgUrls.isNotEmpty)
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: postMap[timelineId]!.imgUrls.length,
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
                                    postMap[timelineId]!.imgUrls[i],
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
                                (vm.heartLikeCount[timelineId] ?? 0).toString(),
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
                                    vm.likeHit(postMap[timelineId]!.timelineId);
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
                                              BaseConstants.DefaultAvatarurl,
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
                              "TOTALLIKES: ${vm.totalLikeCount[timelineId] ?? 0}",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                          ],

                          /// 如果有评论，显示最新一条
                          if (postMap[timelineId]!.comments.isNotEmpty &&
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
                                          BaseConstants.DefaultAvatarurl,
                                        ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        postMap[timelineId]!
                                            .comments
                                            .last
                                            .comment,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        DateFormat('yyyy-MM-dd HH:mm').format(
                                          postMap[timelineId]!
                                              .comments
                                              .last
                                              .createdAt,
                                        ),
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
