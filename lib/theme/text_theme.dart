import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'themes.dart';

enum GPTypography {
  displayXXLarge,
  displayXLarge,
  displayLarge,
  displayMedium,
  displaySmall,
  headingXLarge,
  headingLarge,
  headingMedium,
  headingSmall,
  bodyLarge,
  bodyMedium,
  bodySmall,
  bodySmallBold
}

extension TextTheme on TextStyle {
  TextStyle mergeFontSize(double size) {
    return merge(TextStyle(fontSize: size));
  }

  TextStyle mergeColor(Color color) {
    return merge(TextStyle(color: color));
  }

  TextStyle mergeFontWeight(FontWeight weight) {
    return merge(TextStyle(fontWeight: weight));
  }
}

enum AutomaticallyScaleTextStyle {
  none,
  noti,
  feed,
  composeFeed,
}

TextStyle? textStyle(
  GPTypography typo, {
  AutomaticallyScaleTextStyle automaticallyScale =
      AutomaticallyScaleTextStyle.none,
}) {
  TextStyle? textStyle;
  switch (typo) {
    case GPTypography.displayXXLarge:
      textStyle = AppThemes.instance.textTheme.headline1;
      break;
    case GPTypography.displayXLarge:
      textStyle = AppThemes.instance.textTheme.headline2;
      break;
    case GPTypography.displayLarge:
      textStyle = AppThemes.instance.textTheme.headline3;
      break;
    case GPTypography.displayMedium:
      textStyle = AppThemes.instance.textTheme.headline4;
      break;
    case GPTypography.displaySmall:
      textStyle = AppThemes.instance.textTheme.headline5;
      break;

    case GPTypography.headingXLarge:
      textStyle = AppThemes.instance.textTheme.headline6;
      break;
    case GPTypography.headingMedium:
      textStyle = AppThemes.instance.textTheme.subtitle2;
      break;
    case GPTypography.headingLarge:
      textStyle = AppThemes.instance.textTheme.subtitle1;
      break;
    case GPTypography.headingSmall:
      textStyle = AppThemes.instance.textTheme.caption;
      break;

    case GPTypography.bodyLarge:
      textStyle = AppThemes.instance.textTheme.bodyText1;
      break;
    case GPTypography.bodyMedium:
      textStyle = AppThemes.instance.textTheme.bodyText2;
      break;
    case GPTypography.bodySmall:
      textStyle = AppThemes.instance.textTheme.overline;
      break;
    case GPTypography.bodySmallBold:
      textStyle = AppThemes.instance.textTheme.overline
          ?.mergeFontWeight(FontWeight.bold);
      break;
    default:
  }

  final kScreenWidth = MediaQuery.of(Get.context!).size.width;

  switch (automaticallyScale) {
    case AutomaticallyScaleTextStyle.none:
      break;
    case AutomaticallyScaleTextStyle.noti:
      if (Get.context != null) {
        final kScreenOver375 = MediaQuery.of(Get.context!).size.width > 375;
        final kScreenHeight = MediaQuery.of(Get.context!).size.height;
        final fontSize = !kScreenOver375 ? 14 : (kScreenHeight > 812 ? 16 : 15);
        textStyle = textStyle?.copyWith(fontSize: fontSize.toDouble());
      }
      break;
    case AutomaticallyScaleTextStyle.feed:
      if (Get.context != null) {
        final fontSize =
            kScreenWidth > 375.0 ? 17.0 : (kScreenWidth < 375 ? 14.0 : 15.0);
        textStyle = textStyle?.copyWith(fontSize: fontSize.toDouble());
      }
      break;
    case AutomaticallyScaleTextStyle.composeFeed:
      if (Get.context != null) {
        final fontSize = kScreenWidth < 375 ? 14.0 : 17.0;
        textStyle = textStyle?.copyWith(fontSize: fontSize.toDouble());
      }
      break;
  }

  double _fontSizeScalablePx = 0;
  if (Get.context != null) {
    BuildContext context = Get.context!;
    if (context.isSmallTablet) {
      _fontSizeScalablePx = 3;
    } else if (context.isLargeTablet) {
      _fontSizeScalablePx = 4;
    } else if (kScreenWidth >= 375 &&
        automaticallyScale == AutomaticallyScaleTextStyle.none) {
      if (kScreenWidth <= 420) {
        // iphone 5s, 6s, x
        _fontSizeScalablePx = 1;
      } else {
        // iphone 12 pro, android screen > 6 inch
        // đặt là 2 thì hơi to, nên để 1.5, hơi lẻ nhưng nhìn ổn
        _fontSizeScalablePx = 1.5;
      }
    }
  }

  if (_fontSizeScalablePx == 0) {
    return textStyle;
  } else {
    return textStyle
        ?.mergeFontSize((textStyle.fontSize ?? 0) + _fontSizeScalablePx);
  }
}
