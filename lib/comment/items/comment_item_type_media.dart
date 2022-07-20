import 'package:flutter/material.dart';
import 'package:gp_mention/comment/model/comment.dart';

// rule hiện tại, comment media chỉ hiển thị duy nhất 1 image/video
class CommentItemTypeMedia extends StatelessWidget {
  final Comment comment;

  const CommentItemTypeMedia({
    required this.comment,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
