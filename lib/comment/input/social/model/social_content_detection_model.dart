import 'package:flutter/material.dart';

import '../social.dart';

///Detection Content
///[type] [DetectedType]
///[range] Range of detection
///[text] substring content created by using [range] value.
class SocialContentDetection {
  final DetectedType type;
  final TextRange range;
  final String text;
  
  const SocialContentDetection(
    this.type,
    this.range,
    this.text,
  );

  @override
  String toString() {
    return 'SocialContentDetection{type: $type, range: $range, text: $text}';
  }
}
