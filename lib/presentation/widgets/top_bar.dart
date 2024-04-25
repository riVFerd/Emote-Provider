import 'package:dc_universal_emot/app.dart';
import 'package:dc_universal_emot/common/widget_extention.dart';
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              buildTabButton(
                onTap: () => context.read<AppProvider>().setCurrentTab(TabMode.emoji),
                title: 'Emoji',
                tabMode: TabMode.emoji,
              ),
              buildTabButton(
                onTap: () => context.read<AppProvider>().setCurrentTab(TabMode.sticker),
                title: 'Sticker',
                tabMode: TabMode.sticker,
              ),
            ].addSeparator(
              separator: const SizedBox(width: 8),
            ),
          ),
          buildTabButton(
            onTap: () => context.read<AppProvider>().setCurrentTab(TabMode.settings),
            title: 'Settings',
            tabMode: TabMode.settings,
          ),
        ].addSeparator(
          separator: const SizedBox(width: 8),
        ),
      ),
    );
  }

  Consumer<AppProvider> buildTabButton({
    required String title,
    required VoidCallback onTap,
    required TabMode tabMode,
  }) {
    return Consumer<AppProvider>(builder: (_, state, child) {
      return Material(
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(4),
        color: state.currentTab == tabMode ? Colors.white.withOpacity(0.2) : Colors.transparent,
        child: InkWell(
          onTap: onTap,
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
