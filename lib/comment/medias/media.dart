// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui';

// import 'package:dio/dio.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:gapo_flutter/models/comment.dart';
// import 'package:gapo_flutter/screens/task_details/upload/model/file_extension_type.dart';

// import 'package:flutter_video_info/flutter_video_info.dart';
// import 'package:get/state_manager.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';

// // max height
// const commentPickMediaMaxHeight = 76;
// const commentMediaMaxRatio = 1.5;

// class CommentMediaModel {
//   Medias? uploaded;
//   MediaLocal? local;

//   CommentMediaModel({this.uploaded, this.local});

//   bool get isUploaded =>
//       uploaded != null &&
//       uploaded!.thumbPattern != null &&
//       uploaded!.thumbPattern!.isNotEmpty;
// }

// class MediaLocal {
//   final PlatformFile platformFile;

//   // size hiển thị khi pick thành công 1 media
//   late int pickWidth;
//   late int pickHeight;

//   // size hiển thị khi upload 1 media
//   late int displayWidth;
//   late int displayHeight;
//   late int loadingWidth;
//   late int loadingHeight;

//   late int originalWidth;
//   late int originalHeight;

//   late FileExtensionType fileExtension;
//   Uint8List? localVideoThumb;

//   RxInt uploadProgress = 0.obs;

//   late CancelToken cancelToken;

//   Object? error;

//   MediaLocal({required this.platformFile});

//   Future<dynamic> init({
//     int displayMaxHeight = commentDisplayMediaMaxHeight,
//   }) async {
//     fileExtension = fileExtensionType(fileName: platformFile.name);

//     String _filePath = platformFile.path!;

//     if (isImage) {
//       final Codec codec =
//           await instantiateImageCodec(File(_filePath).readAsBytesSync());
//       final FrameInfo frameInfo = await codec.getNextFrame();

//       originalWidth = frameInfo.image.width;
//       originalHeight = frameInfo.image.height;

//       _countMediaSize(displayMaxHeight: displayMaxHeight);
//     } else if (isVideo) {
//       final videoInfo = FlutterVideoInfo();

//       var info = await videoInfo.getVideoInfo(_filePath);

//       originalWidth = info?.width ?? 0;
//       originalHeight = info?.height ?? 0;

//       _countMediaSize(displayMaxHeight: displayMaxHeight);

//       localVideoThumb = await VideoThumbnail.thumbnailData(
//         video: _filePath,
//         imageFormat: ImageFormat.PNG,
//         maxWidth: 128,
//         quality: 25,
//       );
//     }

//     return this;
//   }

//   bool get isImage => fileExtension == FileExtensionType.photo;

//   bool get isVideo => fileExtension == FileExtensionType.video;

//   String get fileExtensionStr {
//     if (isImage) {
//       return "image";
//     } else if (isVideo) {
//       return "video";
//     } else {
//       throw Exception("Error fileExtension!!!");
//     }
//   }

//   void _countMediaSize({int displayMaxHeight = commentDisplayMediaMaxHeight}) {
//     double ratio = originalWidth / originalHeight;
//     if (ratio > commentMediaMaxRatio) {
//       ratio = commentMediaMaxRatio;
//     } else {
//       ratio = 2 / 3;
//     }

//     pickHeight = commentPickMediaMaxHeight;
//     pickWidth = (pickHeight * ratio).round();

//     displayHeight = displayMaxHeight;
//     displayWidth = (displayHeight * ratio).round();

//     loadingHeight = commentDisplayMediaMaxHeight;
//     loadingWidth = (loadingHeight * commentMediaMaxRatio).round();
//   }
// }
