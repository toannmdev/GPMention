import 'package:flutter/material.dart';
import 'package:gp_mention/theme/colors.dart';
import 'package:gp_mention/theme/text_theme.dart';

class DefaultAvatar extends StatelessWidget {
  const DefaultAvatar(
      {required this.userName,
      required this.size,
      this.taskNotification = false,
      Key? key})
      : super(key: key);

  final String userName;
  final double size;
  final bool taskNotification;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircleAvatar(
        backgroundColor: _getBgColorWithName(_getDisplayTextByName()),
        child: Text(
          _getDisplayTextByName(),
          style: _getStyleWithSize()
              ?.mergeColor(GPColor.contentInversePrimary)
              .copyWith(height: 1.1),
        ),
      ),
    );
  }

  TextStyle? _getStyleWithSize() {
    if (size == 40) {
      return textStyle(GPTypography.headingLarge);
    } else if (size == 32) {
      return textStyle(GPTypography.bodyMedium);
    } else if (size == 24) {
      return textStyle(GPTypography.bodySmallBold);
    }
    return textStyle(GPTypography.displayMedium);
  }

  String _getDisplayTextByName() {
    if (userName.isEmpty) {
      return '';
    }

    final words = userName.split(' ');
    String name = words.first[0].toUpperCase();
    if (words.length >= 2) {
      name += words.last[0].toUpperCase();
    }
    return name;
  }

  Color _getBgColorWithName(String name) {
    final colors = [
      GPColor.red,
      GPColor.yellow,
      GPColor.orange,
      GPColor.green,
      GPColor.lime,
      GPColor.teal,
      GPColor.blue,
      GPColor.indigo,
      GPColor.purple,
      GPColor.pink,
    ];
    if (isTaskSystemNotification()) {
      return GPColor.informativeSecondary;
    }
    if (name.isEmpty) {
      return colors[0];
    }
    return colors[name.codeUnitAt(0) % colors.length];
  }

  bool isTaskSystemNotification() {
    return _getDisplayTextByName().isEmpty && taskNotification;
  }
}
