// import 'package:dio/dio.dart';
// import 'package:gapo_flutter/base/networking/services/upload_api.dart';
// import 'package:gapo_flutter/models/comment.dart';
// import 'package:gapo_flutter/screens/task_create/model/gp_file_picker_result.dart';
// import 'package:gapo_flutter/screens/task_details/upload/model/upload_file_response_model.dart';
// import 'package:gapo_flutter/screens/task_details/upload/model/upload_image_response_model.dart';
// import 'package:gapo_flutter/utils/utils.dart';
// import 'package:get/get.dart';

// import 'media.dart';

// /*
//   [CommentMediasController]: nullable
//   - init khi user click icon mediaPicker
//   - dispose khi màn TaskCreate close
//   - Quản lý local medias, uploaded medias
// */
// class CommentMediasController extends GetxController {
//   final UploadAPI _uploadService = UploadAPI();

//   RxList<CommentMediaModel> commentMedias = RxList();

//   bool get hasMedia => commentMedias.isNotEmpty;

//   Future<void> handlePickedFiles(GPFilePickerResult? gpFilePickerResult) async {
//     if (gpFilePickerResult == null ||
//         gpFilePickerResult.filePickerResult == null) return;

//     for (var element in gpFilePickerResult.filePickerResult!.files) {
//       commentMedias.add(
//         CommentMediaModel(
//           local: await MediaLocal(
//             platformFile: element,
//           ).init(),
//         ),
//       );
//     }
//   }

//   void addMedias(List<Medias> medias) {
//     if (medias.isEmpty) return;

//     commentMedias.clear();

//     for (var element in medias) {
//       commentMedias.add(CommentMediaModel(uploaded: element));
//     }
//   }

//   void removeCommentMedia(CommentMediaModel commentMediaLocal) {
//     commentMedias.remove(commentMediaLocal);
//   }

//   void clearMedias() {
//     commentMedias.clear();
//   }

//   Future<List<Medias>> uploadMedias({
//     List<CommentMediaModel>? commentMediaLocals,
//   }) async {
//     List<Medias> medias = [];
//     List<CommentMediaModel> _commentMedias;
//     if (commentMediaLocals != null && commentMediaLocals.isNotEmpty) {
//       _commentMedias = commentMediaLocals;
//     } else {
//       _commentMedias = commentMedias;
//     }

//     for (var element in _commentMedias) {
//       if (element.uploaded != null) {
//         medias.add(element.uploaded!);
//         break;
//       }

//       if (element.local == null) break;

//       final bool _isImage = element.local!.isImage;

//       CancelToken cancelToken = CancelToken();
//       element.local!.cancelToken = cancelToken;

//       if (_isImage) {
//         UploadImageResponseModel uploadResult = await _uploadService
//             .uploadImage(
//                 filePath: element.local!.platformFile.path!,
//                 fileName: element.local!.platformFile.name,
//                 uploadProgress: (progress) {
//                   element.local!.uploadProgress.value = progress.toInt();
//                 },
//                 cancelToken: cancelToken)
//             .onError((error, stackTrace) {
//           element.local!.error = error.obs;
//           element.local!.uploadProgress = 0.obs;

//           return UploadImageResponseModel();
//         });

//         if ((uploadResult.src ?? "").isNotEmpty) {
//           medias.add(element.uploaded = Medias(
//               id: uploadResult.id ?? "",
//               type: uploadResult.type ?? "jpeg",
//               width: element.local!.originalWidth.toInt(),
//               height: element.local!.originalHeight.toInt(),
//               src: uploadResult.src!,
//               size: uploadResult.size,
//               mediaLocal: await MediaLocal(
//                 platformFile: element.local!.platformFile,
//               ).init()));
//         }
//       } else if (element.local!.isVideo) {
//         UploadFileResponseModel _uploadResult = await _uploadService
//             .uploadFile(
//                 filePath: element.local!.platformFile.path!,
//                 fileName: element.local!.platformFile.name,
//                 uploadProgress: (progress) {
//                   element.local!.uploadProgress.value =
//                       (progress * 100).toInt();
//                 },
//                 cancelToken: cancelToken)
//             .onError((error, stackTrace) {
//           element.local!.error = error.obs;
//           element.local!.uploadProgress = 0.obs;

//           return UploadFileResponseModel();
//         });

//         if ((_uploadResult.fileLink ?? "").isNotEmpty) {
//           medias.add(element.uploaded = Medias(
//               id: _uploadResult.id ?? "",
//               type: "file",
//               width: element.local!.originalWidth.toInt(),
//               height: element.local!.originalHeight.toInt(),
//               src: _uploadResult.fileLink ?? "",
//               size: _uploadResult.size,
//               fileName: _uploadResult.name,
//               mediaLocal: await MediaLocal(
//                 platformFile: element.local!.platformFile,
//               ).init()
//               // thumbPattern: Utils.imageThumb(_uploadResult.thumbPattern ?? "",
//               //     "${commentPickMediaMaxHeight * 3}x${commentPickMediaMaxHeight * 3}")
//               )
//             ..fileType = _uploadResult.fileType ?? "");
//         }
//       } else {
//         throw Exception("File is not supported!!!");
//       }
//     }

//     return medias;
//   }

//   Future cancelUploadMedias({
//     List<CommentMediaModel>? commentMediaLocals,
//   }) async {
//     List<CommentMediaModel> _commentMedias;
//     if (commentMediaLocals != null && commentMediaLocals.isNotEmpty) {
//       _commentMedias = commentMediaLocals;
//     } else {
//       _commentMedias = commentMedias;
//     }

//     for (var element in _commentMedias) {
//       element.local?.cancelToken.cancel();
//     }
//   }
// }
