/// Forked from https://github.com/santa112358/detectable_text_field/blob/main/lib/detector/sample_regular_expressions.dart

const _symbols = '·・ー_';

const _numbers = '0-9０-９';

const _englishLetters = 'a-zA-Zａ-ｚＡ-Ｚ';

const _japaneseLetters = 'ぁ-んァ-ン一-龠';

const _koreanLetters = '\u1100-\u11FF\uAC00-\uD7A3';

const _spanishLetters = 'áàãâéêíóôõúüçÁÀÃÂÉÊÍÓÔÕÚÜÇ';

const _arabicLetters = '\u0621-\u064A';

const _thaiLetters = '\u0E00-\u0E7F';

const _vietNamLetters = 'áàảạãâấầẩẫậăắằẳậẫêếềểễệôốồổỗộơớờởỡợíìỉĩịýỳỷỹỵúùủũụ';

// support các kí tự nguyên âm đặc biệt khi mention như: @toàn, nếu ko có sẽ chỉ nhận @to
const _detectionContentLetters = _symbols +
    _numbers +
    _englishLetters +
    _japaneseLetters +
    _koreanLetters +
    _spanishLetters +
    _arabicLetters +
    _thaiLetters +
    _vietNamLetters;

const _urlRegexContent = "((http|https)://)(www.)?" +
    "[a-zA-Z0-9@:%._\\+~#?&//=]" +
    "{2,256}\\.[a-z]" +
    "{2,6}\\b([-a-zA-Z0-9@:%" +
    "._\\+~#?&//=]*)";

final _regExp = RegExp(
  "(?!\\n)(?:^|\\s)([#@]([$_detectionContentLetters]+))|$_urlRegexContent|${Pattern.phonePattern}|${Pattern.emailPattern}",
  multiLine: true,
);

final _regExpWithoutHashTag = RegExp(
  "(?!\\n)(?:^|\\s)([@]([$_detectionContentLetters]+))|$_urlRegexContent|${Pattern.phonePattern}|${Pattern.emailPattern}",
  multiLine: true,
);

RegExp gpDetectionRegExp({bool includeHashTag = true}) {
  if (!includeHashTag) {
    return _regExpWithoutHashTag;
  }
  return _regExp;
}

final hashTagRegExp = RegExp(
  "(?!\\n)(?:^|\\s)(#([$_detectionContentLetters]+))",
  multiLine: true,
);

final atSignRegExp = RegExp(
  "(?!\\n)(?:^|\\s)([@]([$_detectionContentLetters]+))",
  multiLine: true,
);

final urlRegex = RegExp(
  _urlRegexContent,
  multiLine: true,
);

class Pattern {
  static const String phonePattern = "^(\\+\\d{1,2}\\s)?\\(?\\d{2,4}\\)?[-\\.]? *\\d{2,4}[-\\.]? *[-\\.]?\\d{2,4}";
  // pattern cũ sẽ bị sai trong trường hợp text chưa url dạng: gapo.vn/1234567890
      // "\\(?\\d{2,4}\\)?[-\\.]? *\\d{2,4}[-\\.]? *[-\\.]?\\d{2,4}";

  static const String emailPattern =
      "([a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\\.[a-zA-Z0-9_-]+)";

  // Maybe needed
  // static String basicDateTime =
  //     r'^\d{4}-\d{2}-\d{2}[ T]\d{2}:\d{2}:\d{2}.\d{3}Z?$';

  // static const String github =
  //     r'((git|ssh|http(s)?)|(git@[\w\.]+))(:(\/\/)?)([\w\.@\:/\-~]+)(\.git)(\/)?';

  // // /// Image regex
  // static String image = r'.(jpeg|jpg|gif|png|bmp)$';

  // // /// Audio regex
  // static String audio = r'.(mp3|wav|wma|amr|ogg)$';

  // // /// Video regex
  // static String video = r'.(mp4|avi|wmv|rmvb|mpg|mpeg|3gp)$';

  // // /// Txt regex
  // static String txt = r'.txt$';

  // // /// Document regex
  // static String doc = r'.(doc|docx)$';

  // // /// Excel regex
  // static String excel = r'.(xls|xlsx)$';

  // // /// PPT regex
  // static String ppt = r'.(ppt|pptx)$';

  // // /// Document regex
  // static String apk = r'.apk$';

  // // /// PDF regex
  // static String pdf = r'.pdf$';

  // // /// HTML regex
  // static String html = r'.html$';

  static String filePattern =
      '([$_detectionContentLetters\\s_\\.\\-\\(\\):])+($_fileExtension)'; //a-zA-Z0-9

  static const String _fileExtension =
      '.doc|.docx|.pdf|.txt|.apk|.excel|.xls|.xlsx|.html|.mp4|.avi|.wmv|.rmvb|.mpg|.mpeg|.3gp|.mp3|.wav|.wma|.amr|.ogg|.jpeg|.jpg|.gif|.png|.bmp';
}
