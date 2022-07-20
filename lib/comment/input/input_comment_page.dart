import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp_mention/comment/mention/mention_controller.dart';
import 'package:gp_mention/comment_example.dart';
import 'package:gp_mention/theme/colors.dart';
import 'package:gp_mention/theme/text_theme.dart';
import 'package:gp_mention/widgets/section.dart';

import 'controller.dart';

class TaskInputCommentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CommentExampleController());
    Get.lazyPut(() => InputCommentController());
    Get.lazyPut(() => MentionController());
  }
}

class TaskInputCommentPage extends GetView<InputCommentController> {
  const TaskInputCommentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      child: SafeArea(
        bottom: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // view sửa comment
            // Obx(() => controller.isEdittingComment
            //     ? const EditCommentWidget()
            //     : const SizedBox.shrink()),
            // // view khi chọn/sửa media
            // Obx(() => controller.isChoosingMedias
            //     ? const EditCommentMediasWidget()
            //     : const SizedBox.shrink()),
            Section(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: GPColor.bgTertiary,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          SizedBox(width: 12),
                          Expanded(child: _InputComment()),
                          SizedBox(width: 9),
                          SizedBox(width: 18),
                          // InkWell(
                          //   onTap: controller.onEmojiTapped,
                          //   child: const SvgWidget(
                          //     "assets/images/ic24-line15-face-smile.png",
                          //     color: GPColor.contentSecondary,
                          //   ),
                          // ).paddingOnly(bottom: 12),
                          SizedBox(width: 9),
                        ],
                      ),
                    ),
                  ),
                  Obx(
                    () => InkWell(
                      onTap: controller.sendComment,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 0, 12),
                        child: Icon(
                          Icons.send,
                          color: controller.hasComment
                              ? GPColor.functionAccentWorkPrimary
                              : GPColor.contentTertiary,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputComment extends GetView<InputCommentController> {
  const _InputComment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle? hintTextStyle = textStyle(GPTypography.bodyMedium);

    return ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 24, maxHeight: 120),
        child: TextField(
          controller: controller.textEditingController,
          focusNode: controller.focusNode,
          showCursor: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Comment here",
            hintStyle: hintTextStyle?.copyWith(
              color: GPColor.contentTertiary,
            ),
          ),
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
          maxLines: null,
          style: hintTextStyle,
        ));
  }
}
