import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glossy/component/AppBar.dart';
import 'package:glossy/component/Button.dart';
import 'package:glossy/res/Color.dart';
import 'package:glossy/router/AppRouter.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget{
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen>{
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.customwhite,
          elevation: 0,
          title: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            dividerColor: Colors.transparent,
            indicatorColor:AppColors.customgreen ,
            indicatorWeight: 2.5,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: AppColors.customgreen,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold
            ),
            tabs: [
              Tab(text: "レディース",),
              Tab(text: "フォロー中",),
              Tab(text: "メンズ",),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right:15), // ← 数字で調整
              child: IconButton(
                icon: Icon(Icons.search, color: AppColors.customblack),
                onPressed: () {
                  // 検索処理
                },
              ),
            ),
          ],
        ),
        body:TabBarView(
          physics: const NeverScrollableScrollPhysics(), // 横スワイプ防止（事故防止）
          children: [
            GenrePage(
              genreName: 'レディース',
              videoPaths: [
                'assets/video/sample1_ledies.mp4',
                'assets/video/sample2_ledies.mp4',
                'assets/video/sample3_ledies.mp4',
                'assets/video/sample4_ledies.mp4',
                'assets/video/sample5_ledies.mp4',
              ],
            ),
            GenrePage(
              genreName: 'フォロー中',
              videoPaths: [
                'assets/video/sample4_ledies.mp4',
                'assets/video/sample2.mp4',
                'assets/video/sample1_ledies.mp4',
                'assets/video/sample2_ledies.mp4',
                'assets/video/sample1.mp4',
                'assets/video/sample3_ledies.mp4',
                'assets/video/sample5_ledies.mp4',
              ],
            ),
            GenrePage(
              genreName: 'メンズ',
              videoPaths: [
                'assets/video/sample1.mp4',
                'assets/video/sample2.mp4',
                'assets/video/sample3.mp4',
              ],
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBarCustom(
          selectedIndex: _selectedIndex,
          onTap: (index) {
            AppRouter.navigate(context, _selectedIndex, index);
            setState(() => _selectedIndex = index);
          },
        )
      ),
    );
  }
}

class GenrePage extends StatefulWidget {
  final List<String> videoPaths; // 動画ファイルのパスリスト
  final String genreName; // レディース / メンズ など

  const GenrePage({
    super.key,
    required this.videoPaths,
    required this.genreName,
  });

  @override
  State<GenrePage> createState() => _GenrePageState();
}

class _GenrePageState extends State<GenrePage> {
  late final PageController _pageController;
  int _currentIndex = 0;
  final List<VideoPlayerController> _videoControllers = [];
  bool _videosInitialized = false;
  bool _isSeeking = false;
  // _isDisposed フラグ
  // dispose後の非同期処理を完全遮断
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initVideos();
  }

  Future<void> _initVideos() async {
    for (final path in widget.videoPaths) {
      if (_isDisposed) return;

      final controller = VideoPlayerController.asset(path)..setLooping(true);

      try {
        await controller.initialize();
      } catch (_) {
        continue;
      }

      if (_isDisposed) {
        controller.dispose();
        return;
      }

      controller.addListener(() {
        if (!_isDisposed && mounted && !_isSeeking) {
          setState(() {});
        }
      });

      _videoControllers.add(controller);
    }

    if (_isDisposed) return;

    if (_videoControllers.isNotEmpty &&
        _videoControllers[0].value.isInitialized) {
      await _videoControllers[0].play();
    }

    if (mounted) setState(() => _videosInitialized = true);
  }

  @override
  void dispose() {
    _isDisposed = true;
    for (final c in _videoControllers) {
      c.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) async {
    if (_isDisposed || _videoControllers.isEmpty) return;

    final prev = _videoControllers[_currentIndex];
    if (prev.value.isInitialized) {
      await prev.pause();
    }

    _currentIndex = index;

    final next = _videoControllers[_currentIndex];
    if (!_isDisposed && next.value.isInitialized) {
      await next.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: widget.videoPaths.length,
      onPageChanged: _onPageChanged,
      itemBuilder: (context, index) {
        if (!_videosInitialized || index >= _videoControllers.length) {
          return const Center(child: CircularProgressIndicator());
        }

        final controller = _videoControllers[index];

        if (!controller.value.isInitialized) {
          return const Center(child: CircularProgressIndicator());
        }

        final duration = controller.value.duration;
        final position = controller.value.position;
        final isPlaying = controller.value.isPlaying;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            // タップで再生/一時停止切替
            if (controller.value.isPlaying) {
              controller.pause();
            } else {
              if (!controller.value.isInitialized) await controller.initialize();
              controller.play();
            }
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
              if (!isPlaying)
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
                bottom: 50.h,
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
              // 下部に再生コントロールとシークバー
              Positioned(
                left: 8.w,
                right: 8.w,
                bottom: 1.h,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                            color: Colors.white,
                            size: 36.h,
                          ),
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            if (isPlaying) {
                              controller.pause();
                            } else {
                              controller.play();
                            }
                            if (mounted) setState(() {});
                          },
                        ),

                        Text(
                          '${_formatDuration(position)} / ${_formatDuration(duration)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    // シークバー
                    Slider(
                      activeColor: Colors.white,
                      inactiveColor: Colors.white38,
                      min: 0,
                      max: duration!.inMilliseconds.toDouble().clamp(1.0, double.infinity),
                      value: position!.inMilliseconds.toDouble().clamp(0.0, duration.inMilliseconds.toDouble()),
                      onChangeStart: (_) {
                        _isSeeking = true;
                      },
                      onChanged: (value) async {
                        // シークバーを動かしたときのUI更新のみ（実際の移動はonChangeEndで行う）
                        if (mounted) setState(() {});
                      },
                      onChangeEnd: (value) async {
                        final pos = Duration(milliseconds: value.toInt());
                        await controller.seekTo(pos);
                        _isSeeking = false;
                        if (mounted) setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDuration(Duration? d) {
    if (d == null) return '00:00';
    final twoDigits = (int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
