// To parse this JSON data, do
//
//     final assignee = assigneeFromJson(jsonString);

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin AssigneeExtension {
  final RxBool isSelected = false.obs;
}

class Assignee extends Equatable with AssigneeExtension {
  Assignee({
    required this.id,
    required this.displayName,
    this.lang,
    this.fullName,
    this.cover,
    this.avatar,
    this.email,
    this.linkProfile,
    this.info,
    this.featuredMedia,
    this.status,
    this.statusKyc,
    this.statusVerify,
    this.workspaceAccount,
    this.workspaceId,
    this.workspaceRole,
    this.phoneNumber,
    this.avatarThumbPattern,
    this.coverThumbPattern,
    this.relation,
  });

  final int id;
  final String displayName;
  final String? lang;
  final String? fullName;
  final String? cover;
  final String? avatar;
  final String? email;
  final String? linkProfile;
  final Info? info;
  final FeaturedMedia? featuredMedia;
  final int? status;
  final int? statusKyc;
  final int? statusVerify;
  final int? workspaceAccount;
  final String? workspaceId;
  final int? workspaceRole;
  final String? phoneNumber;
  final String? avatarThumbPattern;
  final String? coverThumbPattern;
  final int? relation;

  String get title {
    String _title = "";
    try {
      _title = info?.work?.first.title ?? "";
      if (_title.isEmpty) {
        try {
          _title = info?.work?.first.department ?? "";
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return _title;
  }

  factory Assignee.fromJson(Map<String, dynamic> json) => Assignee(
        id: json["id"],
        displayName: json["display_name"],
        lang: json["lang"],
        fullName: json["full_name"],
        cover: json["cover"],
        avatar: json["avatar"],
        email: json["email"],
        linkProfile: json["link_profile"],
        info: json["info"] == null
            ? null
            : Info.fromJson(Map<String, dynamic>.from(json["info"])),
        featuredMedia: json["featured_media"] == null
            ? null
            : FeaturedMedia.fromJson(
                Map<String, dynamic>.from(json["featured_media"])),
        status: json["status"],
        statusKyc: json["status_kyc"],
        statusVerify: json["status_verify"],
        workspaceAccount: json["workspace_account"],
        workspaceId: json["workspace_id"],
        workspaceRole: json["workspace_role"],
        phoneNumber: json["phone_number"],
        avatarThumbPattern: json["avatar_thumb_pattern"],
        coverThumbPattern: json["cover_thumb_pattern"],
        relation: json["relation"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "display_name": displayName,
        "lang": lang,
        "full_name": fullName,
        "cover": cover,
        "avatar": avatar,
        "email": email,
        "link_profile": linkProfile,
        "info": info?.toJson(),
        "featured_media": featuredMedia?.toJson(),
        "status": status,
        "status_kyc": statusKyc,
        "status_verify": statusVerify,
        "workspace_account": workspaceAccount,
        "workspace_id": workspaceId,
        "workspace_role": workspaceRole,
        "phone_number": phoneNumber,
        "avatar_thumb_pattern": avatarThumbPattern,
        "cover_thumb_pattern": coverThumbPattern,
        "relation": relation,
      };

  @override
  List<Object?> get props => [id];

  @override
  bool operator ==(Object other) {
    if (other is Assignee) {
      return id == other.id &&
          displayName == other.displayName &&
          avatar == other.avatar &&
          // fullName == other.fullName &&
          avatarThumbPattern == other.avatarThumbPattern;
    }
    return false;
  }
}

class FeaturedMedia {
  FeaturedMedia();

  factory FeaturedMedia.fromJson(Map<String, dynamic> json) => FeaturedMedia();

  Map<String, dynamic> toJson() => {};
}

class Info {
  Info({
    // this.bio,
    // this.relationship,
    // this.address,
    this.work,
  });

  // final String? bio;
  // final Relationship? relationship;
  // final Address? address;
  final List<Work>? work;

  factory Info.fromJson(Map<String, dynamic> json) => Info(
        // bio: json["bio"],
        // relationship: json["relationship"] == null
        //     ? null
        //     : Relationship.fromJson(
        //         Map<String, dynamic>.from(json["relationship"])),
        // address: json["address"] == null
        //     ? null
        //     : Address.fromJson(Map<String, dynamic>.from(json["address"])),
        work: json["work"] == null
            ? null
            : List<Work>.from(json["work"]
                .map((x) => Work.fromJson(Map<String, dynamic>.from(x)))),
      );

  Map<String, dynamic> toJson() => {
        // "bio": bio,
        // "relationship": relationship?.toJson(),
        // "address": address?.toJson(),
        "work": List<dynamic>.from((work ?? []).map((x) => x.toJson())),
      };
}

class Address {
  Address({
    this.current,
  });

  final Current? current;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        current:
            json["current"] == null ? null : Current.fromJson(json["current"]),
      );

  Map<String, dynamic> toJson() => {
        "current": current?.toJson(),
      };
}

class Current {
  Current({
    this.city,
    this.privacy,
  });

  final int? city;
  final int? privacy;

  factory Current.fromJson(Map<String, dynamic> json) => Current(
        city: json["city"],
        privacy: json["privacy"],
      );

  Map<String, dynamic> toJson() => {
        "city": city,
        "privacy": privacy,
      };
}

class Relationship {
  Relationship({
    this.title,
  });

  final String? title;

  factory Relationship.fromJson(Map<String, dynamic> json) => Relationship(
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {"title": title};
}

class Work {
  Work({
    this.company,
    this.department,
    this.title,
    this.departmentId,
    this.departments,
    this.departmentIds,
    this.roleId,
    this.privacy,
  });

  final String? company;

  final String? department;
  final String? title;
  final String? departmentId;
  final List<dynamic>? departments;
  final List<dynamic>? departmentIds;
  final String? roleId;
  final int? privacy;

  factory Work.fromJson(Map<String, dynamic> json) => Work(
        company: json["company"],
        department: json["department"],
        title: json["title"],
        departmentId: json["department_id"],
        departments: (json["departments"] == null ||
                json["departments"] is List<dynamic>)
            ? json["departments"]
            : Map<String, dynamic>.from(json["departments"]).values.toList(),
        departmentIds: (json["department_ids"] == null ||
                json["department_ids"] is List<dynamic>)
            ? json["department_ids"]
            : Map<String, dynamic>.from(json["department_ids"]).values.toList(),
        roleId: json["role_id"],
        privacy: json["privacy"],
      );

  Map<String, dynamic> toJson() => {
        "company": company,
        "department": department,
        "title": title,
        "department_id": departmentId,
        "departments": departments,
        "department_ids": departmentIds,
        "role_id": roleId,
        "privacy": privacy,
      };
}

class ProjectMember {
  final int id;
  final String displayName;
  final String avatar;
  final String avatarThumbPattern;
  final String departmentName;
  final String roleName;

  ProjectMember({
    required this.id,
    required this.displayName,
    required this.avatar,
    required this.avatarThumbPattern,
    required this.departmentName,
    required this.roleName,
  });

  factory ProjectMember.fromJson(Map<String, dynamic> json) => ProjectMember(
        id: json["id"],
        displayName: json["display_name"],
        avatar: json["avatar"],
        avatarThumbPattern: json["avatar_thumb_pattern"],
        departmentName: json["department_name"],
        roleName: json["role_name"],
      );

  Assignee toAssignee() {
    return Assignee(
        id: id,
        displayName: displayName,
        avatar: avatar,
        avatarThumbPattern: avatarThumbPattern,
        info: Info(work: [Work(department: departmentName, title: roleName)]));
  }
}
