import 'package:dc_universal_emot/constants/color_constant.dart';
import 'package:dc_universal_emot/data/repositories/emoji_pack_hive_repository.dart';
import 'package:dc_universal_emot/presentation/pages/home/widgets/emoji_card.dart';
import 'package:dc_universal_emot/presentation/pages/home/widgets/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/emoji_pack_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                  itemCount: state.emojiPacks.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (_, index) {
                    return Column(
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
                              onTap: () {},
                              emoji: emoji,
                              height: 68,
                              width: 68,
                            );
                          }).toList(),
                        ),
                      ],
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
