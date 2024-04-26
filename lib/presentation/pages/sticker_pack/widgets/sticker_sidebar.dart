import 'dart:io';

import 'package:context_menus/context_menus.dart';
import 'package:dc_universal_emot/app.dart';
import 'package:dc_universal_emot/constants/color_constant.dart';
import 'package:dc_universal_emot/domain/entities/sticker_pack.dart';
import 'package:dc_universal_emot/presentation/bloc/sticker_pack/sticker_pack_bloc.dart';
import 'package:dc_universal_emot/presentation/pages/sticker_pack/sticker_pack_provider.dart';
import 'package:dc_universal_emot/presentation/widgets/context_menu_button.dart';
import 'package:dc_universal_emot/presentation/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:info_popup/info_popup.dart';

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
      buildWhen: (_, current) => !(current is StickerPackLoaded && current.isSearching),
      buildList: (context, state) {
        return ListView.separated(
          itemCount: state.stickerPacks.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, index) {
            final stickerPack = state.stickerPacks[index];
            final isHovered = ValueNotifier(false);
            return ContextMenuRegion(
              contextMenu: AppContextMenuButton(
                text: 'Delete ${stickerPack.name} Sticker Pack',
                onPressed: () {
                  // TODO: give a confirmation dialog before deleting
                  context.read<StickerPackBloc>().add(DeleteStickerPack(stickerPack));
                  context.contextMenuOverlay.hide();
                },
              ),
              child: InfoPopupWidget(
                contentTitle: stickerPack.name,
                arrowTheme: const InfoPopupArrowTheme(
                  color: darkGray100,
                ),
                contentTheme: const InfoPopupContentTheme(
                  infoContainerBackgroundColor: darkGray100,
                  infoTextStyle: TextStyle(color: Colors.white),
                ),
                child: InkWell(
                  onTap: () {
                    final currentState = context.read<StickerPackBloc>().state;
                    if (currentState is StickerPackLoaded && currentState.isSearching) {
                      context.read<AppProvider>().clearSearch();
                      context.read<StickerPackBloc>().add(const LoadStickerPacks());
                    }
                    context.read<StickerPackProvider>().setSelectedStickerPackIndex(index);
                  },
                  child: MouseRegion(
                    onEnter: (_) => isHovered.value = true,
                    onExit: (_) => isHovered.value = false,
                    child: ValueListenableBuilder(
                      valueListenable: isHovered,
                      child: Image.file(
                        File(stickerPack.stickerPath),
                        height: 32,
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
                ),
              ),
            );
          },
        );
      },
    );
  }
}
