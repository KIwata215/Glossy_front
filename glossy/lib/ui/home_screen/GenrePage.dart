import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glossy/component/Button.dart';
import 'package:glossy/component/Seek_bar.dart';
import 'package:glossy/models/video_post.dart';
import 'package:video_player/video_player.dart';


class GenrePage extends StatefulWidget {
  final List<Post> posts;
  final String genreName;
  const GenrePage({
    super.key,
    required this.posts,
    required this.genreName,
  });

  @override
  State<GenrePage> createState() => _GenrePageState();
}

class _GenrePageState extends State<GenrePage> {
  late final PageController _pageController;
  final List<VideoPlayerController> _controllers = [];
  int _currentIndex = 0;
  bool _videosInitialized = false;
  bool _isSeeking = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initVideos();
  }

  Future<void> _initVideos() async {
    for (final post in widget.posts) {
      if (_isDisposed) return;
      final controller = VideoPlayerController.asset(post.videoPath)..setLooping(true);
      
      try{
        await controller.initialize();
      } catch (_) {
        continue;
      }
      if (_isDisposed) {
        controller.dispose();
        return;
      }
      controller.addListener((){
        if (!_isDisposed && mounted && !_isSeeking) {
          setState(() {});
        }
      });
      _controllers.add(controller);
    }
    if (_controllers.isNotEmpty &&
        _controllers.first.value.isInitialized) {
      await _controllers.first.play();
    }

    if (mounted) setState(() => _videosInitialized = true);
  }

  @override
  void dispose() {
    _isDisposed = true;
    for (final c in _controllers) {
      c.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }
  void _onPageChanged(int index) async {
    if (_isDisposed || _controllers.isEmpty) return;

    final prev = _controllers[_currentIndex];
    if (prev.value.isInitialized) {
      await prev.pause();
    }

    _currentIndex = index;

    final next = _controllers[_currentIndex];
    if (!_isDisposed && next.value.isInitialized) {
      await next.play();
    }
  }
  @override
  Widget build(BuildContext context) {
    if (!_videosInitialized ||
      _controllers.length != widget.posts.length) {
        return const Center(child: CircularProgressIndicator());
      }
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: widget.posts.length,
      onPageChanged: _onPageChanged,
      itemBuilder: (context, index) {
        final post = widget.posts[index];
        final controller = _controllers[index];
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            controller.value.isPlaying
                ? controller.pause()
                : controller.play();
            if (mounted) setState(() {});
          },
          child: Stack(
            children: [
              // 背景を黒色に
              Container(
                color: const Color.fromARGB(255, 0, 0, 0),
                child: Center(
                  child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: VideoPlayer(controller),
                  ),
                ),
              ),
              // 中央に一時停止アイコンを表示（停止中のみ）
              if (!controller.value.isPlaying)
                Center(
                  child: Icon(
                    Icons.play_circle_fill,
                    size: 72,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              // 右下インジケータ
              Positioned(
                right: 10.w,
                bottom: 1.h,
                child: Column(
                  children: [
                    Account_Button(
                      onPressed: (){
                      // アカウントボタンの処理
                      }
                    ),
                    LikeButton(
                      onPressed: (){
                        // いいねボタンの処理
                      }
                    ),
                    Comment_Button(
                      onPressed: (){
                        // コメントボタンの処理
                      }
                    ),
                    Save_Button(
                      onPressed: (){
                        // 保存ボタンの処理
                      }
                    ),
                    Share_Button(
                      onPressed: (){
                        // シェアボタンの処理
                      }
                    ),
                  ],
                ),
              ),
              /// 左下：ユーザー + 説明
              Positioned(
                left: 20.w,
                bottom: 40.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '@${post.userName}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      post.description,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              // 下部に再生コントロールとシークバー
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: TikTokProgressBar(controller: controller),
              ),
            ],
          ),
        );
      },
    );
  }
}