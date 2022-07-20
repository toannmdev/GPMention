import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gp_mention/comment/input/input_comment_page.dart';
import 'package:gp_mention/comment_example.dart';

Future<void> main() async {
  runApp(const LoadingApp());
}

class LoadingApp extends StatelessWidget {
  final String routeName;
  final String language;
  final bool fromNative;

  const LoadingApp(
      {key,
      this.routeName = "/",
      this.language = "vi",
      this.fromNative = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: const [],
      initialRoute: routeName,
      debugShowCheckedModeBanner: false,
      getPages: Pages.pages,
      routingCallback: (value) {},
    );
  }
}

class Pages {
  static List<GetPage> pages = [
    GetPage(
      name: "/",
      page: () => const CommentExamplePage(),
      binding: TaskInputCommentBinding(),
    ),
  ];
}
