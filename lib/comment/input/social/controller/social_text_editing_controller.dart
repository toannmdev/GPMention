import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gp_mention/comment/input/social/util/social_span.dart';
import 'package:gp_mention/comment/model/comment.dart';
import 'package:gp_mention/model/assignee.dart';

class SocialTextEditingController extends TextEditingController {
  final List<Mentions> mentions = [];

  // khi tap chọn user, không cần update lại mention
  String addedMentionId = "";
  String addedMentionDisplayName = "";
  // text hiển thị trước khi reRender lại spans, dùng để cập nhật lại vị trí mention
  String oldText = "";

  void replaceRange(
    String newValue,
    TextRange range, {
    Assignee? assignee,
  }) {
    var willAddSpaceAtEnd = true;
    // (text.length - 1) <= (range.start + newValue.length) &&
    //     mentions.isEmpty;
    var replacingText = "$newValue${willAddSpaceAtEnd ? " " : ""}";
    var replacedText =
        text.replaceRange(range.start, range.end, replacingText); // + 1
    var newCursorPosition =
        range.start + replacingText.length + (willAddSpaceAtEnd ? 0 : 1);

    // if(newCursorPosition == replacedText.length){
    //   newCursorPosition -= 1;
    // }

    // if (newCursorPosition >= replacedText.length) {
    //   newCursorPosition = replacedText.length - (willAddSpaceAtEnd ? 0 : 1);
    // }

    if (assignee != null) {
      addedMentionId = "${assignee.id}";
      addedMentionDisplayName = assignee.displayName;
      mentions.add(Mentions(
        offset: range.start,
        length: range.start + assignee.displayName.length,
        mentionId: "${assignee.id}",
      )..displayName = assignee.displayName);
    }

    value = value.copyWith(
        text: replacedText,
        selection: value.selection.copyWith(
            baseOffset: newCursorPosition, extentOffset: newCursorPosition),
        composing: value.composing);
  }

  void moveCursorToEnd() {
    value = value.copyWith(
        selection: value.selection
            .copyWith(baseOffset: text.length, extentOffset: text.length),
        composing: value.composing);
  }

  bool needToShowMention() {
    int cursorPos = selection.baseOffset;
    for (var mention in mentions) {
      if (mention.offset == cursorPos ||
          cursorPos ==
              (mention.offset - SocialSpan.socialDetectPrefix.length) ||
          cursorPos ==
              (mention.offset + SocialSpan.socialDetectPrefix.length)) {
        return false;
      }
    }

    return true;
  }

  void handleOnTextChanged(OnMentionDectect onMentionDectect) {
    final cursorPos = selection.baseOffset;

    if (cursorPos >= 0) {
      var _pos = 0;

      final lengthMap = <LengthMap>[];
      value.text.split(RegExp(r'(\s)')).forEach((element) {
        lengthMap.add(
            LengthMap(str: element, start: _pos, end: _pos + element.length));

        _pos = _pos + element.length + 1;
      });

      /*
        Hiển thị list danh sách mentions khi:
        1. Có [SocialSpan.socialDetectPrefix] ở đầu
        2. Có từ 2 kí tự trở lên
        3. Cursor của input ở cuối
        4. Không tính khoảng trắng
      */
      final val = lengthMap.indexWhere((element) {
        return element.str.length >= 2 &&
            element.end == cursorPos &&
            element.str.startsWith(SocialSpan.socialDetectPrefix) &&
            element.str.toLowerCase().contains(SocialSpan.socialDetectPrefix);
      });

      onMentionDectect.call(val != -1 ? lengthMap[val] : null);
    }
  }

  @override
  void clear() {
    mentions.clear();
    super.clear();
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    TextSpan spans = SocialSpan(
      onUpdateText: _onUpdate,
    ).build(
      mentions,
      text,
      oldText: oldText,
      addedMentionId: addedMentionId,
      addedMentionDisplayName: addedMentionDisplayName,
    );
    // cập nhật lại giá trị, sau khi build lên UI
    oldText = text;
    addedMentionId = "";
    addedMentionDisplayName = "";

    return spans;
  }

  void _onUpdate(String newText, int cursorPos) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      /// TODO(techdebt): chưa nghĩ ra giải pháp gì hay ho hơn
      /// hiện tại sẽ update lại text, nhưng chưa kịp update lại cursor thì, textSpan đã được rebuild,
      /// dẫn tới việc bị warning assert tại line 2487 editable_text.dart
      /// ```assert(!composingRange.isValid || composingRange.isCollapsed);```

      text = newText;
      value = value.copyWith(
          text: newText,
          // đặt lại vị trí cursor, vị trí cuối cùng user tương tác
          selection:
              TextSelection.fromPosition(TextPosition(offset: cursorPos)),
          composing: value.composing);
    });
  }
}

typedef OnMentionDectect = Function(LengthMap?);

class LengthMap {
  LengthMap({
    required this.start,
    required this.end,
    required this.str,
  });

  String str;
  int start;
  int end;
}
