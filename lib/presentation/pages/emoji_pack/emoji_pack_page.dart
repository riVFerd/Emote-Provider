import 'package:dc_universal_emot/constants/color_constant.dart';
import 'package:dc_universal_emot/data/repositories/emoji_pack_hive_repository.dart';
import 'package:dc_universal_emot/presentation/pages/emoji_pack/emoji_pack_provider.dart';
import 'package:dc_universal_emot/presentation/pages/emoji_pack/widgets/emoji_card.dart';
import 'package:dc_universal_emot/presentation/pages/emoji_pack/widgets/sidebar.dart';
import 'package:dc_universal_emot/services/clipboard_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:window_manager/window_manager.dart';

import '../../bloc/emoji_pack_bloc.dart';

class EmojiPackPage extends StatefulWidget {
  const EmojiPackPage({super.key});

  @override
  State<EmojiPackPage> createState() => _EmojiPackPageState();
}

class _EmojiPackPageState extends State<EmojiPackPage> {
  @override
  void initState() {
    EmojiPackHiveRepository.init(
      onInitialized: () {
        context.read<EmojiPackBloc>().add(const LoadEmojiPacks());
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkGray100,
      body: Row(
        children: [
          const Sidebar(),
          Expanded(
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: BlocBuilder<EmojiPackBloc, EmojiPackState>(builder: (_, state) {
                return ListView.builder(
                  controller: context.read<EmojiPackProvider>().scrollController,
                  itemCount: state.emojiPacks.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (_, index) {
                    return AutoScrollTag(
                      controller: context.read<EmojiPackProvider>().scrollController,
                      index: index,
                      key: ValueKey(index),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              state.emojiPacks[index].name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: state.emojiPacks[index].emojis.map((emoji) {
                              return EmojiCard(
                                onTap: () async {
                                  await ClipboardService.writeImage(emoji.emojiPath);
                                  await windowManager.hide();
                                  ClipboardService.simulatePaste();
                                },
                                emoji: emoji,
                                height: 68,
                                width: 68,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
