// import 'dart:async';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// import '../flutter_social_textfield.dart';

// /// DefaultSocialTextFieldController widget for wrapping the content inside a for automatically showing the relevant content for detected type. (i.e showing mention/user list when cursor is on the @mention/#hashtag text)
// /// [focusNode] required and also needs also to be attached to the TextField used by the SocialTextEditingController
// /// [textEditingController] required and needs also to be attached to the same TextField
// /// [scrollController] optional, used for determining the visiblility of main content when userlist / mentionlist / etc.. appeared
// /// [child] required, must contain a TextField with the same [textEditingController]
// /// [detectionBuilders] builders for relevant [DetectedType]. nothing is shown if a type does not have a builder
// /// [willResizeChild] the efault value is true. changes the main content size when detection content has been shown.
// class DefaultSocialTextFieldController extends StatefulWidget {
//   final FocusNode focusNode;
//   final ScrollController? scrollController;
//   final SocialTextEditingController textEditingController;
//   final Widget child;
//   final Map<DetectedType, PreferredSize Function(BuildContext context)>?
//       detectionBuilders;
//   final bool willResizeChild;

//   const DefaultSocialTextFieldController({
//     required this.child,
//     required this.textEditingController,
//     required this.focusNode,
//     this.detectionBuilders,
//     this.scrollController,
//     this.willResizeChild = true,
//     Key? key,
//   }) : super(key: key);

//   @override
//   _DefaultSocialTextFieldControllerState createState() =>
//       _DefaultSocialTextFieldControllerState();
// }

// class _DefaultSocialTextFieldControllerState
//     extends State<DefaultSocialTextFieldController> {
//   bool willShowDetectionContent = false;
//   DetectedType _detectedType = DetectedType.plainText;

//   StreamSubscription<SocialContentDetection>? _streamSubscription;

//   Map<DetectedType, double> heightMap = {};

//   var animationDuration = const Duration(milliseconds: 200);

//   @override
//   void dispose() {
//     _streamSubscription?.cancel();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     _streamSubscription =
//         widget.textEditingController.subscribeToDetection(onDetectContent);

//     for (var type in DetectedType.values) {
//       if (widget.detectionBuilders?.containsKey(type) ?? false) {
//         heightMap[type] =
//             widget.detectionBuilders?[type]!(context).preferredSize.height ??
//                 0.0;
//       } else {
//         heightMap[type] = 0;
//       }
//     }
//   }

//   ///Shows the widget that hes been set with the [widget.detectionBuilders]. return empty Container if noting found
//   void onDetectContent(SocialContentDetection detection) {
//     if (detection.type != _detectedType) {
//       setState(() {
//         _detectedType = detection.type;
//       });

//       if (doesHaveBuilderForCurrentType() &&
//           widget.scrollController != null &&
//           widget.textEditingController.selection.baseOffset >= 0) {
//         var baseText = widget.textEditingController.text
//             .substring(0, widget.textEditingController.selection.baseOffset);
//         var defaultTextStyle = const TextStyle();

//         if (widget.textEditingController.detectionTextStyles
//             .containsKey(DetectedType.plainText)) {
//           defaultTextStyle = widget.textEditingController
//               .detectionTextStyles[DetectedType.plainText]!;
//         }

//         var estimatedSize = getTextRectSize(
//             width: widget.focusNode.size.width,
//             text: baseText,
//             style: defaultTextStyle);

//         Future.delayed(
//             animationDuration,
//             () => widget.scrollController?.animateTo(estimatedSize.height,
//                 duration: animationDuration, curve: Curves.easeInOut));
//       }
//     }
//   }

//   ///Used for calculating size for text. scrolls the main content if it is positioned under the detected content widget.
//   Size getTextRectSize({
//     required width,
//     required String text,
//     required TextStyle style,
//   }) {
//     final TextPainter textPainter = TextPainter(
//         text: TextSpan(text: text, style: style),
//         textDirection: TextDirection.ltr)
//       ..layout(minWidth: 0, maxWidth: width);
//     return textPainter.size;
//   }

//   ///return true if content type set
//   bool doesHaveBuilderForCurrentType() {
//     return (widget.detectionBuilders?.containsKey(_detectedType) ?? false);
//   }

//   ///return bottom value of main content
//   double getChildBottomPosition() {
//     if (!doesHaveBuilderForCurrentType() || (!widget.willResizeChild)) {
//       return 0;
//     }

//     return heightMap[_detectedType] ?? 0;
//   }

//   ///return height for detected content, zero if not set.
//   double getBuilderContentHeight() {
//     if (!doesHaveBuilderForCurrentType() || (!widget.willResizeChild)) {
//       return 0;
//     }
//     return heightMap[_detectedType] ?? 0;
//   }

//   ///returns detected content
//   PreferredSize getDetectionContent() {
//     if (!(widget.detectionBuilders?.containsKey(_detectedType) ?? false)) {
//       return PreferredSize(child: Container(), preferredSize: Size.zero);
//     }
//     return widget.detectionBuilders?[_detectedType]!(context) ??
//         PreferredSize(child: Container(), preferredSize: Size.zero);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final int _lineNumbers =
//         '\n'.allMatches(widget.textEditingController.text).length + 1;
//     final double _height = 16 * _lineNumbers + 50;

//     return Stack(
//       children: [
//         widget.child,
//         Padding(
//             padding: EdgeInsets.only(top: 0, bottom: _height),
//             child: SizedBox(
//                 height: getBuilderContentHeight(),
//                 child: getDetectionContent())),
//       ],
//     );
//   }
// }
