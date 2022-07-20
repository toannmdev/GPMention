import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:gp_mention/comment/input/social/util/social_span.dart';
import 'package:gp_mention/comment/mention/mention_controller.dart';
import 'package:gp_mention/comment/model/comment.dart';
import 'package:gp_mention/comment_example.dart';
import 'package:gp_mention/model/assignee.dart';

import 'social/social.dart';
import 'vars.dart';

enum CreateCommentMode {
  create,
  edit,
  reply,
}

class InputCommentController extends GetxController
    with InputCommentVars, GetSingleTickerProviderStateMixin {
  /// hiển thị mentionList hay không, trigger khi regex match [SocialSpan.socialDetectPrefix]
  RxBool showMentionList = false.obs;

  /// mention hiển thị dạng overlay,
  /// [overLayBottom] là khoảng cách từ ô input comment + keyboard tới mention list
  RxDouble overLayBottom = 0.0.obs;

  RxString commentStr = "".obs;
  RxString commentStrSplitted = "".obs;
  // has text or image... or videos...
  bool get hasComment =>
      (commentStrSplitted.value.isNotEmpty || isChoosingMedias);

  RxBool isKeyboardVisible = false.obs;
  RxBool isEmojiVisible = false.obs;

  // show editComment layout or not
  final RxBool _isEditCommentVisible = false.obs;

  bool get isEdittingComment => _isEditCommentVisible.value;

  // comment for editting;
  late Comment eComment;

  late CreateCommentMode createCommentMode = CreateCommentMode.create;

  late AnimationController animationController;

  /// show editCommentMedia layout or not,
  /// view start listening isChoosingMedias.value after creating [CommentMediasController]
  final RxBool _isEditCommentMediaVisible = false.obs;

  bool isSendingComment = false;

  bool isPickingMedia = false;

  bool get isChoosingMedias => false;

  RxBool hasMedias = false.obs;

  double get overlayMaxHeight => isChoosingMedias ? 150 : 240;

  late StreamSubscription keyboardSubscription;

  final KeyboardVisibilityController keyboardVisibilityController =
      KeyboardVisibilityController();

  @override
  void onInit() {
    textEditingController.addListener(() {
      commentStr.value = textEditingController.text;

      textEditingController.handleOnTextChanged(_onTextChanged);
    });

    commentStr.listen((p0) {
      commentStrSplitted.value = getCommentStr(p0);
    });

    KeyboardVisibilityController().onChange.listen((bool isKeyboardVisible) {
      this.isKeyboardVisible.value = isKeyboardVisible;

      if (isKeyboardVisible && isEmojiVisible.value) {
        isEmojiVisible.value = false;
      }
    });

    focusNode.addListener(() {
      if (!isEmojiVisible.value && keyboardVisibilityController.isVisible) {
        showMentionList.value = focusNode.hasFocus;
      }
    });

    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (!visible) {
        focusNode.unfocus();
        showMentionList.value = false;
      }
    });

    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));

    super.onInit();
  }

  @override
  void dispose() {
    // Get.delete<CommentMediasController>();
    keyboardSubscription.cancel();
    super.dispose();
  }

  Future<void> sendComment({Comment? comment}) async {
    if (!hasComment) return;

    if (!isSendingComment) {
      isSendingComment = true;
      Comment _comment;
      // comment sử dụng cho trường hợp gửi lại comment lỗi trước đó
      if (comment != null) {
        _comment = comment;
      } else {
        _comment = _newCommentLocal(commentStr.value);
      }

      Get.find<CommentExampleController>().addComment(_comment);

      // create or edit comment
      // if (commentStr.value.isNotEmpty || _commentMedias.isNotEmpty) {
      //   switch (createCommentMode) {
      //     case CreateCommentMode.edit:
      //       String? id = eComment.id;
      //       eComment = _comment;
      //       eComment.id = id;
      //       await Get.find<TaskCreateController>().editComment(eComment);

      //       Get.find<TaskCreateController>().comments.remove(_comment);
      //       break;
      //     case CreateCommentMode.create:
      //     case CreateCommentMode.reply:
      //       _comment.updateIfNeeded(_commentTextStr);
      //       Comment? _newComment = await Get.find<TaskCreateController>()
      //           .createNewComment(_comment);
      //       _newComment?.commentMediaLocals = [];
      //       _newComment?.commentMediaLocals
      //           ?.addAll(_comment.commentMediaLocals?.toList() ?? []);

      //       if (_newComment != null) {
      //         if (_hasMedias) {
      //           // nếu cập nhật lại giá trị comment, khi xoá sẽ bị lỗi do widget chưa update lại tham trị
      //           Get.find<TaskCreateController>().comments.remove(_comment);
      //           Get.find<TaskCreateController>().comments.add(_newComment);

      //           _reloadDataAfterCreate();
      //         } else {
      //           Get.find<TaskCreateController>().comments.add(_newComment);
      //         }
      //       }
      //       break;
      //   }

      exitEdittingComment();

      textEditingController.clear();
    }

    isSendingComment = false;
    // KeyboardUtils.dismiss();
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    hideEmojiKeyboard();
    focusNode.unfocus();
  }

  Comment _newCommentLocal(
    String value,
  ) {
    return Comment(
      targetId: "task.id",
      targetType: 'mini-task',
      text: value,
      mentions: textEditingController.mentions.toList(),
      // user: User(
      //   avatar: Constants.avatar() ?? "",
      //   avatarThumbPattern: Constants.avatar() ?? "",
      //   displayName: Constants.displayName(),
      //   fullName: Constants.displayName(),
      //   userId: Constants.userId(),
      // ),
      // commentAs: CommentAs(authorId: Constants.userId(), authorType: 'user'),
      dataSource: 3,
    )
      ..createdAt
      ..updatedAt = DateTime.now().microsecondsSinceEpoch;
  }

  void _reloadDataAfterCreate() async {}

  void editComment(Comment comment) async {}

  void replyComment(Comment comment) {}

  void hideKeyboards() {
    hideEmojiKeyboard();
    focusNode.unfocus();
  }

  void onEmojiTapped() async {
    focusNode.unfocus();
    showMentionList.value = false;
    if (isEmojiVisible.value) {
      isEmojiVisible.value = false;
      await SystemChannels.textInput.invokeMethod('TextInput.show');
      focusNode.requestFocus();
    } else if (isKeyboardVisible.value) {
      isEmojiVisible.value = true;
      await SystemChannels.textInput.invokeMethod('TextInput.hide');
    } else if (!isEmojiVisible.value && !isKeyboardVisible.value) {
      isEmojiVisible.value = true;
    }
  }

  void hideEmojiKeyboard() {
    isEmojiVisible.value = false;
  }

  void hideMentions() {
    FocusManager.instance.primaryFocus?.unfocus();
    showMentionList.value = false;
    focusNode.unfocus();
  }

  void enterEdittingComment() {
    _isEditCommentVisible.value = true;
  }

  void exitEdittingComment() {
    _isEditCommentVisible.value = false;

    showMentionList.value = false;

    createCommentMode = CreateCommentMode.create;
  }

  void onMentionTapped(Assignee assignee) {
    // '@Toàn', tap chọn Nguyễn Mạnh Toàn, hiển thị 'Nguyễn Mạnh Toàn'
    textEditingController.replaceRange(
      assignee.displayName,
      TextRange(start: lastDetection.start, end: lastDetection.end),
      assignee: assignee,
    );
  }

  void _onTextChanged(LengthMap? lengthMap) {
    if (lengthMap != null) {
      lastDetection = lengthMap;
      if (focusNode.hasFocus) {
        showMentionList.value = true;

        Get.find<MentionController>().searchStr.value =
            lengthMap.str.replaceAll(SocialSpan.socialDetectPrefix, "");
      }
    } else {
      showMentionList.value = false;
      Get.find<MentionController>().clear();
    }
  }

  Future _preparedEditting() async {
    focusNode.requestFocus();

    await 300.milliseconds.delay();

    showMentionList.value = false;
  }

  // --------- COMMENT MEDIAS --------- \\
  void clearMedias() {}

  Future pickMedia() async {}
}
