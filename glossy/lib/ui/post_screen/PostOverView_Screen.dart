import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
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
  int difficulty = 0; // 星の数
  List<String> selectedTags = ["#ストレート"];
  String? selectedGender;
  final List<String> genders = ['メンズ', 'レディース'];

  // UseItemScreen から返される複数選択アイテム ( { 'name':..., 'image':... } )
  List<Map<String, String>> usedItems = [];

  @override
  Widget build(BuildContext context) {
    // デバッグ用受け取り確認
    print(
      'PostOverView received ${widget.selectedMediaList.length} items: ${widget.selectedMediaList.map((e) => e.id).toList()}',
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "新規投稿",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              final String? itemName = usedItems.isNotEmpty
                  ? usedItems[0]['name']
                  : null;
              final String? itemImage = usedItems.isNotEmpty
                  ? usedItems[0]['image']
                  : null;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PostDetailScreen(
                    mediaList: widget.selectedMediaList,
                    description: descriptionController.text,
                    difficulty: difficulty,
                    tags: selectedTags,
                    usedItems: usedItems,
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

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ① 横スワイプ可能な画像・動画一覧
                SizedBox(
                  height: 200,
                  child: widget.selectedMediaList.isEmpty
                      ? Container(
                          color: Colors.grey[200],
                          child: const Center(child: Text('選択された画像がありません')),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.selectedMediaList.length,
                          itemBuilder: (context, index) {
                            final media = widget.selectedMediaList[index];
                            return FutureBuilder<Uint8List?>(
                              future: media.thumbnailDataWithSize(
                                const ThumbnailSize(500, 500),
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState !=
                                        ConnectionState.done ||
                                    snapshot.data == null) {
                                  return Container(
                                    width: 200,
                                    height: 200,
                                    color: Colors.grey,
                                  );
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.memory(
                                          snapshot.data!,
                                          width: 200,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        ),
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

                // ③ 使用したアイテム見出し
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

                // UseItemScreen から選択結果（複数）を受け取り表示：+ を左に、選択サムネを右へ
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // + ボタン（左寄せ）
                    GestureDetector(
                      onTap: () async {
                        final result =
                            await Navigator.push<List<Map<String, String>>?>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const UseItemScreen(),
                              ),
                            );
                        if (result != null) {
                          setState(() {
                            usedItems = result;
                          });
                        }
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.add, color: Colors.black),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // 選択アイテム群（ボタン右側、横スクロール）
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            if (usedItems.isEmpty)
                              Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[200],
                              )
                            else
                              ...usedItems.map((it) {
                                final img = it['image'] ?? '';
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: img.startsWith('assets/images/')
                                        ? Image.asset(
                                            img,
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                            errorBuilder: (c, e, s) =>
                                                Container(
                                                  width: 60,
                                                  height: 60,
                                                  color: Colors.grey[300],
                                                ),
                                          )
                                        : Image.file(
                                            File(img),
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                );
                              }).toList(),
                          ],
                        ),
                      ),
                    ),
                  ],
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
                const SizedBox(height: 12),

                // 性別ドロップダウン
                Text('性別', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                SizedBox(
                  width: 200,
                  height: 40,
                  child: DropdownButtonFormField<String>(
                    value: selectedGender,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    hint: const Text(
                      '選択してください',
                      style: TextStyle(fontSize: 13),
                    ),
                    items: genders
                        .map(
                          (g) => DropdownMenuItem<String>(
                            value: g,
                            child: Text(
                              g,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
                      });
                    },
                    iconSize: 18,
                    style: const TextStyle(fontSize: 13, color: Colors.black),
                    elevation: 2,
                    dropdownColor: Colors.white,
                    menuMaxHeight: 200,
                  ),
                ),

                const SizedBox(height: 20),

                // タグ追加
                const Text("タグを追加", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    ...selectedTags.map(
                      (tag) => Chip(
                        label: Text(tag),
                        backgroundColor: Colors.blue[50],
                      ),
                    ),
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

                // 場所・URL
                const Text("場所を追加"),
                TextField(decoration: const InputDecoration(hintText: "")),
                const SizedBox(height: 5),
                const Text("予約URL"),
                TextField(decoration: const InputDecoration(hintText: "")),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
