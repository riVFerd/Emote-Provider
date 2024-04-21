import 'dart:io';

import 'package:dc_universal_emot/constants/color_constant.dart';
import 'package:dc_universal_emot/domain/entities/sticker_pack.dart';
import 'package:dc_universal_emot/presentation/bloc/sticker_pack/sticker_pack_bloc.dart';
import 'package:dc_universal_emot/presentation/pages/sticker_pack/sticker_pack_provider.dart';
import 'package:dc_universal_emot/presentation/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_sticker_pack_dialog.dart';

class StickerSidebar extends StatelessWidget {
  const StickerSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Sidebar<StickerPack, StickerPackBloc, StickerPackState>(
      titleDeleteDialog: 'Delete All Sticker Packs',
      messageDeleteDialog: 'Are you sure you want to delete all sticker packs?',
      onAdd: () => showDialog(
        context: context,
        builder: (_) => const AddStickerPackDialog(),
      ),
      onDeleteAll: () => context.read<StickerPackBloc>().add(const DeleteAllStickerPack()),
      buildList: (context, state) {
        return ListView.separated(
          itemCount: state.stickerPacks.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, index) {
            final stickerPack = state.stickerPacks[index];
            final isHovered = ValueNotifier(false);
            return InkWell(
              onTap: () => context.read<StickerPackProvider>().setSelectedStickerPackIndex(index),
              child: MouseRegion(
                onEnter: (_) => isHovered.value = true,
                onExit: (_) => isHovered.value = false,
                child: ValueListenableBuilder(
                  valueListenable: isHovered,
                  child: Image.file(
                    File(stickerPack.stickerPath),
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
