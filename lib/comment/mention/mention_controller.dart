import 'package:get/get.dart';
import 'package:gp_mention/base/base_controller.dart';
import 'package:gp_mention/comment/input/controller.dart';
import 'package:gp_mention/const/const.dart';
import 'package:gp_mention/model/assignee.dart';
import 'package:gp_mention/network/assignee_api.dart';

/// Controller quản lý các phần mention
class MentionController extends BaseListController<Assignee> {
  final AssigneeApi api = AssigneeApi();

  final RxList<Assignee> selectedMentions = RxList<Assignee>();

  // string search user cần mention
  final RxString searchStr = "".obs;

  /// debounceSearch giúp delay 1 khoảng thời gian khi text change, tránh việc call api quá nhiều lần...
  late Worker debounceSearch;

  @override
  void onInit() {
    super.onInit();

    debounceSearch =
        debounce(searchStr, _onSearchSubmit, time: 100.milliseconds);
  }

  @override
  void onClose() {
    debounceSearch.dispose();
    super.onClose();
  }

  void clear() {
    listItem.clear();
  }

  @override
  Future getListItems() async {
    super.getListItems();

    try {
      Iterable<Assignee> assignees = await api.getAssignees(q: searchStr.value);

      handleResponse(assignees.toList(), "");

      /// cập nhật lại [searchStr] buộc khi mention [searchStr] phải load lại data
      searchStr.value = "";

      _removeMySelfIfNeeded();

      _excludeList();

      _needShowMentionList();
    } catch (error) {
      // handleError(error);

      Get.find<InputCommentController>().showMentionList.value = false;
    }
  }

  void _excludeList() {
    /* 
      remove những record đã được thêm tại clients
      1 user không thể được mention nhiều lần
      Không thể mention bản thân
    */

    if (Get.find<InputCommentController>()
        .textEditingController
        .mentions
        .isEmpty) {
      return;
    }

    for (var mention
        in Get.find<InputCommentController>().textEditingController.mentions) {
      listItem.removeWhere((element) => "${element.id}" == mention.mentionId);
    }
  }

  void _removeMySelfIfNeeded() {
    listItem.removeWhere((element) => "${element.id}" == Constants.userId());
  }

  void _needShowMentionList() {
    Get.find<InputCommentController>().showMentionList.value =
        listItem.isNotEmpty;
  }

  void _onSearchSubmit(String searchStr) {
    if (searchStr.isNotEmpty) {
      this.searchStr.value = searchStr;
      reload();
    }
  }
}
