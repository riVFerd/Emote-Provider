import 'dart:io';

import 'package:dc_universal_emot/constants/color_constant.dart';
import 'package:dc_universal_emot/domain/entities/emoji_pack.dart';
import 'package:dc_universal_emot/presentation/bloc/emoji_pack/emoji_pack_bloc.dart';
import 'package:dc_universal_emot/presentation/pages/emoji_pack/emoji_pack_provider.dart';
import 'package:dc_universal_emot/presentation/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_emoji_pack_dialog.dart';

class EmojiSidebar extends StatelessWidget {
  const EmojiSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Sidebar<EmojiPack, EmojiPackBloc, EmojiPackState>(
      titleDeleteDialog: 'Delete All Emoji Packs',
      messageDeleteDialog: 'Are you sure you want to delete all emoji packs?',
      onAdd: () => showDialog(
        context: context,
        builder: (_) => const AddEmojiPackDialog(),
      ),
      onDeleteAll: () => context.read<EmojiPackBloc>().add(const DeleteAllEmojiPack()),
      buildList: (context, state) {
        // DUPLICATE CODE with StickerSidebar
        // TODO: Implement the buildList function with more reusable code
        return ListView.separated(
          itemCount: state.emojiPacks.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, index) {
            final emojiPack = state.emojiPacks[index];
            final isHovered = ValueNotifier(false);
            return InkWell(
              onTap: () => context.read<EmojiPackProvider>().setSelectedEmojiPackIndex(index),
              child: MouseRegion(
                onEnter: (_) => isHovered.value = true,
                onExit: (_) => isHovered.value = false,
                child: ValueListenableBuilder(
                  valueListenable: isHovered,
                  child: Image.file(
                    File(emojiPack.emojiPath),
                  ),
                  builder: (_, isHovered, child) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: darkGray100,
                        borderRadius: BorderRadius.circular(
                          isHovered ? 8 : 32,
                        ),
                      ),
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: child,
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
