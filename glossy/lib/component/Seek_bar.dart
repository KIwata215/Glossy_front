import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class TikTokProgressBar extends StatelessWidget {
  final VideoPlayerController controller;

  const TikTokProgressBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) return const SizedBox();

    final duration = controller.value.duration;
    final position = controller.value.position;

    final progress = duration.inMilliseconds == 0
        ? 0.0
        : position.inMilliseconds / duration.inMilliseconds;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) {
        final box = context.findRenderObject() as RenderBox;
        final dx = details.localPosition.dx;
        final width = box.size.width;

        final relative = dx / width;
        final seekTo = duration * relative;
        controller.seekTo(seekTo);
      },
      onHorizontalDragUpdate: (details) {
        final box = context.findRenderObject() as RenderBox;
        final dx = details.localPosition.dx;
        final width = box.size.width;
        final relative = dx / width;
        final seekTo = duration * relative;
        controller.seekTo(seekTo);
      },
      child: SizedBox(
        height: 6, // タップ判定用（見た目は細い）
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              height: 2,
              color: Colors.white.withOpacity(0.3),
            ),
            FractionallySizedBox(
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                height: 2,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}