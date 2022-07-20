import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

// function call khi widget thay đổi size
typedef OnWidgetSizeChange = void Function(Size size);

/// Tạo 1 widget với callback [OnWidgetSizeChange], khi widget thay đổi size, widget sẽ được call
class MeasureSizeWidget extends SingleChildRenderObjectWidget {
  final OnWidgetSizeChange onChange;

  const MeasureSizeWidget({
    Key? key,
    required this.onChange,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _MeasureSizeRenderObject(onChange);
  }
}

class _MeasureSizeRenderObject extends RenderProxyBox {
  Size oldSize = Size.zero;
  final OnWidgetSizeChange onChange;

  _MeasureSizeRenderObject(this.onChange);

  @override
  void performLayout() {
    super.performLayout();

    Size? newSize = child?.size;
    if (oldSize == newSize || newSize == null) return;

    oldSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChange(newSize);
    });
  }
}
