import 'package:flutter/material.dart';
import 'package:gp_mention/theme/colors.dart';

class Section extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const Section({
    Key? key,
    required this.child,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: GPColor.bgPrimary,
      ),
      child: child,
    );
  }
}
