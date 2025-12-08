import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../component/PostHeader.dart';
import '../../res/Color.dart'; // AppColors
import 'PostOverView_Screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<AssetEntity> mediaList = []; // スマホ内のアルバムリスト
  AssetEntity? selectedMedia; // 選択された画像or動画

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
        if (mediaList.isNotEmpty) {
          selectedMedia = mediaList.first;
        }
      });
    } else {
      PhotoManager.openSetting();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PostHeader(
        // ← const を削除
        backgroundColor: AppColors.customblack,
        titleText: "新規投稿",
        rightText: "次へ",
        textColor: AppColors.custompurple,
        onRightTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PostOverViewScreen(
                selectedMediaList: mediaList, // ← 複数画像を送る
              ),
            ),
          );
        },
      ),

      body: Column(
        children: [
          // ① プレビュー（画像 or 動画サムネ）
          Container(
            color: AppColors.customblack,
            height: 300,
            width: double.infinity,
            child: selectedMedia == null
                ? const Center(child: CircularProgressIndicator())
                : FutureBuilder(
                    future: selectedMedia!.thumbnailDataWithSize(
                      const ThumbnailSize(800, 800),
                    ),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return Stack(
                        children: [
                          Image.memory(snapshot.data!, fit: BoxFit.cover),

                          // 動画の場合「再生アイコン」を表示
                          if (selectedMedia!.type == AssetType.video)
                            const Positioned(
                              bottom: 16,
                              right: 16,
                              child: Icon(
                                Icons.play_circle_fill,
                                size: 42,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
          ),

          // 区切り線
          Container(height: 2, color: const Color(0xFFC0C0C0)),

          // ② ギャラリー一覧（画像＋動画）
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(4),
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: mediaList.length + 1, // カメラアイコン追加
              itemBuilder: (context, index) {
                if (index == 0) {
                  // カメラアイコン
                  return Container(
                    color: AppColors.customblack,
                    child: const Icon(Icons.camera_alt, size: 28),
                  );
                }

                final media = mediaList[index - 1];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedMedia = media;
                    });
                  },
                  child: FutureBuilder(
                    future: media.thumbnailDataWithSize(
                      const ThumbnailSize(200, 200),
                    ),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(color: Colors.grey);
                      }

                      return Stack(
                        children: [
                          Image.memory(snapshot.data!, fit: BoxFit.cover),

                          // 動画には右下に再生マーク
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
