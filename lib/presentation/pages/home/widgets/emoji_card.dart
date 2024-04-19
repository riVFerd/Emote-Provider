import 'dart:io';

import 'package:dc_universal_emot/constants/color_constant.dart';
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
    final borderRadius = ValueNotifier<double>(32.0);

    return MouseRegion(
      onEnter: (_) {
        borderRadius.value = 8.0;
      },
      onExit: (_) {
        borderRadius.value = 32.0;
      },
      child: ValueListenableBuilder(
        valueListenable: borderRadius,
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
            color: darkGray200,
            borderRadius: BorderRadius.circular(value),
            clipBehavior: Clip.antiAlias,
            child: child,
          );
        },
      ),
    );
  }
}
