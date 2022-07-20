import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gp_mention/comment/model/comment.dart';
import 'package:gp_mention/theme/colors.dart';
import 'package:gp_mention/theme/text_theme.dart';

import '../social.dart';

import 'package:diff_match_patch/diff_match_patch.dart';

typedef OnUpdateText = void Function(String, int);

typedef OnRegexTap = void Function(String);

class StringDiff {
  const StringDiff(this.diff, this.textRange);

  final Diff diff;
  final TextRange textRange;

  @override
  String toString() {
    return 'StringDiff("${diff.toString()}: ${textRange.start}-${textRange.end}")';
  }
}

/// Spans giúp hiển thị:
/// `mentions`, `hashtag`, `phone`, `email`, `url`, `file`
///
/// Đối với `mentions`, hỗ trợ các tính năng:
/// 1. Xóa mention kèm text còn lại của mention nếu kí tự cuối cùng của mention bị xóa.
/// 2. Xóa mention nếu user thêm/sửa kí tự trong khoảng text chứa mention (không xóa phần text còn lại).
/// 3. Đổi màu mention nếu giữa 2 mentions không tồn tại khoảng trắng.
class SocialSpan with SocialSpanVars {
  static const String socialDetectPrefix = "@";

  SocialSpan({
    this.onUpdateText,
    this.onMentionTap,
    this.onHashtagTap,
    this.onLinkTap,
    this.onEmailTap,
    this.onPhoneTap,
    this.onFileTap,
  }) {
    onTaps = {
      DetectedType.mention: onMentionTap,
      DetectedType.url: onLinkTap,
      DetectedType.hashtag: onHashtagTap,
      DetectedType.phone: onPhoneTap,
      DetectedType.email: onEmailTap,
      DetectedType.file: onFileTap,
    };
  }

  // params
  final OnUpdateText? onUpdateText;

  final OnRegexTap? onMentionTap;
  final OnRegexTap? onHashtagTap;
  final OnRegexTap? onLinkTap;
  final OnRegexTap? onEmailTap;
  final OnRegexTap? onPhoneTap;
  final OnRegexTap? onFileTap;

  late Map<DetectedType, OnRegexTap?> onTaps;

  // local params
  List<Mentions> _mentions = [];

  String _oldText = "";

  String _text = "";

  String _addedMentionId = "";
  String _addedMentionDisplayName = "";

  TextSpan build(
    List<Mentions> mentions,
    String textStr, {
    String oldText = "",
    String addedMentionId = "",
    String addedMentionDisplayName = "",
  }) {
    _text = textStr;
    _mentions = mentions;
    _oldText = oldText;
    _addedMentionId = addedMentionId;
    _addedMentionDisplayName = addedMentionDisplayName;

    if (_text.isEmpty) {
      _mentions.clear();
      return const TextSpan();
    }
    // handle mentions
    if (_mentions.isEmpty) {
      return _buildDetectSpan(_text);
    }

    _mentions.sort((a, b) => a.offset.compareTo(b.offset));

    _updateMentionsIfNeeded();

    return _build();
  }

  void _updateMentionsIfNeeded() {
    // chỉ cần update lại mention khi ở chế độ Editting
    if (onUpdateText == null) return;

    List<Diff> _differences = diff(_oldText, _text);
    List<StringDiff> _diffs = [];
    /*
      Trả về các differences của text trước khi user thao tác và text sau khi user thao tác
      diff có dạng: [Diff(0,"def ABC 123 Nga 55 "), Diff(-1," "), Diff(1,"ABC"), Diff(0," ngaaa Nga 62 Nga 735948 ABC ")]
      -1 -> phần bị DELETE
       0 -> phần EQUAL
       1 -> phần được INSERT
    */
    int _start = 0;
    for (var element in _differences) {
      _diffs.add(StringDiff(element,
          TextRange(start: _start, end: _start + element.text.length)));

      _start += element.text.length;
    }

    /*
      Đối với list diffs, update lại mentions (nếu cần thiết):
      - diffs có 2 phần tử:
        1. EQUAL + INSERT -> bỏ qua
        2. EQUAL + DELETE -> xóa mention cuối cùng
      - diffs có > 2 phần tử:
        1. Tìm ra khoảng thay đổi, từ vị trí nào tới vị trí nào
        2. Dựa vào khoảng thay đổi:
          2.1. Cập nhật lại vị trí mention
          2.2. Xóa mention (nếu cần thiết)
    */
    if (_diffs.isNotEmpty) {
      /// [_updateRange]: chứa khoảng thay đổi, từ vị trí nào tới vị trí nào
      TextRange _updateRange = const TextRange(start: -1, end: -1);
      if (_diffs.length <= 2) {
        // trường hợp user xóa mention ở cuối cùng của ô input
        if (_diffs.last.diff.operation == DIFF_DELETE) {
          _removeLastMention(_diffs.last);
        } else if (_diffs.first.diff.operation != DIFF_EQUAL) {
          // DIFF_INSERT hoặc DIFF_DELETE ở đầu
          _updateRange = TextRange(
              start: _diffs.first.textRange.start,
              end: _diffs.first.textRange.end);
        }
      } else {
        // DIFF_EQUAL hoặc DIFF_INSERT hoặc DIFF_DELETE ở giữa
        if (_diffs.first.diff.operation == DIFF_EQUAL) {
          _updateRange = TextRange(
              start: _diffs[1].textRange.start,
              end: _diffs[_diffs.length - 2].textRange.end);
        } else {
          _updateRange =
              TextRange(start: 0, end: _addedMentionDisplayName.length);
        }
      }

      if (_updateRange.start != -1 && _updateRange.end != -1) {
        _updateMention(_diffs, _updateRange);
      }
    }
  }

  void _updateMention(List<StringDiff> diffs, TextRange updateRange) {
    /// [_updateIndex]: vị trí mention cần cập nhật
    /// Nếu < 0: số kí tự bị xóa > số kí tự được thêm -> lùi mention sang trái
    /// Nêu > 0: số kí tự được thêm > số kí tự bị xóa -> lùi mention sang phải
    int _updateIndex = 0;
    // bỏ qua diff cuối cùng
    for (int _index = 0; _index < diffs.length - 1; _index++) {
      StringDiff _strDiff = diffs[_index];

      switch (_strDiff.diff.operation) {
        case DIFF_INSERT:
          _updateIndex += _strDiff.diff.text.length;
          break;
        case DIFF_DELETE:
          _updateIndex -= _strDiff.diff.text.length;
          break;
      }
    }

    // ---------- Cập nhật lại vị trí mentions đã thay đổi ---------- \\
    List<Mentions> _modifyMentions = [];

    /// [_needNext]: -> tìm ra mention đầu tiên có [length] nằm trong vùng cần cập nhật [_updateRange]
    bool _needNext = true;

    // thêm mention có chứa phần bị thay đổi
    for (var _mention in _mentions) {
      if (_needNext && _mention.length >= updateRange.start) {
        _needNext = false;
        _modifyMentions.add(_mention);
      }

      // không cập nhật lại vị trí đối với mention mới thêm vào
      if (_mention.offset >= updateRange.start &&
          _mention.mentionId != _addedMentionId) {
        _mention.offset += _updateIndex;
        _mention.length += _updateIndex;

        _modifyMentions.add(_mention);
      }
    }

    // ---------- Xóa các mentions trong khoảng kí tự user đã xóa ---------- \\
    _modifyMentions = _modifyMentions.toSet().toList();

    /// [_needNext]: -> tìm ra mention đầu tiên có [length] nằm trong vùng cần cập nhật [_updateRange]
    _needNext = true;

    /// [_newText]: cập nhật lại text nếu mention cần xóa
    String _newText = _text;

    /// [_cursorPos]: cập nhật lại vị trí cursor của ô input nếu mention cần xóa
    int _cursorPos = updateRange.start;
    for (int i = 0; i < _modifyMentions.length; i++) {
      final Mentions _mention = _modifyMentions[i];
      if (_needNext) {
        if (_mention.offset > (updateRange.start + _updateIndex) ||
            _mention.length >= (updateRange.start + _updateIndex)) {
          if (_mention.length >= (updateRange.end + _updateIndex)) {
            _needNext = false;
          }
          if (_mention.offset > 0 && _mention.length < _text.length) {
            if (_text.substring(_mention.offset, _mention.length) !=
                _mention.displayName) {
              /// remove text nếu xóa mention
              /// chỉ xóa khi [diffs] chứa DIFF_DELETE
              if (_updateIndex == -1) {
                _cursorPos = _mention.offset - 1;
                _newText = _newText.substring(0, _mention.offset) +
                    _newText.substring(_mention.length, _text.length);
              }
              _mentions.remove(_mention);
            }
          } else {
            // if (_mention.mentionId != _addedMentionId) {
            //   // trường hợp user xóa nhiều kí tự
            //   _mentions.remove(_mention);
            // }
          }
        }
      }
    }

    if (_newText != _text) {
      _updateTextValue(_newText, _cursorPos);
    }

    for (var mention in _modifyMentions) {
      if (mention.offset < 0 ||
          _text.substring(mention.offset, mention.length) !=
              mention.displayName) {
        _mentions.remove(mention);
      }
    }
  }

  void _removeLastMention(StringDiff strDiff) {
    Mentions _lastMention = _mentions.last;

    if (_lastMention.length >= strDiff.textRange.end) {
      int _cursorPos = _lastMention.offset;
      _mentions.remove(_lastMention);

      _updateTextValue(_text.substring(0, _lastMention.offset), _cursorPos);
    }
  }

  void _updateTextValue(String newValue, int cursorPos) {
    _text = newValue;
    // call func update text bên controller
    onUpdateText?.call(_text, cursorPos);
  }

  TextSpan _build() {
    if (_mentions.isEmpty) return _buildDetectSpan(_text);
    // list mentions must be sorted
    List<InlineSpan> spans = [];

    int _lastPosAdded = 0;

    for (var mention in _mentions) {
      // mention ở đầu
      if (mention.offset == 0) {
        _lastPosAdded = mention.length;

        _addMentionSpan(spans, mention);
      } else {
        if (_lastPosAdded == mention.offset) {
          _addMentionSpan(spans, mention, isWarning: true);
          _lastPosAdded = mention.length;
        } else if (_lastPosAdded != mention.offset) {
          // thêm text nằm trước mention (nếu có)
          if (_lastPosAdded < mention.offset && _text.length > mention.offset) {
            spans.add(_buildDetectSpan(
                _text.substring(_lastPosAdded, mention.offset)));
          }

          _addMentionSpan(spans, mention);
          _lastPosAdded = mention.length;
        }
      }
    }

    // thêm text nằm sau mentions (nếu có)
    if (_lastPosAdded != 0) {
      final int _lastIndex =
          _lastPosAdded < _text.length ? _text.length : (_text.length - 1);
      if (_lastIndex > _lastPosAdded && _text.length <= _lastIndex) {
        spans.add(_buildDetectSpan(_text.substring(_lastPosAdded, _lastIndex)));
      }
    }
    return TextSpan(children: spans, style: SocialSpanVars._normalTextStyle);
  }

  void _addMentionSpan(
    List<InlineSpan> spans,
    Mentions mention, {
    // isWarning: không có space với các mention cạnh bên
    bool isWarning = false,
  }) {
    if (_text.length < mention.length) {
      return;
    }

    String _subStr = "";
    try {
      _subStr = _text.substring(mention.offset, mention.length);
    } catch (ex) {
      _subStr = "";
    }

    // nếu mention trước đó nằm cạnh mention không có khoảng trắng -> không cần warning
    bool _needToWarning =
        isWarning && spans.last.style != SocialSpanVars._socialTextWarningStyle;

    spans.add(
      TextSpan(
        text: _subStr,
        style: _needToWarning
            ? SocialSpanVars._socialTextWarningStyle
            : onUpdateText != null
                ? _detectionTextStyles[
                    DetectedType.mention] // nếu ở ô input, chế độ Editting
                : SocialSpanVars._socialTextWithoutBGStyle,
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            onMentionTap?.call(mention.mentionId);
          },
      ),
    );
  }

  TextSpan _buildDetectSpan(String text) {
    return SocialTextSpanBuilder(
      regularExpressions: _regularExpressionsWithoutMention,
      defaultTextStyle: SocialSpanVars._normalTextStyle,
      detectionTextStyles: _detectionTextStyles,
      onTapDetection: (detection) =>
          onTaps[detection.type]?.call(detection.text),
    ).build(text);
  }
}

mixin SocialSpanVars {
  static final TextStyle _socialTextStyle =
      textStyle(GPTypography.bodyMedium)?.copyWith(
            backgroundColor: GPColor.functionPositiveSecondary,
            color: GPColor.functionAccentWorkSecondary,
          ) ??
          const TextStyle();

  static final TextStyle _socialTextWarningStyle =
      textStyle(GPTypography.bodyMedium)?.copyWith(
            backgroundColor: const Color.fromRGBO(86, 202, 118, 0.36),
            color: GPColor.functionAccentWorkSecondary,
          ) ??
          const TextStyle();

  static final TextStyle _socialTextWithoutBGStyle =
      textStyle(GPTypography.bodyMedium)?.copyWith(
            color: GPColor.functionAccentWorkSecondary,
          ) ??
          const TextStyle();

  static final TextStyle _socialOtherTextStyle =
      textStyle(GPTypography.bodyMedium)
              ?.copyWith(color: GPColor.functionAccentWorkSecondary) ??
          const TextStyle();

  static final TextStyle _normalTextStyle =
      textStyle(GPTypography.bodyMedium) ?? const TextStyle();

  final Map<DetectedType, TextStyle> _detectionTextStyles = {
    DetectedType.mention: _socialTextStyle,
    DetectedType.url: _socialOtherTextStyle,
    DetectedType.hashtag: _socialOtherTextStyle,
    DetectedType.phone: _socialOtherTextStyle,
    DetectedType.email: _socialOtherTextStyle,
    DetectedType.file: _socialOtherTextStyle,
    DetectedType.plainText: _normalTextStyle,
  };

  final Map<DetectedType, RegExp> _regularExpressions = {
    DetectedType.mention: atSignRegExp,
    DetectedType.hashtag: hashTagRegExp,
    DetectedType.url: urlRegex,
    DetectedType.phone: RegExp(Pattern.phonePattern, multiLine: true),
    DetectedType.email: RegExp(Pattern.emailPattern, multiLine: true),
    // DetectedType.file: RegExp(Pattern.filePattern, multiLine: true),
  };

  final Map<DetectedType, RegExp> _regularExpressionsWithoutMention = {
    DetectedType.hashtag: hashTagRegExp,
    DetectedType.url: urlRegex,
    DetectedType.phone: RegExp(Pattern.phonePattern, multiLine: true),
    DetectedType.email: RegExp(Pattern.emailPattern, multiLine: true),
    // DetectedType.file: RegExp(Pattern.filePattern, multiLine: true),
  };

  DetectedType getType(String word) {
    return _regularExpressions.keys.firstWhere(
        (type) => _regularExpressions[type]!.hasMatch(word),
        orElse: () => DetectedType.plainText);
  }
}
