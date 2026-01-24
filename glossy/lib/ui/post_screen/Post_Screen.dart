import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../component/PostHeader.dart';
import '../../res/Color.dart'; // AppColors
import 'PostOverView_Screen.dart';
import '../home_screen/Home_Screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<AssetEntity> mediaList = []; // スマホ内のアルバムリスト
  List<AssetEntity> selectedMediaList = [];
  AssetEntity? selectedMedia;

  AssetEntity? get previewMedia =>
      selectedMediaList.isNotEmpty ? selectedMediaList.first : null;

  @override
  void initState() {
    super.initState();
    loadMedia();
  }

  // スマホから画像＋動画を取得
  Future<void> loadMedia() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();

    if (ps.isAuth) {
      // 全メディア（画像＋動画）取得
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        onlyAll: true,
        type: RequestType.all, // ← ★ここが重要
      );

      // 全メディアデータを取得
      List<AssetEntity> media = await albums[0].getAssetListPaged(
        page: 0,
        size: 200,
      );

      setState(() {
        mediaList = media;
        // 初期選択を空のままにする（必要なら最初の1枚を選択する）
        selectedMediaList = [];
      });
    } else {
      PhotoManager.openSetting();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          bottom: false,
          child: PostHeader(
            backgroundColor: AppColors.customblack,
            titleText: "新規投稿",
            rightText: "次へ",
            leftIconColor: AppColors.custompurple,
            textColor: AppColors.custompurple,
            onRightTap: () {
              // Navigator 実行前に渡す内容をログ
              print(
                'navigating with ${selectedMediaList.length} items: ${selectedMediaList.map((e) => e.id).toList()}',
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PostOverViewScreen(
                    selectedMediaList: selectedMediaList, // ← 複数画像を送る
                  ),
                ),
              );
            },
            onLeftTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen()),
              );
            },
          ),
        ),
      ),

      body: Column(
        children: [
          // ① プレビュー
          Container(
            color: Colors.black,
            width: double.infinity,
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: selectedMedia == null
                  ? const Center(child: CircularProgressIndicator())
                  : FutureBuilder(
                      future: selectedMedia!.thumbnailDataWithSize(
                        const ThumbnailSize(1000, 1000),
                      ),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.memory(snapshot.data!, fit: BoxFit.cover),

                            if (selectedMedia!.type == AssetType.video)
                              const Center(
                                child: Icon(
                                  Icons.play_circle_fill,
                                  size: 64,
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        );
                      },
                    ),
            ),
          ),

          // ② 黒余白
          Container(height: 8, color: Colors.black),

          // ③ グリッド
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
              ),
              itemCount: mediaList.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    color: Colors.black,
                    child: const Icon(Icons.camera_alt, color: Colors.white),
                  );
                }

                final media = mediaList[index - 1];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      final existsIndex = selectedMediaList.indexWhere(
                        (e) => e.id == media.id,
                      );
                      if (existsIndex >= 0) {
                        // すでに選択済み → 解除
                        selectedMediaList.removeAt(existsIndex);
                        if (selectedMedia?.id == media.id) {
                          selectedMedia = selectedMediaList.isNotEmpty
                              ? selectedMediaList.first
                              : null;
                        }
                      } else {
                        // 未選択 → 追加
                        selectedMediaList.add(media);
                        selectedMedia = media;
                      }
                    });

                    // デバッグ出力：選択数と選択中のID一覧
                    print(
                      'selectedMediaList.length = ${selectedMediaList.length}',
                    );
                    print(
                      'selected ids = ${selectedMediaList.map((e) => e.id).toList()}',
                    );
                  },
                  child: FutureBuilder(
                    future: media.thumbnailDataWithSize(
                      const ThumbnailSize(300, 300),
                    ),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(color: Colors.black);
                      }

                      final isSelected = selectedMediaList.any(
                        (e) => e.id == media.id,
                      );

                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.memory(snapshot.data!, fit: BoxFit.cover),

                          // 選択中オーバーレイ（選択時に薄いマスク）
                          if (isSelected) Container(color: Colors.black26),

                          // 選択順を右上に表示
                          if (isSelected)
                            Positioned(
                              top: 6,
                              right: 6,
                              child: CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.purple,
                                child: Text(
                                  '${selectedMediaList.indexWhere((e) => e.id == media.id) + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),

                          if (media.type == AssetType.video)
                            const Positioned(
                              right: 4,
                              bottom: 4,
                              child: Icon(
                                Icons.play_circle_fill,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
