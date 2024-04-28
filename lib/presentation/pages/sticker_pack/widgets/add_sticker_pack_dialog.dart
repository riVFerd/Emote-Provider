import 'dart:io';

import 'package:dc_universal_emot/common/widget_extention.dart';
import 'package:dc_universal_emot/data/models/sticker/sticker_hive_model.dart';
import 'package:dc_universal_emot/data/models/sticker_pack/sticker_pack_hive_model.dart';
import 'package:dc_universal_emot/presentation/bloc/sticker_pack/sticker_pack_bloc.dart';
import 'package:dc_universal_emot/presentation/widgets/add_pack_dialog.dart';
import 'package:dc_universal_emot/services/file_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/color_constant.dart';

class AddStickerPackDialog extends StatefulWidget {
  const AddStickerPackDialog({super.key});

  @override
  State<AddStickerPackDialog> createState() => _AddStickerPackDialogState();
}

class _AddStickerPackDialogState extends State<AddStickerPackDialog> {
  final fileServices = FileService();
  final _textController = TextEditingController();
  File? _stickerPackImage;
  final List<File> _stickerImages = [];

  void _onSubmit(BuildContext context) {
    if (_stickerPackImage == null || _stickerImages.isEmpty || _textController.text.isEmpty) return;
    context.read<StickerPackBloc>().add(
          AddStickerPack(
            StickerPackHiveModel(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              name: _textController.text,
              stickerPath: _stickerPackImage!.path,
              stickers: _stickerImages.map((stickerImage) {
                return StickerHiveModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: ':${FileService.getFileName(stickerImage.path)}:',
                  stickerPath: stickerImage.path,
                  originalPath: stickerImage.path,
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
                'Add Sticker Pack',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              _stickerPackImage == null
                  ? buildPickImageButton(
                      onPressed: () async {
                        final pickedImage = await fileServices.pickSingleImage();
                        if (pickedImage == null) return;
                        setState(() {
                          _stickerPackImage = pickedImage;
                        });
                      },
                    )
                  : buildImage(
                      onIconPressed: () async {
                        final pickedImage = await fileServices.pickSingleImage();
                        if (pickedImage == null) return;
                        setState(() {
                          _stickerPackImage = pickedImage;
                        });
                      },
                      image: _stickerPackImage!,
                      icon: Icons.mode_edit,
                    ),
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  fillColor: darkGray200,
                  filled: true,
                  hintText: 'Sticker Pack Name',
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
                            _stickerImages.addAll(pickedImages);
                          });
                        },
                      ),
                      ..._stickerImages.map((stickerImage) {
                        return buildImage(
                          height: 64,
                          width: 64,
                          image: stickerImage,
                          icon: Icons.delete,
                          onIconPressed: () {
                            setState(() {
                              _stickerImages.remove(stickerImage);
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
                child: const Text('Add Sticker Pack'),
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
