import 'package:demo10/constant/base_constants.dart';
import 'package:demo10/pages/social/timeline_detail_vm.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:demo10/pages/social/timeline_vm.dart';
import 'package:demo10/repository/api.dart';

class TimelinePageIntered extends StatefulWidget {
  final int timelindId;

  const TimelinePageIntered({required this.timelindId, super.key});

  @override
  State<TimelinePageIntered> createState() => _TimelinePageIntered();
}

class _TimelinePageIntered extends State<TimelinePageIntered> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Timeline Detail")),
      body: Consumer<TimelineViewModel>(
        builder: (context, vm, child) {
          if (vm.timelinePostsMap[widget.timelindId] == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final post = vm.timelinePostsMap[widget.timelindId]!;
          final hasLikedByMe = vm.heartColorChange[widget.timelindId]!;
          //根据点赞数排序后的postId:<imageprovider:likeCount>map
          final sortedAvatars = vm.userLikeMap[widget.timelindId]!.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

          return Column(
            children: [
              /// 上半部分：帖子内容 + 评论
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 帖子内容与 TimelinePage 单个 Card 一致
                      Card(
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  /// 用户名
                                  Text(
                                    post.userName,
                                    style: const TextStyle(fontSize: 16),
                                  ),

                                  /// 创建时间
                                  Text(
                                    DateFormat(
                                      'yyyy-MM-dd HH:mm',
                                    ).format(post.createdAt),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),

                              /// 图片
                              if (post.imgUrls.isNotEmpty)
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: post.imgUrls.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 6,
                                        mainAxisSpacing: 6,
                                      ),
                                  itemBuilder: (_, i) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        post.imgUrls[i],
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  },
                                ),

                              const SizedBox(height: 8),

                              /// 点赞
                              Align(
                                alignment: Alignment.centerRight,
                                child: Column(
                                  children: [
                                    Text(
                                      (vm.heartLikeCount[widget.timelindId] ??
                                              0)
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.red,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        hasLikedByMe
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: hasLikedByMe
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                      onPressed: () {
                                        vm.likeHit(post.timelineId);
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              /// 点赞头像
                              if (vm.userLikeMap?.isNotEmpty == true) ...[
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
                                              (vm.userAvatarMap[userId] !=
                                                      null &&
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
                              ],
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// ===== 评论区 =====
                      const Text(
                        "comment",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      if (post.comments.isEmpty)
                        const Text(
                          "no comment",
                          style: TextStyle(color: Colors.grey),
                        )
                      else
                        Column(
                          children: post.comments.map((c) {
                            final avatarUrl = vm.userAvatarMap[c.userId];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        (vm.userAvatarMap[c.userId] != null &&
                                            vm
                                                .userAvatarMap[c.userId]!
                                                .isNotEmpty)
                                        ? NetworkImage(
                                            vm.userAvatarMap[c.userId]!,
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
                                          c.comment,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          DateFormat(
                                            'yyyy-MM-dd HH:mm',
                                          ).format(c.createdAt),
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
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ),

              /// ===== 底部评论输入 =====
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: const InputDecoration(
                            hintText: "write your comment...",
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () async {
                          final text = _commentController.text.trim();
                          if (text.isEmpty) return;
                          await Api.instance.postComment(post.timelineId, text);
                          _commentController.clear();
                          await vm.load(20, null);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
