import 'package:dc_universal_emot/common/widget_extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/color_constant.dart';

class Sidebar<T, B extends BlocBase<S>, S> extends StatelessWidget {
  final String titleDeleteDialog;
  final String messageDeleteDialog;
  final VoidCallback onAdd;
  final VoidCallback onDeleteAll;
  final Widget Function(BuildContext, S) buildList;
  final bool Function(S, S)? buildWhen;

  const Sidebar({
    super.key,
    required this.titleDeleteDialog,
    required this.messageDeleteDialog,
    required this.buildList,
    required this.onAdd,
    required this.onDeleteAll,
    this.buildWhen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: 80,
      decoration: const BoxDecoration(
        color: darkGray200,
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Expanded(
            child: BlocBuilder<B, S>(
              buildWhen: buildWhen,
              builder: (_, state) => buildList(context, state),
            ),
          ),
          _buildButton(context, Icons.add, onAdd),
          _buildButton(context, Icons.delete_forever, () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                backgroundColor: darkGray200,
                surfaceTintColor: darkGray200,
                content: Text(
                  messageDeleteDialog,
                  style: const TextStyle(color: Colors.white),
                ),
                title: Text(
                  titleDeleteDialog,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      onDeleteAll();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Delete All',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          }),
        ].addSeparator(
          separator: const SizedBox(height: 16),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: darkGray200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}
