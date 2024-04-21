import 'package:dc_universal_emot/common/widget_extention.dart';
import 'package:flutter/material.dart';

/// A widget that shows a loading screen with a progress bar.
/// Ideally used with [Stack] to overlay the loading screen on top of the main content.
class AppLoading extends StatelessWidget {
  final double progress;
  final String message;
  const AppLoading({super.key, required this.progress, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.black.withOpacity(0.5),
      padding: const EdgeInsets.all(16),
      child: Center(
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              LinearProgressIndicator(
                value: progress,
              ),
            ].addSeparator(
              separator: const SizedBox(height: 16),
            ),
          ),
        ),
      ),
    );
  }
}
