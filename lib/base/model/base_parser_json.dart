import 'package:gp_mention/model/assignee.dart';

mixin GPParserJson {
  static Map<Type, Function> _mapFactories<T>() {
    return <Type, Function>{
      T: (Map<String, dynamic> x) => _mapFactoryValue<T>(x),
    };
  }

  static dynamic _mapFactoryValue<T>(Map<String, dynamic> x) {
    // parse all items here
    switch (T) {
      case Assignee:
        return Assignee.fromJson(x);
      default:
        throw Exception("ApiResponseExtension _mapFactoryValue error!!!");
    }
  }

  static T parseJson<T>(Map<String, dynamic> x) =>
      _mapFactories<T>()[T]?.call(x);
}
