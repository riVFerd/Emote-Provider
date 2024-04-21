import 'dart:io';

import 'package:dc_universal_emot/domain/entities/emoji.dart';
import 'package:flutter/material.dart';

class EmojiCard extends StatelessWidget {
  final Emoji emoji;
  final double height;
  final double width;
  final VoidCallback? onTap;

  const EmojiCard({
    super.key,
    required this.emoji,
    this.height = 68,
    this.width = 68,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isHovered = ValueNotifier<bool>(false);

    return MouseRegion(
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: ValueListenableBuilder(
        valueListenable: isHovered,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: height,
            width: width,
            padding: const EdgeInsets.all(8),
            child: Image.file(
              File(emoji.emojiPath),
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
