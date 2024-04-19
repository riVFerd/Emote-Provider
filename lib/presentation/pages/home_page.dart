import 'dart:io';

import 'package:dc_universal_emot/data/repositories/emoji_pack_hive_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/emoji_pack_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    EmojiPackHiveRepository.init(
      onInitialized: () {
        context.read<EmojiPackBloc>().add(const LoadEmojiPacks());
      },
    );
    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  context.read<EmojiPackBloc>().add(const AddEmojiPack());
                },
                child: Text('Add Emoji Pack'),
              ),
              TextButton(
                onPressed: () {
                  context.read<EmojiPackBloc>().add(const DeleteAllEmojiPack());
                },
                child: Text('Remove All Emoji Pack'),
              ),
              Text('Emoji Pack:'),
              BlocBuilder<EmojiPackBloc, EmojiPackState>(
                builder: (context, state) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.emojiPacks.length,
                      itemBuilder: (context, index) {
                        final emojiPack = state.emojiPacks[index];
                        return ListTile(
                          title: Text(emojiPack.name),
                          subtitle: Row(
                            children: [
                              for (final emoji in emojiPack.emojis)
                                Image.file(
                                  File(emoji.emojiPath),
                                  width: 50,
                                  height: 50,
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
