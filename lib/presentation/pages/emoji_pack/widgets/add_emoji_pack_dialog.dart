import 'dart:io';

import 'package:dc_universal_emot/common/widget_extention.dart';
import 'package:dc_universal_emot/data/models/emoji/emoji_hive_model.dart';
import 'package:dc_universal_emot/data/models/emoji_pack/emoji_pack_hive_model.dart';
import 'package:dc_universal_emot/domain/entities/emoji_pack.dart';
import 'package:dc_universal_emot/presentation/bloc/emoji_pack/emoji_pack_bloc.dart';
import 'package:dc_universal_emot/presentation/widgets/add_pack_dialog.dart';
import 'package:dc_universal_emot/services/file_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/color_constant.dart';

class AddEmojiPackDialog extends StatefulWidget {
  final EmojiPack? emojiPack;
  final bool isEdit;

  const AddEmojiPackDialog({super.key, this.emojiPack}) : isEdit = emojiPack != null;

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
    if (widget.isEdit) {
      _updateEmojiPack();
    } else {
      _addEmojiPack();
    }
  }

  void _addEmojiPack() {
    context.read<EmojiPackBloc>().add(
          AddEmojiPack(
            EmojiPackHiveModel(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              name: _textController.text,
              emojiPath: _emojiPackImage!.path,
              emojis: _emojiImages.map((emojiImage) {
                return EmojiHiveModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: ':${FileService.getFileName(emojiImage.path)}:',
                  emojiPath: emojiImage.path,
                );
              }).toList(),
            ),
          ),
        );
    Navigator.of(context).pop();
  }

  void _updateEmojiPack() {
    if (widget.emojiPack == null) return;
    context.read<EmojiPackBloc>().add(
          UpdateEmojiPack(
            EmojiPackHiveModel(
              id: widget.emojiPack!.id,
              name: _textController.text,
              emojiPath: _emojiPackImage!.path,
              emojis: _emojiImages.map((emojiImage) {
                return EmojiHiveModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
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
  void initState() {
    if (widget.isEdit) {
      _textController.text = widget.emojiPack!.name;
      _emojiPackImage = File(widget.emojiPack!.emojiPath);
      _emojiImages.addAll(widget.emojiPack!.emojis.map((emoji) => File(emoji.emojiPath)));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.8,
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
              Text(
                widget.isEdit ? 'Edit Emoji Pack' : 'Add Emoji Pack',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              _emojiPackImage == null
                  ? buildPickImageButton(
                      onPressed: () async {
                        final pickedImage = await fileServices.pickSingleImage();
                        if (pickedImage == null) return;
                        setState(() {
                          _emojiPackImage = pickedImage;
                        });
                      },
                    )
                  : buildImage(
                      onIconPressed: () async {
                        final pickedImage = await fileServices.pickSingleImage();
                        if (pickedImage == null) return;
                        setState(() {
                          _emojiPackImage = pickedImage;
                        });
                      },
                      image: _emojiPackImage!,
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
                      buildPickImageButton(
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
                        return buildImage(
                          height: 64,
                          width: 64,
                          image: emojiImage,
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
                child: Text('${widget.isEdit ? 'Update' : 'Add'} Emoji Pack'),
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
}
