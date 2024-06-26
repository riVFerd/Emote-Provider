import 'dart:io';

import 'package:flutter/material.dart';

class EmotCard extends StatelessWidget {
  final String emotPath;
  final double height;
  final double width;
  final VoidCallback? onTap;
  final VoidCallback? onHover;
  final VoidCallback? onHoverOut;

  const EmotCard({
    super.key,
    required this.emotPath,
    this.height = 68,
    this.width = 68,
    this.onTap,
    this.onHover,
    this.onHoverOut,
  });

  @override
  Widget build(BuildContext context) {
    final isHovered = ValueNotifier<bool>(false);

    return MouseRegion(
      onEnter: (_) {
        isHovered.value = true;
        onHover?.call();
      },
      onExit: (_) {
        isHovered.value = false;
        onHoverOut?.call();
      },
      child: ValueListenableBuilder(
        valueListenable: isHovered,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: height,
            width: width,
            padding: const EdgeInsets.all(8),
            child: Image.file(
              File(emotPath),
            ),
          ),
        ),
        builder: (context, value, child) {
          return Material(
            color: isHovered.value ? Colors.white.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            clipBehavior: Clip.antiAlias,
            child: child,
          );
        },
      ),
    );
  }
}
