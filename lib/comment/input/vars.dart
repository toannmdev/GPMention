import 'package:flutter/widgets.dart';

import 'social/social.dart';

mixin InputCommentVars {
  final FocusNode focusNode = FocusNode();

  late SocialTextEditingController textEditingController =
      SocialTextEditingController();
      
  late LengthMap lastDetection;

  void clearText() {
    textEditingController.text = "";
    textEditingController.mentions.clear();
  }
}
