import 'package:demo10/constant/base_constants.dart';
import 'package:demo10/pages/auth/user_profile_vm.dart';
import 'package:demo10/pages/friend/friend_vm.dart';
import 'package:demo10/pages/social/timeline_vm.dart';
import 'package:demo10/pages/social/timeline_detail_page.dart';
import 'package:demo10/pages/social/timeline_publish_page.dart';
import 'package:demo10/repository/api.dart';
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

  @override
  void initState() {
    //context.read<TimelineViewModel>().load(200, null);
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
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if (notification is ScrollEndNotification) {
                final metrics = notification.metrics;
                if (metrics.pixels >= metrics.maxScrollExtent - 50) {
                  vm.loadMore();
                }
              }
              return false;
            },
            child: RefreshIndicator(
              onRefresh: () async {
                await vm.load(10, null, null);
              },
              child: posts.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 200),
                        Center(
                          child: Text(
                            'No timeline',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        if (index == posts.length) {
                          return vm.hasMore
                              ? const SizedBox(height: 60)
                              : const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                    child: Text(
                                      "no more timeline",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                );
                        }
                        bool hasLikedByme = false;
                        int timelineId = posts[index].timelineId;
                        //根据点赞数排序后的postId:<imageprovider:likeCount>map
                        final sortedAvatars =
                            vm.userLikeMap[timelineId]!.entries.toList()
                              ..sort((a, b) => b.value.compareTo(a.value));
                        if (vm.heartColorChange.containsKey(timelineId) &&
                            vm.heartColorChange[timelineId] == true) {
                          hasLikedByme = true;
                        }
                        final lastCommentUserId =
                            posts[index].comments.isNotEmpty
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
                            margin: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// 发帖人名字
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        posts[index].userName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        DateFormat('yyyy-MM-dd HH:mm').format(
                                          posts[index].createdAt.toLocal(),
                                        ),
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
                                    posts[index].context,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 12),

                                  /// 图片区域
                                  if (posts[index].imgUrls.isNotEmpty)
                                    GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: posts[index].imgUrls.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 6,
                                            mainAxisSpacing: 6,
                                          ),
                                      itemBuilder: (context, i) {
                                        return ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                                        (vm.heartLikeCount[timelineId] ?? 0)
                                            .toString(),
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
                                            vm.likeHit(posts[index].timelineId);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),

                                  /// 如果有点赞才显示头像 + 次数区域
                                  if (vm.userLikeMap.length > 0) ...[
                                    const Divider(),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: sortedAvatars.map((entry) {
                                        final userId = entry.key;
                                        final likeCount = entry.value;
                                        final avatarUrl =
                                            vm.userAvatarMap[userId];
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CircleAvatar(
                                              radius: 16,
                                              backgroundImage: NetworkImage(
                                                (avatarUrl != null &&
                                                        avatarUrl.isNotEmpty)
                                                    ? avatarUrl
                                                    : BaseConstants
                                                          .DefaultAvatarurl,
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
                                  if (posts[index].comments.isNotEmpty &&
                                      lastCommentUserId != null) ...[
                                    const Divider(),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                  BaseConstants
                                                      .DefaultAvatarurl,
                                                ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                posts[index]
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
                                                DateFormat(
                                                  'yyyy-MM-dd HH:mm',
                                                ).format(
                                                  posts[index]
                                                      .comments
                                                      .last
                                                      .createdAt
                                                      .toLocal(),
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
            ),
          );
        },
      ),
    );
  }
}
