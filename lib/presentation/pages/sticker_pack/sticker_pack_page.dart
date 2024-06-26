import 'package:context_menus/context_menus.dart';
import 'package:dc_universal_emot/constants/color_constant.dart';
import 'package:dc_universal_emot/data/repositories/sticker_pack_hive_repository.dart';
import 'package:dc_universal_emot/domain/entities/sticker.dart';
import 'package:dc_universal_emot/presentation/pages/sticker_pack/sticker_pack_provider.dart';
import 'package:dc_universal_emot/presentation/pages/sticker_pack/widgets/sticker_sidebar.dart';
import 'package:dc_universal_emot/presentation/widgets/app_loading.dart';
import 'package:dc_universal_emot/presentation/widgets/emot_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../bloc/sticker_pack/sticker_pack_bloc.dart';

class StickerPackPage extends StatefulWidget {
  const StickerPackPage({super.key});

  @override
  State<StickerPackPage> createState() => _StickerPackPageState();
}

class _StickerPackPageState extends State<StickerPackPage> {
  final _selectedSticker = ValueNotifier<Sticker?>(null);

  @override
  void initState() {
    StickerPackHiveRepository.init(
      onInitialized: () {
        context.read<StickerPackBloc>().add(const LoadStickerPacks());
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            const StickerSidebar(),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildMainPage(context),
                  Container(
                    color: darkGray150,
                    height: 46,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.centerLeft,
                    child: ValueListenableBuilder(
                      valueListenable: _selectedSticker,
                      builder: (_, emoji, __) {
                        return Text(
                          emoji?.name ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        BlocBuilder<StickerPackBloc, StickerPackState>(
          builder: (_, state) {
            if (state is! StickerPackLoading) return const SizedBox();
            return AppLoading(
              progress: state.progress,
              message: 'Loading Sticker Pack...',
            );
          },
        ),
      ],
    );
  }

  Expanded buildMainPage(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: BlocBuilder<StickerPackBloc, StickerPackState>(
          builder: (_, state) {
            return ListView.builder(
              controller: context.read<StickerPackProvider>().scrollController,
              itemCount: state.stickerPacks.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (_, index) {
                return AutoScrollTag(
                  controller: context.read<StickerPackProvider>().scrollController,
                  index: index,
                  key: ValueKey(index),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          state.stickerPacks[index].name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: state.stickerPacks[index].stickers.map((sticker) {
                          return ContextMenuRegion(
                            contextMenu: TextButton(
                              onPressed: () async {
                                try {
                                  context
                                      .read<StickerPackProvider>()
                                      .pasteSticker(sticker.originalPath, context: context);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Failed, the original file is missing.'),
                                    ),
                                  );
                                }
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Send Original Image'),
                            ),
                            child: EmotCard(
                              onHover: () {
                                _selectedSticker.value = sticker;
                              },
                              onTap: () async {
                                context
                                    .read<StickerPackProvider>()
                                    .pasteSticker(sticker.stickerPath);
                              },
                              emotPath: sticker.stickerPath,
                              height: 68,
                              width: 68,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
