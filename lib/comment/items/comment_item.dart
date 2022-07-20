import 'package:flutter/material.dart';
import 'package:gp_mention/comment/model/comment.dart';

import 'comment_item_type_text.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({
    Key? key,
    required this.comment,
    this.preComment,
  }) : super(key: key);

  final Comment comment;
  final Comment? preComment; // comment ở vị trí index - 1

  bool get showTopIndicator =>
      preComment != null && !preComment!.isTypeActivityLogs;

  @override
  Widget build(BuildContext context) {
    return CommentItemTypeText(comment: comment);
  }
}
