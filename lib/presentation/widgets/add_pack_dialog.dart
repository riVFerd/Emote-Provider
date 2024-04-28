import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../constants/color_constant.dart';

Widget buildPickImageButton({
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

Widget buildImage({
  double height = 84,
  double width = 84,
  required IconData icon,
  required VoidCallback onIconPressed,
  required File image,
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
        Align(
          alignment: Alignment.center,
          child: Image.file(image),
        ),
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
