import 'package:dc_universal_emot/app.dart';
import 'package:dc_universal_emot/common/widget_extention.dart';
import 'package:dc_universal_emot/presentation/bloc/emoji_pack/emoji_pack_bloc.dart';
import 'package:dc_universal_emot/presentation/bloc/sticker_pack/sticker_pack_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/color_constant.dart';

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: darkGray100,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  buildTabButton(
                    title: 'Emoji',
                    tabMode: TabMode.emoji,
                    context: context,
                  ),
                  buildTabButton(
                    title: 'Sticker',
                    tabMode: TabMode.sticker,
                    context: context,
                  ),
                ].addSeparator(
                  separator: const SizedBox(width: 8),
                ),
              ),
              buildTabButton(
                title: 'Settings',
                tabMode: TabMode.settings,
                context: context,
              ),
            ].addSeparator(
              separator: const SizedBox(width: 8),
            ),
          ),
          Consumer<AppProvider>(builder: (_, provider, __) {
            return TextField(
              controller: provider.searchController,
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                // TODO: consider to use debounce
                if (provider.currentTab == TabMode.emoji) {
                  context.read<EmojiPackBloc>().add(SearchEmojis(value));
                } else {
                  context.read<StickerPackBloc>().add(SearchStickers(value));
                }
              },
              decoration: InputDecoration(
                hintText: 'Search ${provider.currentTab == TabMode.emoji ? 'emoji' : 'sticker'}',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                suffixIcon: Icon(
                  Icons.search,
                  color: Colors.white.withOpacity(0.5),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                isDense: true,
                filled: true,
                fillColor: darkGray200,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ].addSeparator(
          separator: const SizedBox(height: 8),
        ),
      ),
    );
  }

  Consumer<AppProvider> buildTabButton({
    required String title,
    VoidCallback? onTap,
    required TabMode tabMode,
    required BuildContext context,
  }) {
    return Consumer<AppProvider>(builder: (_, state, child) {
      return Material(
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(4),
        color: state.currentTab == tabMode ? Colors.white.withOpacity(0.2) : Colors.transparent,
        child: InkWell(
          onTap: () {
            switch (state.currentTab) {
              case TabMode.emoji:
                context.read<EmojiPackBloc>().add(const LoadEmojiPacks());
              case TabMode.sticker:
                context.read<StickerPackBloc>().add(const LoadStickerPacks());
              case TabMode.settings:
            }
            state.clearSearch();
            state.setCurrentTab(tabMode);
            onTap?.call();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              title,
              style: TextStyle(
                color: state.currentTab == tabMode ? Colors.white : Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    });
  }
}
