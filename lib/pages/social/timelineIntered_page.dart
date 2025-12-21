import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:demo10/pages/social/store/timeline_vm.dart';
import 'package:demo10/repository/api.dart';
import 'package:demo10/constants.dart';

class TimelinePageIntered extends StatefulWidget {
  final int postIndex;

  const TimelinePageIntered({required this.postIndex, super.key});

  @override
  State<TimelinePageIntered> createState() => _TimelinePageIntered();
}

class _TimelinePageIntered extends State<TimelinePageIntered> {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Timeline Detail")),
      body: Consumer<TimelineViewModel>(
        builder: (context, vm, child) {
          final post = vm.timelinePosts[widget.postIndex];
          final index = widget.postIndex;
          final hasLikedByMe = vm.heartColorChange[index] == true;

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
                              /// 用户名
                              Text(
                                post.userName,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 12),

                              /// 内容
                              Text(
                                post.context,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 12),

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
                                      (vm.heartLikeCount[index] ?? 0)
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
                                        vm.likeHit(index, post.timelineId);
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              /// 点赞头像
                              if (vm.avatars[index]?.isNotEmpty == true) ...[
                                const Divider(),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: vm.avatars[index]!.entries.map((e) {
                                    final userId = e.key;
                                    return CircleAvatar(
                                      radius: 14,
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
                        "评论",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      if (post.comments.isEmpty)
                        const Text("暂无评论", style: TextStyle(color: Colors.grey))
                      else
                        Column(
                          children: post.comments.map((c) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CircleAvatar(radius: 14),
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
                                          c.createdAt.toString(),
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
                            hintText: "写评论...",
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
                          await vm.load();
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
