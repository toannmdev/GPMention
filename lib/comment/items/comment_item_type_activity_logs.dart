import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gp_mention/comment/model/comment.dart';

class CommentItemTypeActivityLogs extends StatelessWidget {
  const CommentItemTypeActivityLogs({
    required this.comment,
    required this.showTopIndicator,
    Key? key,
  }) : super(key: key);

  final Comment comment;
  final bool showTopIndicator;

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
