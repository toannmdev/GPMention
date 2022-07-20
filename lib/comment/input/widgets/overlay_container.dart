import 'package:flutter/material.dart';

/// /// Hiển thị view dạng overlay đè lên các widget khác
/// ```
///             OverlayContainer(
///               show: true/false,
///               position: OverlayContainerPosition(
///                 // Left position.
///                 150,
///                 // Bottom position.
///                 45,
///               ),
///               child: Text("Test"),
///             );
/// ```
class OverlayContainer extends StatefulWidget {
  final Widget child;

  final OverlayContainerPosition position;

  final bool show;

  final bool asWideAsParent;

  final Color bgColor;

  const OverlayContainer({
    Key? key,
    required this.show,
    required this.child,
    this.asWideAsParent = false,
    this.position = const OverlayContainerPosition(0.0, 0.0),
    this.bgColor = Colors.transparent,
  }) : super(key: key);

  @override
  OverlayContainerState createState() => OverlayContainerState();
}

class OverlayContainerState extends State<OverlayContainer>
    with WidgetsBindingObserver {
  OverlayEntry? _overlayEntry;
  bool _opened = false;

  @override
  void initState() {
    super.initState();
    if (widget.show) {
      _show();
    }
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    if (widget.show) {
      _show();
    } else {
      _hide();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.show) {
      _show();
    } else {
      _hide();
    }
  }

  @override
  void didUpdateWidget(OverlayContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show) {
      _show();
    } else {
      _hide();
    }
  }

  @override
  void dispose() {
    if (widget.show) {
      _hide();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _show() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 100));
      if (_opened) {
        _overlayEntry?.remove();
      }
      if (mounted) {
        Overlay.of(context)?.insert(_overlayEntry = _buildOverlayEntry());
      }
      _opened = true;
    });
  }

  void _hide() {
    if (_opened) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _overlayEntry?.remove();
        _opened = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context);
    return Container();
  }

  OverlayEntry _buildOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) {
        return Positioned(
          left: offset.dx + widget.position.left,
          top: offset.dy - widget.position.bottom,
          width: widget.asWideAsParent ? size.width : null,
          child: Material(
            color: widget.bgColor,
            child: widget.child,
          ),
        );
      },
    );
  }
}

class OverlayContainerPosition {
  final double left;
  final double bottom;

  const OverlayContainerPosition(this.left, this.bottom);
}
