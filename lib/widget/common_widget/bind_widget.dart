import 'package:flutter/material.dart';

class BindWidget extends StatelessWidget {
  const BindWidget(
      {Key? key, this.padding, this.margin, this.title, required this.child})
      : super(key: key);
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Widget? title;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.zero,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          child,
        ],
      ),
    );
  }
}
