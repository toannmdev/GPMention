import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class BaseController extends GetxController {
  RxBool isLoading = false.obs;

  bool get isReadyGetData => !isLoading.value;
  //  && TokenManager.accessToken().isNotEmpty;

  void handleError(Object error) {}

  void dismissKeyboard() {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
  }

  void closeBottomSheet() {
    if (Get.isBottomSheetOpen ?? false) {
      Get.back();
    }
  }
}

abstract class BaseListController<T> extends BaseController {
  bool canLoadMore = true;
  String nextLink = "";
  RxBool showEmptyState = false.obs;
  RxList<T> listItem = RxList<T>();

  RxString errorStr = "".obs;

  bool get isSuccessState => listItem.isNotEmpty;

  bool get isLoadingState => isLoading.value && errorStr.isEmpty;

  bool get isErrorState => errorStr.isNotEmpty;

  bool get isEmptyState =>
      !isLoading.value && errorStr.isEmpty && listItem.isEmpty;

  Future getListItems() async {
    if (isLoading.value) return;
    isLoading.value = true;
    errorStr.value = "";
    // Call API here
  }

  Future loadMoreItems() async {
    if (!canLoadMore || isLoading.value) return;
    await getListItems();
  }

  Future reload() async {
    nextLink = "";
    return await getListItems();
  }

  void handleResponse(List<T> items, String? nextLink) {
    isLoading.value = false;

    bool isReload = this.nextLink.isEmpty;
    canLoadMore = nextLink?.isEmpty == false && items.isNotEmpty;
    this.nextLink = nextLink ?? "";
    _checkEmptyState(items, isReload);
  }

  void buildListItem(List<T> items, bool isReload) {
    if (isReload) {
      listItem.value = items;
    } else {
      listItem.addAll(items);
    }
  }

  void _checkEmptyState(List<T> items, bool isReload) {
    if (isReload && items.isEmpty) {
      showEmptyState.value = true;
    } else {
      showEmptyState.value = false;
      buildListItem(items, isReload);
    }
  }
}
