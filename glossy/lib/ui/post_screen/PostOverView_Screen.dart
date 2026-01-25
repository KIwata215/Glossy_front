import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../res/Color.dart';
import '../../component/TagSelectSheet.dart';
import 'UseItemScreen.dart';
import 'PostDetail_Screen.dart';

class PostOverViewScreen extends StatefulWidget {
  final List<AssetEntity> selectedMediaList;

  const PostOverViewScreen({super.key, required this.selectedMediaList});

  @override
  State<PostOverViewScreen> createState() => _PostOverViewScreenState();
}

class _PostOverViewScreenState extends State<PostOverViewScreen> {
  final TextEditingController descriptionController = TextEditingController();
  int difficulty = 0;
  List<String> selectedTags = [];
  String? selectedGender;
  final List<String> genders = ['メンズ', 'レディース'];

  String? usedItemName;
  String? usedItemImage;
  int? usedItemPrice;

  bool isPosting = false;

  /// -----------------------------
  /// 投稿処理
  /// -----------------------------
  Future<void> _post() async {
    if (isPosting) return;
    setState(() => isPosting = true);

    // String videoName = "";
    // final first = widget.selectedMediaList.first;
    // if (first.type == AssetType.video) {
    //   videoName = '${first.id}.mp4'; // 動画ファイル名
    // }

    final body = {
      "user_id": "test_user_id",
      "description": descriptionController.text,
      //"video_url": "Glossy_front/glossy/assets/video/$videoName",
      "video_url": "assets/video/001.mp4",
      "difficulty": difficulty,
      "tools_url": usedItemImage != null ? [usedItemImage] : [],
      "tools_bland": usedItemName != null ? [usedItemName] : [],
      "tools_money": usedItemPrice != null ? [usedItemPrice] : [],
      "gender_cd": selectedGender == null ? null : selectedGender == 'メンズ',
      "tag": selectedTags,
    };

    // デバッグ用に送信データを出力
    print("===== 投稿データ =====");
    print(body);
    print("====================");

    try {
      final response = await http.post(
        Uri.parse("http://192.168.0.7:3000/hairstyles"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final json = jsonDecode(response.body);

        // サーバー返却の hairstyle_id を取得
        final String hairstyleId = json["hairstyle_id"] ?? "";
        if (hairstyleId.isEmpty) {
          print("投稿成功したけど hairstyle_id が空です");
          setState(() => isPosting = false);
          return;
        }
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PostDetailScreen(
              hairstyleId: hairstyleId, // 必須引数に渡す
            ),
          ),
        );
      } else {
        print("投稿失敗: ${response.body}");
      }
    } catch (e) {
      print("投稿エラー: $e");
    }

    if (!mounted) return;
    setState(() => isPosting = false);
  }

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
            onTap: _post,
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
              /// ① メディア一覧
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

              /// ② 概要
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

              /// ③ 使用したアイテム
              const Text(
                "使用したアイテム",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 8),

              // 使用したアイテム表示
              Row(
                children: [
                  if (usedItemName != null)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            if (usedItemImage != null &&
                                usedItemImage!.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  usedItemImage!,
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.cover,
                                ),
                              )
                            else
                              Container(
                                width: 44,
                                height: 44,
                                color: Colors.grey[300],
                              ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                usedItemName!,
                                style: const TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "¥${usedItemPrice ?? 0}",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    const Expanded(child: SizedBox()),

                  const SizedBox(width: 8),

                  // 追加／編集ボタン
                  GestureDetector(
                    onTap: () async {
                      final result =
                          await Navigator.push<Map<String, dynamic>?>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const UseItemScreen(),
                            ),
                          );
                      if (result != null) {
                        setState(() {
                          usedItemName = result["brand"] ?? result["name"];
                          usedItemImage = result["url"] ?? result["image"];

                          // money を int に変換
                          final money = result["money"] ?? result["price"];
                          if (money is String) {
                            usedItemPrice = int.tryParse(money);
                          } else if (money is int) {
                            usedItemPrice = money;
                          } else {
                            usedItemPrice = 0;
                          }
                        });
                      }
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        usedItemName == null ? Icons.add : Icons.edit,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// ④ 難易度
              Row(
                children: [
                  const Text("難易度を選択"),
                  const SizedBox(width: 10),
                  Row(
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () => setState(() => difficulty = index + 1),
                        child: Icon(
                          Icons.star,
                          size: 28,
                          color: index < difficulty
                              ? Colors.amber
                              : Colors.grey[400],
                        ),
                      );
                    }),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// ⑤ 性別
              Text('性別', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              SizedBox(
                width: 200,
                height: 40,
                child: DropdownButtonFormField<String>(
                  value: selectedGender,
                  hint: const Text('選択してください'),
                  items: genders
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (v) => setState(() => selectedGender = v),
                ),
              ),

              const SizedBox(height: 20),

              /// ⑥ タグ
              const Text("タグを追加"),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ...selectedTags.map((tag) => Chip(label: Text(tag))),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => TagSelect_Sheet(
                          onTagSelected: (tag) {
                            setState(() => selectedTags.add(tag));
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

              /// ⑦ 場所・URL
              const Text("場所を追加"),
              TextField(),
              const SizedBox(height: 5),
              const Text("予約URL"),
              TextField(),
            ],
          ),
        ),
      ),
    );
  }
}
