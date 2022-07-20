import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:gp_mention/base/model/list_response.dart';
import 'package:gp_mention/model/assignee.dart';

class AssigneeApi {
  Future<Iterable<Assignee>> getAssignees({
    required String q,
  }) async {
    final String response = await rootBundle.loadString('packages/gp_mention/assets/json/assignee.json');
    final data = await json.decode(response);

    ListAPIResponse<Assignee> result = ListAPIResponse.fromJson(data);

    return result.data.where((element) =>
        element.displayName.contains(q) ||
        (element.fullName ?? "").contains(q));
  }
}
