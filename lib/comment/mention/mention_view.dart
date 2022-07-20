import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gp_mention/theme/colors.dart';

import '../input/controller.dart';
import '../input/widgets/measure_size_widget.dart';
import '../input/widgets/overlay_container.dart';
import 'mention_controller.dart';
import 'mention_listview.dart';

class MentionOverlay extends GetView<InputCommentController> {
  const MentionOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => OverlayContainer(
        asWideAsParent: true,
        show: controller.showMentionList.value &&
            Get.find<MentionController>().listItem.isNotEmpty,
        position: OverlayContainerPosition(0, controller.overLayBottom.value),
        child: FadeTransition(
          opacity: CurvedAnimation(
            parent: controller.animationController,
            curve: Curves.fastOutSlowIn,
          ),
          child: MeasureSizeWidget(
            onChange: (size) {
              controller.overLayBottom.value = size.height;
              controller.animationController.forward();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              constraints:
                  BoxConstraints(maxHeight: controller.overlayMaxHeight),
              decoration: BoxDecoration(
                color: GPColor.bgPrimary,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Get.find<MentionController>().listItem.isNotEmpty
                      ? GPColor.linePrimary
                      : Colors.transparent,
                ),
              ),
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: const MentionList(),
            ),
          ),
        ),
      ),
    );
  }
}
