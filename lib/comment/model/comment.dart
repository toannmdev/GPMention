import 'package:gp_mention/utils/utils.dart';

import 'package:path/path.dart' as p;

const updateNewMentionRuleMS = 1642561619;
//GMT: Wednesday, January 19, 2022 3:06:59 AM
//Your time zone: Wednesday, January 19, 2022 10:06:59 AM

class Comment {
  Comment({
    this.parentId,
    this.commentAs,
    this.text,
    this.mentions,
    this.sticker,
    this.donate,
    this.link,
    this.type,
    this.commentType,
    this.status,
    this.dataSource,
    this.id,
    this.targetId,
    this.targetType,
    this.replyCount,
    this.totalReact,
    this.reactCount,
    this.reactStatus,
    this.comments,
    this.user,
    this.page,
    this.group,
    this.createdAt,
    this.updatedAt,
  });

  late final String? parentId;
  late final CommentAs? commentAs;
  String? text;
  List<Mentions>? mentions;
  late final Sticker? sticker;
  late final Donate? donate;
  late final Link? link;
  late final int? type;

  /// Loại bình luận:
  /// 0: activity logs
  /// 1: text
  /// 2: image
  /// 3: sticker
  /// 4: donate
  /// 5: link
  late final int? commentType;
  late final int? status;

  /// dataSource:
  ///0: unspecified
  ///1: pc_web
  ///2: pc_mobile
  ///3: ios
  ///4: android
  ///5: crawl
  ///6: cms
  ///7: service
  late final int? dataSource;
  String? id;
  late final String? targetId;
  late final String? targetType;
  late final int? replyCount;
  late final int? totalReact;
  late final ReactCount? reactCount;
  late final int? reactStatus;
  late final List<String?>? comments;
  late final User? user;
  late final Page? page;
  late final Group? group;
  int? createdAt;
  int? updatedAt;

  bool get isTypeActivityLogs => commentType == 0;

  bool get isTypeText => commentType == 1;

  bool get isTypeImage => commentType == 2;

  bool get hasText => (text ?? "").isNotEmpty;

  Comment.fromJson(Map<String, dynamic> json) {
    parentId = json['parent_id'];
    commentAs = CommentAs.fromJson(json['comment_as']);
    text = json['text'];
    mentions = json['mentions'] == null
        ? null
        : List.from(json['mentions'])
            .map((e) => _applyNewMentionRule(json)
                ? Mentions.fromJsonNewRule(e)
                : Mentions.fromJson(e))
            .toList();
    sticker =
        json['sticker'] == null ? null : Sticker.fromJson(json['sticker']);
    donate = json['donate'] == null ? null : Donate.fromJson(json['donate']);
    link = json['link'] == null ? null : Link.fromJson(json['link']);
    type = json['type'];
    commentType = json['comment_type'];
    status = json['status'];
    dataSource = json['data_source'];
    id = json['id'];
    targetId = json['target_id'];
    targetType = json['target_type'];
    replyCount = json['reply_count'];
    totalReact = json['total_react'];
    reactCount = json['react_count'] == null
        ? null
        : ReactCount.fromJson(json['react_count']);
    reactStatus = json['react_status'];
    comments = json['comments'] == null
        ? null
        : List.castFrom<dynamic, Null?>(json['comments']);
    user = json['user'] == null ? null : User.fromJson(json['user']);
    page = json['page'] == null ? null : Page.fromJson(json['page']);
    group = json['group'] == null ? null : Group.fromJson(json['group']);
    createdAt = ParserHelper.parseInt(json['created_at']);
    updatedAt = ParserHelper.parseInt(json['updated_at']);
  }

  /// áp dụng lại rule chuẩn của mention:
  /// offset: vị trí đầu tiên của mention: không sửa gì
  /// length: không còn là vị trí kết thúc của mention trên Mobile nữa. length (vị trí kết thúc mention) = offset + length
  bool _applyNewMentionRule(Map<String, dynamic> json) {
    int _createdAt = ParserHelper.parseInt(json['created_at']) ?? 0;
    int _updatedAt = ParserHelper.parseInt(json['updated_at']) ?? 0;
    int _dataSource = json['data_source'] ?? 0;

    // với Mobile, áp dụng rule mới từ thời điểm update, với web và các dataSource thì luôn luôn
    if (_dataSource == 3 || _dataSource == 4) {
      return _createdAt >= updateNewMentionRuleMS ||
          _updatedAt >= updateNewMentionRuleMS;
    }
    return true;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['parent_id'] = parentId;
    _data['comment_as'] = commentAs?.toJson();
    _data['text'] = (text ?? "").trim();
    _data['mentions'] = mentions?.map((e) => e.toJson()).toList();
    _data['sticker'] = sticker?.toJson();
    _data['donate'] = donate?.toJson();
    _data['link'] = link?.toJson();
    _data['type'] = type;
    _data['comment_type'] = commentType;
    _data['status'] = status;
    _data['data_source'] = dataSource;
    _data['id'] = id;
    _data['target_id'] = targetId;
    _data['target_type'] = targetType;
    _data['reply_count'] = replyCount;
    _data['total_react'] = totalReact;
    _data['react_count'] = reactCount?.toJson();
    _data['react_status'] = reactStatus;
    _data['comments'] = comments;
    _data['user'] = user?.toJson();
    _data['page'] = page?.toJson();
    _data['group'] = group?.toJson();
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }

  String get updatedAtDisplay {
    if (updatedAt == null) return 'Đã từ rất lâu rồi';
    return Utils.timeAgoString(updatedAt! * 1000);
  }

  bool get isEdited {
    return createdAt != updatedAt;
  }
}

class CommentAs {
  CommentAs({
    required this.authorType,
    required this.authorId,
  });

  late final String authorType;
  late final String authorId;

  CommentAs.fromJson(Map<String, dynamic> json) {
    authorType = json['author_type'];
    authorId = json['author_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['author_type'] = authorType;
    _data['author_id'] = authorId;
    return _data;
  }
}



extension CommentExt on Comment {
  String getText() {
    return text ?? "";
  }

  void updateIfNeeded(String textDisplay) {
    if (mentions != null && mentions!.isNotEmpty) {
      final String _newText = getText();
      if (_newText != textDisplay) {
        int _offset = textDisplay.indexOf(_newText);

        for (var mention in mentions!) {
          mention.offset -= _offset;
          mention.length = mention.offset + (mention.displayName ?? "").length;
        }
      }
    }
  }
}

String getCommentStr(String? input) {
  return (input ?? "")
      .trim()
      .split(RegExp(r'(?:\r?\n|\r)'))
      .where((s) => s.trim().isNotEmpty)
      .join('\n');
}

mixin MentionExt {
  // string hiển thị trong comment, sử dụng tại client, dùng để compare khi xoá 1 mention
  String? displayName;
}

class Mentions with MentionExt {
  Mentions({
    required this.offset,
    required this.length,
    required this.mentionId,
  });

  late int offset;
  late int length;
  late final String mentionId;

  Mentions.fromJson(Map<String, dynamic> json) {
    offset = json['offset'];
    length = json['length'];
    mentionId = json['mention_id'];
  }

  Mentions.fromJsonNewRule(Map<String, dynamic> json) {
    offset = json['offset'];
    length = json['length'] + offset;
    mentionId = json['mention_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    if (length > offset) {
      _data['offset'] = offset;
      _data['length'] = length - offset;
    } else {
      _data['offset'] = offset;
      _data['length'] = length;
    }
    _data['mention_id'] = mentionId;
    return _data;
  }
}

class Sticker {
  Sticker({
    required this.type,
    required this.stickerId,
    required this.src,
  });

  late final String type;
  late final String stickerId;
  late final String src;

  Sticker.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    stickerId = json['sticker_id'];
    src = json['src'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['type'] = type;
    _data['sticker_id'] = stickerId;
    _data['src'] = src;
    return _data;
  }
}

class Donate {
  Donate({
    required this.amount,
  });

  late final String amount;

  Donate.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['amount'] = amount;
    return _data;
  }
}

class Link {
  Link({
    required this.type,
    required this.src,
    required this.title,
    required this.description,
    required this.thumb,
  });

  late final String type;
  late final String src;
  late final String title;
  late final String description;
  late final Thumb? thumb;

  Link.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    src = json['src'];
    title = json['title'];
    description = json['description'];
    thumb = json['thumb'] == null ? null : Thumb.fromJson(json['thumb']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['type'] = type;
    _data['src'] = src;
    _data['title'] = title;
    _data['description'] = description;
    _data['thumb'] = thumb?.toJson();
    return _data;
  }
}

class Thumb {
  Thumb({
    required this.type,
    required this.width,
    required this.height,
    required this.src,
  });

  late final String type;
  late final int width;
  late final int height;
  late final String src;

  Thumb.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    width = json['width'];
    height = json['height'];
    src = json['src'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['type'] = type;
    _data['width'] = width;
    _data['height'] = height;
    _data['src'] = src;
    return _data;
  }
}

class ReactCount {
  ReactCount({
    required this.reactType_1,
    required this.reactType_2,
    required this.reactType_3,
    required this.reactType_4,
    required this.reactType_5,
    required this.reactType_6,
  });

  late final int reactType_1;
  late final int reactType_2;
  late final int reactType_3;
  late final int reactType_4;
  late final int reactType_5;
  late final int reactType_6;

  ReactCount.fromJson(Map<String, dynamic> json) {
    reactType_1 = json['react_type_1'];
    reactType_2 = json['react_type_2'];
    reactType_3 = json['react_type_3'];
    reactType_4 = json['react_type_4'];
    reactType_5 = json['react_type_5'];
    reactType_6 = json['react_type_6'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['react_type_1'] = reactType_1;
    _data['react_type_2'] = reactType_2;
    _data['react_type_3'] = reactType_3;
    _data['react_type_4'] = reactType_4;
    _data['react_type_5'] = reactType_5;
    _data['react_type_6'] = reactType_6;
    return _data;
  }
}

class User {
  User({
    required this.userId,
    required this.displayName,
    required this.fullName,
    this.cover,
    required this.avatar,
    required this.avatarThumbPattern,
    this.coverThumbPattern,
    this.gender,
    this.status,
    this.statusVerify,
    this.birthday,
  });

  late final String userId;
  late final String displayName;
  late final String fullName;
  late final String? cover;
  late final String avatar;
  late final String avatarThumbPattern;
  late final String? coverThumbPattern;
  late final Gender? gender;
  late final int? status;
  late final int? statusVerify;
  late final Birthday? birthday;

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    displayName = json['display_name'];
    fullName = json['full_name'];
    cover = json['cover'];
    avatar = json['avatar'];
    avatarThumbPattern = json['avatar_thumb_pattern'];
    coverThumbPattern = json['cover_thumb_pattern'];
    gender = json['gender'] == null ? null : Gender.fromJson(json['gender']);
    status = json['status'];
    statusVerify = json['status_verify'];
    birthday =
        json['birthday'] == null ? null : Birthday.fromJson(json['birthday']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['user_id'] = userId;
    _data['display_name'] = displayName;
    _data['full_name'] = fullName;
    _data['cover'] = cover;
    _data['avatar'] = avatar;
    _data['avatar_thumb_pattern'] = avatarThumbPattern;
    _data['cover_thumb_pattern'] = coverThumbPattern;
    _data['gender'] = gender?.toJson();
    _data['status'] = status;
    _data['status_verify'] = statusVerify;
    _data['birthday'] = birthday?.toJson();
    return _data;
  }
}

class Gender {
  Gender({
    required this.gender,
    required this.privacy,
  });

  late final int gender;
  late final int privacy;

  Gender.fromJson(Map<String, dynamic> json) {
    gender = json['gender'];
    privacy = json['privacy'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['gender'] = gender;
    _data['privacy'] = privacy;
    return _data;
  }
}

class Birthday {
  Birthday({
    required this.day,
    required this.month,
    required this.year,
    required this.zodiac,
    required this.privacyBirthDate,
    required this.privacyBirthYear,
  });

  late final int day;
  late final int month;
  late final int year;
  late final String zodiac;
  late final int privacyBirthDate;
  late final int privacyBirthYear;

  Birthday.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    month = json['month'];
    year = json['year'];
    zodiac = json['zodiac'];
    privacyBirthDate = json['privacy_birth_date'];
    privacyBirthYear = json['privacy_birth_year'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['day'] = day;
    _data['month'] = month;
    _data['year'] = year;
    _data['zodiac'] = zodiac;
    _data['privacy_birth_date'] = privacyBirthDate;
    _data['privacy_birth_year'] = privacyBirthYear;
    return _data;
  }
}

class Page {
  Page({
    required this.pageId,
    required this.createAt,
    required this.lastUpdate,
    required this.title,
    required this.alias,
    required this.description,
    required this.info,
    required this.type,
    required this.typeName,
    required this.avatar,
    required this.cover,
    required this.email,
    required this.phone,
    required this.website,
    required this.pageStatus,
    required this.statusVerify,
    required this.avatarThumbPattern,
    required this.coverThumbPattern,
  });

  late final int pageId;
  late final String createAt;
  late final String lastUpdate;
  late final String title;
  late final String alias;
  late final String description;
  late final String info;
  late final int type;
  late final String typeName;
  late final String avatar;
  late final String cover;
  late final String email;
  late final String phone;
  late final String website;
  late final int pageStatus;
  late final int statusVerify;
  late final String avatarThumbPattern;
  late final String coverThumbPattern;

  Page.fromJson(Map<String, dynamic> json) {
    pageId = json['page_id'];
    createAt = json['create_at'];
    lastUpdate = json['last_update'];
    title = json['title'];
    alias = json['alias'];
    description = json['description'];
    info = json['info'];
    type = json['type'];
    typeName = json['type_name'];
    avatar = json['avatar'];
    cover = json['cover'];
    email = json['email'];
    phone = json['phone'];
    website = json['website'];
    pageStatus = json['page_status'];
    statusVerify = json['status_verify'];
    avatarThumbPattern = json['avatar_thumb_pattern'];
    coverThumbPattern = json['cover_thumb_pattern'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['page_id'] = pageId;
    _data['create_at'] = createAt;
    _data['last_update'] = lastUpdate;
    _data['title'] = title;
    _data['alias'] = alias;
    _data['description'] = description;
    _data['info'] = info;
    _data['type'] = type;
    _data['type_name'] = typeName;
    _data['avatar'] = avatar;
    _data['cover'] = cover;
    _data['email'] = email;
    _data['phone'] = phone;
    _data['website'] = website;
    _data['page_status'] = pageStatus;
    _data['status_verify'] = statusVerify;
    _data['avatar_thumb_pattern'] = avatarThumbPattern;
    _data['cover_thumb_pattern'] = coverThumbPattern;
    return _data;
  }
}

class Group {
  Group({
    required this.id,
    required this.alias,
    required this.name,
    required this.description,
    required this.privacy,
    required this.blocked,
    required this.cover,
    required this.coverThumbPattern,
  });

  late final String id;
  late final String alias;
  late final String name;
  late final String description;
  late final int privacy;
  late final bool blocked;
  late final String cover;
  late final String coverThumbPattern;

  Group.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    alias = json['alias'];
    name = json['name'];
    description = json['description'];
    privacy = json['privacy'];
    blocked = json['blocked'];
    cover = json['cover'];
    coverThumbPattern = json['cover_thumb_pattern'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['alias'] = alias;
    _data['name'] = name;
    _data['description'] = description;
    _data['privacy'] = privacy;
    _data['blocked'] = blocked;
    _data['cover'] = cover;
    _data['cover_thumb_pattern'] = coverThumbPattern;
    return _data;
  }
}
