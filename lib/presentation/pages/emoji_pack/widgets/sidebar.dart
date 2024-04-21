import 'dart:io';

import 'package:dc_universal_emot/common/widget_extention.dart';
import 'package:dc_universal_emot/constants/color_constant.dart';
import 'package:dc_universal_emot/presentation/bloc/emoji_pack_bloc.dart';
import 'package:dc_universal_emot/presentation/pages/emoji_pack/emoji_pack_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'add_emoji_pack_dialog.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: 80,
      decoration: BoxDecoration(
        color: darkGray200,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Expanded(
            child: BlocBuilder<EmojiPackBloc, EmojiPackState>(builder: (_, state) {
              return ListView.separated(
                itemCount: state.emojiPacks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, index) {
                  final emojiPack = state.emojiPacks[index];
                  return InkWell(
                    onTap: () => context.read<EmojiPackProvider>().setSelectedEmojiPackIndex(index),
                    child: Consumer<EmojiPackProvider>(
                      child: Image.file(
                        File(emojiPack.emojiPath),
                      ),
                      builder: (_, state, child) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: darkGray100,
                            borderRadius: BorderRadius.circular(
                              state.selectedEmojiPackIndex == index ? 8 : 32,
                            ),
                          ),
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: child,
                        );
                      },
                    ),
                  );
                },
              );
            }),
          ),
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return const AddEmojiPackDialog();
                  });
              // context.read<EmojiPackBloc>().add(const AddEmojiPack());
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: darkGray200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(Icons.add, color: Colors.white),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              context.read<EmojiPackBloc>().add(const DeleteAllEmojiPack());
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: darkGray200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(Icons.delete_forever_rounded, color: Colors.white),
              ),
            ),
          ),
        ].addSeparator(
          separator: const SizedBox(height: 16),
        ),
      ),
    );
  }
}
