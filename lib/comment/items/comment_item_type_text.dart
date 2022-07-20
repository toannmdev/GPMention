import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:gp_mention/comment/model/comment.dart';
import 'package:gp_mention/network/gp_network_image.dart';
import 'package:gp_mention/theme/colors.dart';
import 'package:gp_mention/theme/text_theme.dart';
import 'package:gp_mention/utils/utils.dart';
import 'package:gp_mention/widgets/default_avatar.dart';

import '../input/social/util/social_span.dart';
import 'comment_item_function.dart';

const defaultUserName = "Nguyễn Mạnh Toàn";

class CommentItemTypeText extends StatelessWidget with CommentFunction {
  const CommentItemTypeText({Key? key, required this.comment})
      : super(key: key);

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
          child: GPNetworkImage(
              width: 32,
              height: 32,
              fit: BoxFit.cover,
              url: Utils.imageThumb(
                  comment.user?.avatarThumbPattern ?? '', "${96}x${96}"),
              placeholder: DefaultAvatar(
                  userName: comment.user?.displayName ?? defaultUserName,
                  size: 32)),
        ),
        const SizedBox(width: 8),
        _CommentContentView(comment: comment),
        const SizedBox(width: 8),
      ],
    ).paddingSymmetric(vertical: 2);
  }
}

class _CommentContentView extends StatelessWidget with CommentFunction {
  const _CommentContentView({Key? key, required this.comment})
      : super(key: key);

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    const bool isUploadingOrHasError = false; // comment.isUploadingOrError;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onLongPress: () => onCommentTap(comment),
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                    color: GPColor.bgSecondary,
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(comment.user?.displayName ?? defaultUserName,
                        style: textStyle(GPTypography.bodySmallBold)
                            ?.mergeColor(isUploadingOrHasError
                                ? GPColor.contentSecondary
                                : GPColor.contentPrimary)),
                    if (comment.hasText)
                      Opacity(
                        opacity: isUploadingOrHasError ? 0.35 : 1.0,
                        child: RichText(
                          text: SocialSpan(
                            onMentionTap: _onUserTap,
                            onLinkTap: _onLinkTap,
                            onPhoneTap: _onPhoneTap,
                            onEmailTap: _onEmailTap,
                          ).build(comment.mentions ?? [], comment.text ?? ""),
                        ),
                      ),
                  ],
                )),
          ),
          Wrap(alignment: WrapAlignment.start, spacing: 0, children: [
            // comment.isEdited
            //     ? const SvgWidget(
            //         'assets/images/ic24-line15-clock-arrow-rotateleft.png',
            //         width: 12,
            //         height: 12,
            //         color: GPColor.contentSecondary,
            //       ).paddingOnly(top: 3, right: 8, left: 12)
            //     : const SizedBox(width: 12),
            Text(comment.updatedAtDisplay,
                    style: textStyle(GPTypography.bodySmall)
                        ?.mergeColor(GPColor.contentSecondary))
                .marginOnly(right: 8),
            InkWell(
              onTap: () => onReplyCommentTap(comment),
              child:
                  Text("Reply", style: textStyle(GPTypography.bodySmallBold)),
            ),
          ]).marginAll(4),
        ],
      ),
    );
  }

  void _onUserTap(String userId) => {
        //Deeplink.openUser(userId)
      };

  void _onLinkTap(String url) async {}

  void _onEmailTap(String email) async {}

  void _onPhoneTap(String phone) async {}
}
