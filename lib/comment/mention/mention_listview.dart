import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp_mention/comment/input/controller.dart';
import 'package:gp_mention/comment/mention/mention_controller.dart';
import 'package:gp_mention/model/assignee.dart';
import 'package:gp_mention/theme/colors.dart';
import 'package:gp_mention/theme/text_theme.dart';
import 'package:gp_mention/utils/utils.dart';
import 'package:gp_mention/widgets/default_avatar.dart';
import 'package:gp_mention/widgets/gp_avatar.dart';

class MentionList extends GetView<MentionController> {
  const MentionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /* 
      --- CHÚ Ý trước khi MAINTANCE ---
      hiện tại có 1 vấn đề, chỉ xảy ra khi sử dụng listView với OverlayContainer:
      Khi listView được render, scroll ko ở vị trí 0.0, chưa nghĩ ra cách xử lý gì hay ho

      => trick tạm thời: xài scrollview + column, về performance cũng ko bị ảnh hưởng quá nhiều,
      nếu dùng listView, có thể suy nghĩ tới phương án auto smooth scroll to top để tăng UX
      nhưng cũng ko cải thiện được quá nhiều trong trường hợp items = 1, 2
    */
    return SingleChildScrollView(
      child: Obx(
        () => Column(
          children: controller.listItem
              .map((assinee) => Column(
                    children: [
                      _MentionItem(assignee: assinee),
                      if (controller.listItem.indexOf(assinee) <
                          (controller.listItem.length - 1))
                        const Divider(
                          indent: 42,
                          height: 0.5,
                          thickness: 0.5,
                          color: GPColor.linePrimary,
                        )
                    ],
                  ))
              .toList(),
        ),
      ),
    );

    // return Obx(() => ListView.separated(
    //     controller: controller.scrollController,
    //     physics: const BouncingScrollPhysics(),
    //     shrinkWrap: true,
    //     cacheExtent: 48,
    //     addAutomaticKeepAlives: false,
    //     addRepaintBoundaries: false,
    //     addSemanticIndexes: false,
    //     itemBuilder: (_, index) =>
    //         _MentionItem(assignee: controller.listItem[index]),
    //     separatorBuilder: (_, index) => const Divider(
    //           indent: 42,
    //           height: 0.5,
    //           thickness: 0.5,
    //           color: GPColor.linePrimary,
    //         ),
    //     itemCount: controller.listItem.length));
  }
}

class _MentionItem extends StatelessWidget {
  final Assignee assignee;

  const _MentionItem({Key? key, required this.assignee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.find<InputCommentController>().onMentionTapped(assignee);
        Get.find<InputCommentController>().showMentionList.value = false;
        Get.find<MentionController>().clear();
      },
      child: Row(
        children: [
          _AssigneeAvatar(
            assignee: assignee,
            size: 32,
          ).paddingSymmetric(vertical: 8),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              assignee.displayName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textStyle(GPTypography.headingSmall),
            ),
          )
        ],
      ),
    );
  }
}

class _AssigneeAvatar extends StatelessWidget {
  final Assignee? assignee;

  final String? avatarThumbPattern;
  final String? displayName;
  final int size;
  final String? customAvatarImagePath;

  const _AssigneeAvatar({
    this.assignee,
    this.avatarThumbPattern,
    this.displayName,
    this.size = 64,
    this.customAvatarImagePath,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Utils.isValidUrl(assignee?.avatarThumbPattern ?? avatarThumbPattern)
        ? GPAvatar(
            radius: size / 2,
            size: size.toDouble(),
            shape: GPAvatarShape.circle,
            backgroundColor: GPColor.bgSecondary,
            backgroundImage: NetworkImage(Utils.imageThumb(
                assignee?.avatarThumbPattern ?? avatarThumbPattern ?? '',
                "${size.toInt() * 3}x${size.toInt() * 3}")),
            boxBorder: Border.all(color: GPColor.border),
          )
        : (customAvatarImagePath == null
            ? DefaultAvatar(
                userName: assignee?.displayName ?? displayName ?? '',
                size: size.toDouble(),
              )
            : Image.asset(
                customAvatarImagePath!,
                width: size.toDouble(),
                height: size.toDouble(),
              ));
  }
}
