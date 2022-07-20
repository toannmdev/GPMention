import 'package:gp_mention/comment/model/comment.dart';

mixin CommentFunction {
  void viewMedia(Comment comment) {}

  void onCommentTap(Comment comment, {bool isClickFromMedia = false}) async {}

  void onReplyCommentTap(Comment comment) {}
}
