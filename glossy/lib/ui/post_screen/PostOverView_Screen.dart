import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../res/Color.dart';
import '../../component/TagSelectSheet.dart';
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
  String? selectedGender;
  final List<String> genders = ['メンズ', 'レディース'];

  String? usedItemName; // 使用したアイテム
  String? usedItemImage; // 使用したアイテムの画像パス

  @override
  Widget build(BuildContext context) {
    print(
      'PostOverView received ${widget.selectedMediaList.length} items: ${widget.selectedMediaList.map((e) => e.id).toList()}',
    );
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
            onTap: () {},
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

              // UseItemScreen から選択結果を受け取り表示する
              Row(
                children: [
                  // 選択済みアイテムがあればサムネ・名前を表示
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
                                child: Image.asset(
                                  usedItemImage!,
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) => Container(
                                    width: 44,
                                    height: 44,
                                    color: Colors.grey[300],
                                  ),
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
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    const Expanded(child: SizedBox()),

                  const SizedBox(width: 8),

                  // 追加／編集ボタン（タップで選択画面へ）
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push<Map<String, String>?>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const UseItemScreen(),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          usedItemName = result['name'];
                          usedItemImage = result['image'];
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
              // ここで性別ドロップダウンを表示
              Text('性別', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              SizedBox(
                width: 200, // 横幅を小さくしたい場合はここを調整
                height: 40, // 高さを小さくする
                child: DropdownButtonFormField<String>(
                  value: selectedGender,
                  decoration: InputDecoration(
                    isDense: true, // 小さめの高さに寄せる
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
                  hint: const Text('選択してください', style: TextStyle(fontSize: 13)),
                  items: genders
                      .map(
                        (g) => DropdownMenuItem<String>(
                          value: g,
                          child: Text(g, style: const TextStyle(fontSize: 13)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                  // 見た目を小さくする調整
                  iconSize: 18,
                  style: const TextStyle(fontSize: 13, color: Colors.black),
                  elevation: 2,
                  dropdownColor: Colors.white,
                  menuMaxHeight: 200,
                ),
              ),

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
              const SizedBox(height: 5),
              const Text("予約URL"),
              TextField(decoration: const InputDecoration(hintText: "")),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}
