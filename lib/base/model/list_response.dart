import 'dart:convert';

import 'base_parser_json.dart';

ListAPIResponse assigneeFromJson(String str) =>
    ListAPIResponse.fromJson(json.decode(str));

String assigneeToJson(ListAPIResponse data) => json.encode(data.toJson());

class ListAPIResponse<T> {
  ListAPIResponse({
    required this.code,
    required this.message,
    required this.data,
    required this.links,
  });

  final int code;
  final String message;
  final List<T> data;
  final Links links;

  factory ListAPIResponse.fromJson(Map<String, dynamic> json) {
    return ListAPIResponse(
      code: json["code"],
      message: json["message"],
      data: List<T>.from(json["data"].map((x) => GPParserJson.parseJson<T>(x))),
      links: json["links"] == null
          ? Links(
              next: "",
              prev: "",
              totalPages: 1,
            )
          : Links.fromJson(json["links"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toString())),
        "links": links.toJson(),
      };
}

class Links {
  Links({
    required this.next,
    required this.prev,
    required this.totalPages,
  });

  final String next;
  final String prev;
  final int totalPages;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        next: json["next"],
        prev: json["prev"],
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "next": next,
        "prev": prev,
        "total_pages": totalPages,
      };
}
