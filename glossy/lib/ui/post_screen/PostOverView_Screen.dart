import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../res/Color.dart';
import '../../component/TagSelectSheet.dart';
import 'PostDetail_Screen.dart';
import 'UseItemScreen.dart';

class PostOverViewScreen extends StatefulWidget {
  final List<AssetEntity> selectedMediaList;

  const PostOverViewScreen({super.key, required this.selectedMediaList});

  @override
  State<PostOverViewScreen> createState() => _PostOverViewScreenState();
}

class _PostOverViewScreenState extends State<PostOverViewScreen> {
  final TextEditingController descriptionController = TextEditingController();
  int difficulty = 0; // 星の数
  List<String> selectedTags = ["#ストレート"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          "新規投稿",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PostDetailScreen(
                    mediaList: widget.selectedMediaList,
                    description: descriptionController.text,
                    difficulty: difficulty,
                    tags: selectedTags,
                  ),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  "投稿",
                  style: TextStyle(color: AppColors.customgreen, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ① 横スワイプ可能な画像・動画一覧
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.selectedMediaList.length,
                  itemBuilder: (context, index) {
                    final media = widget.selectedMediaList[index];
                    return FutureBuilder(
                      future: media.thumbnailDataWithSize(
                        const ThumbnailSize(500, 500),
                      ),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container(width: 200, color: Colors.grey);
                        }

                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Stack(
                            children: [
                              Image.memory(
                                snapshot.data!,
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                              if (media.type == AssetType.video)
                                const Positioned(
                                  right: 8,
                                  bottom: 8,
                                  child: Icon(
                                    Icons.play_circle_fill,
                                    size: 32,
                                    color: Colors.white,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // ② 概要を書く（テキストフィールド）
              TextField(
                controller: descriptionController,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "概要を書く...",
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: InputBorder.none,
                ),
              ),

              const SizedBox(height: 12),

              // ③ 使用したアイテム → 遷移
              Row(
                children: [
                  const Text(
                    "使用したアイテム",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UseItemScreen()),
                  );
                },
                child: Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[300],
                  child: const Icon(Icons.add),
                ),
              ),

              const SizedBox(height: 20),

              // ④ 難易度選択 ★（タップで色がつく）
              Row(
                children: [
                  const Text("難易度を選択", style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 10),
                  Row(
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            difficulty = index + 1;
                          });
                        },
                        child: Icon(
                          Icons.star,
                          size: 28,
                          color: (index < difficulty)
                              ? Colors.amber
                              : Colors.grey[400],
                        ),
                      );
                    }),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ⑤ タグ追加
              const Text("タグを追加", style: TextStyle(fontSize: 14)),
              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                children: [
                  // 既存タグ表示
                  ...selectedTags.map(
                    (tag) => Chip(
                      label: Text(tag),
                      backgroundColor: Colors.blue[50],
                    ),
                  ),

                  // ＋ボタン（タグ選択画面を表示）
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        builder: (_) => TagSelect_Sheet(
                          onTagSelected: (tag) {
                            setState(() {
                              selectedTags.add(tag);
                            });
                          },
                        ),
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      color: Colors.grey[300],
                      child: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ⑥ 場所・URL（テキスト入力）
              const Text("場所を追加"),
              TextField(decoration: const InputDecoration(hintText: "")),
              const SizedBox(height: 20),
              const Text("予約URL"),
              TextField(decoration: const InputDecoration(hintText: "")),
            ],
          ),
        ),
      ),
    );
  }
}
