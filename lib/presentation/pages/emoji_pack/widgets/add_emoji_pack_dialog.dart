import 'dart:io';

import 'package:dc_universal_emot/common/widget_extention.dart';
import 'package:dc_universal_emot/data/models/emoji/emoji_hive_model.dart';
import 'package:dc_universal_emot/data/models/emoji_pack/emoji_pack_hive_model.dart';
import 'package:dc_universal_emot/presentation/bloc/emoji_pack/emoji_pack_bloc.dart';
import 'package:dc_universal_emot/services/file_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/color_constant.dart';

class AddEmojiPackDialog extends StatefulWidget {
  const AddEmojiPackDialog({super.key});

  @override
  State<AddEmojiPackDialog> createState() => _AddEmojiPackDialogState();
}

class _AddEmojiPackDialogState extends State<AddEmojiPackDialog> {
  final fileServices = FileService();
  final _textController = TextEditingController();
  File? _emojiPackImage;
  final List<File> _emojiImages = [];

  void _onSubmit(BuildContext context) {
    if (_emojiPackImage == null || _emojiImages.isEmpty || _textController.text.isEmpty) return;
    context.read<EmojiPackBloc>().add(
          AddEmojiPack(
            EmojiPackHiveModel(
              name: _textController.text,
              emojiPath: _emojiPackImage!.path,
              emojis: _emojiImages.map((emojiImage) {
                return EmojiHiveModel(
                  name: ':${FileService.getFileName(emojiImage.path)}:',
                  emojiPath: emojiImage.path,
                );
              }).toList(),
            ),
          ),
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16),
          height: 400,
          width: 400,
          decoration: BoxDecoration(
            color: darkGray100,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.white,
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                'Add Emoji Pack',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              _emojiPackImage == null
                  ? _buildPickImageButton(
                      onPressed: () async {
                        final pickedImage = await fileServices.pickSingleImage();
                        if (pickedImage == null) return;
                        setState(() {
                          _emojiPackImage = pickedImage;
                        });
                      },
                    )
                  : _buildEmojiImage(
                      onIconPressed: () async {
                        final pickedImage = await fileServices.pickSingleImage();
                        if (pickedImage == null) return;
                        setState(() {
                          _emojiPackImage = pickedImage;
                        });
                      },
                      emojiImage: _emojiPackImage!,
                      icon: Icons.mode_edit,
                    ),
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  fillColor: darkGray200,
                  filled: true,
                  hintText: 'Emoji Pack Name',
                  hintStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildPickImageButton(
                        height: 64,
                        width: 64,
                        onPressed: () async {
                          final pickedImages = await fileServices.pickImages();
                          if (pickedImages == null) return;
                          setState(() {
                            _emojiImages.addAll(pickedImages);
                          });
                        },
                      ),
                      ..._emojiImages.map((emojiImage) {
                        return _buildEmojiImage(
                          height: 64,
                          width: 64,
                          emojiImage: emojiImage,
                          icon: Icons.delete,
                          onIconPressed: () {
                            setState(() {
                              _emojiImages.remove(emojiImage);
                            });
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => _onSubmit(context),
                child: const Text('Add Emoji Pack'),
              ),
              const SizedBox(height: 8),
            ].addSeparator(
              separator: const SizedBox(height: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPickImageButton({
    double height = 84,
    double width = 84,
    VoidCallback? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: darkGray200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildEmojiImage({
    double height = 84,
    double width = 84,
    required IconData icon,
    required VoidCallback onIconPressed,
    required File emojiImage,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: darkGray200,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(8),
      child: Stack(
        children: [
          Image.file(emojiImage),
          Positioned(
            right: 0,
            top: 0,
            child: InkWell(
              onTap: onIconPressed,
              child: Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: Colors.black,
                    size: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
