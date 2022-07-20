import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp_mention/comment/input/input_comment_page.dart';
import 'package:gp_mention/comment/items/comment_item.dart';
import 'package:gp_mention/comment/mention/mention_view.dart';
import 'package:gp_mention/comment/model/comment.dart';
import 'package:gp_mention/theme/colors.dart';

class CommentExamplePage extends GetView<CommentExampleController> {
  const CommentExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: GPColor.bgPrimary,
      appBar: AppBar(title: const Text("RTF")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Expanded(
              child: Obx(() => ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if (controller.comments.isNotEmpty) {
                        return CommentItem(
                          comment: controller.comments[index],
                          // preComment: index - 2 > 0
                          //     ? controller.comments[index - 2]
                          //     : null,
                        )
                            .paddingSymmetric(horizontal: 16)
                            .paddingOnly(bottom: 8);
                      } else {
                        return const SizedBox();
                      }
                    },
                    itemCount: controller.comments.length,
                  ))),
          const MentionOverlay(),
          const TaskInputCommentPage()
        ],
      ),
    );
  }
}

class CommentExampleController extends GetxController {
  RxList<Comment> comments = RxList();

  void addComment(Comment comment) {
    comments.add(comment);
  }
}
