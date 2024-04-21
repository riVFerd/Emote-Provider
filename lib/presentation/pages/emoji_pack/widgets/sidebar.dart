import 'dart:io';

import 'package:dc_universal_emot/common/widget_extention.dart';
import 'package:dc_universal_emot/constants/color_constant.dart';
import 'package:dc_universal_emot/presentation/bloc/emoji_pack_bloc.dart';
import 'package:dc_universal_emot/presentation/pages/emoji_pack/emoji_pack_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                          }),
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
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    backgroundColor: darkGray200,
                    surfaceTintColor: darkGray200,
                    content: const Text(
                      'Are you sure you want to delete all emoji packs?',
                      style: TextStyle(color: Colors.white),
                    ),
                    title: const Text(
                      'Delete All Emoji Packs',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<EmojiPackBloc>().add(const DeleteAllEmojiPack());
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Delete All',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );
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
