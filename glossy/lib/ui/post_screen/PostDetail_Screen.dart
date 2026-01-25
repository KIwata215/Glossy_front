import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart'; // ← 追加

import '../../component/PostHeader.dart';
import '../../component/AppBar.dart';
import '../../res/Color.dart';
import '../home_screen/Home_Screen.dart';

class PostDetailScreen extends StatefulWidget {
  final String hairstyleId;

  const PostDetailScreen({super.key, required this.hairstyleId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

// 動画プレイヤーウィジェット（assets動画対応）
class _VideoPlayerWidget extends StatefulWidget {
  final String assetPath;
  const _VideoPlayerWidget({required this.assetPath});

  @override
  State<_VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<_VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.assetPath)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
  }
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  Map<String, dynamic>? postData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPostDetail();
  }

  Future<void> fetchPostDetail() async {
    try {
      final response = await http.get(
        Uri.parse("http://192.168.0.7:3000/hairstyle/${widget.hairstyleId}"),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['success'] == true) {
          setState(() {
            postData = json;
            isLoading = false;
          });
        } else {
          print("投稿データ取得失敗: success=false");
          setState(() => isLoading = false);
        }
      } else {
        print("投稿データ取得失敗: ${response.statusCode}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("投稿データ取得エラー: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            PostHeader(
              titleText: "投稿詳細",
              rightText: "",
              textColor: AppColors.customblack,
              onLeftTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => HomeScreen()),
                );
              },
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : postData == null
                  ? const Center(child: Text("データが取得できませんでした"))
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ① 動画表示（assets対応）
                          SizedBox(
                            height: 420,
                            child: Center(
                              // ← ここで中央寄せ
                              child:
                                  postData!['video_url'] != null &&
                                      postData!['video_url'].isNotEmpty
                                  ? _VideoPlayerWidget(
                                      assetPath: postData!['video_url'],
                                    )
                                  : Container(color: Colors.black),
                            ),
                          ),

                          const SizedBox(height: 12),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              postData!['description'] ?? '',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),

                          const SizedBox(height: 12),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Wrap(
                              spacing: 8,
                              children: (() {
                                final tags = postData?['tags'];
                                if (tags is List) {
                                  return tags.map<Widget>((tag) {
                                    return Chip(
                                      // Textより見やすく
                                      label: Text(tag.toString()),
                                      backgroundColor: Colors.blue.shade50,
                                    );
                                  }).toList();
                                } else {
                                  return <Widget>[];
                                }
                              })(),
                            ),
                          ),

                          const SizedBox(height: 20),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: List.generate(
                                5,
                                (index) => Icon(
                                  Icons.star,
                                  color: index < (postData!['difficulty'] ?? 0)
                                      ? Colors.amber
                                      : Colors.grey[300],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: const Text(
                              "使用したアイテム",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // ② Firebase tools データ表示
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child:
                                (postData!['usedItems'] as List<dynamic>?)
                                        ?.isNotEmpty ??
                                    false
                                ? SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children:
                                          (postData!['usedItems']
                                                  as List<dynamic>)
                                              .map((it) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        right: 12,
                                                      ),
                                                  child: _itemBox(
                                                    it['name'] ?? '',
                                                    "¥${it['money'] ?? 0}",
                                                    imagePath: it['image'],
                                                  ),
                                                );
                                              })
                                              .toList(),
                                    ),
                                  )
                                : const Center(child: Text("使用したアイテムはありません")),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBarCustom(
        selectedIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomeScreen()),
            );
          }
        },
      ),
    );
  }

  Widget _itemBox(String name, String price, {String? imagePath}) {
    Widget thumb;

    if (imagePath != null && imagePath.isNotEmpty) {
      thumb = imagePath.startsWith('assets/')
          ? Image.asset(imagePath, width: 60, height: 60, fit: BoxFit.cover)
          : Image.network(imagePath, width: 60, height: 60, fit: BoxFit.cover);
    } else {
      thumb = Container(width: 60, height: 60, color: Colors.grey[300]);
    }

    return Column(
      children: [
        ClipRRect(borderRadius: BorderRadius.circular(6), child: thumb),
        const SizedBox(height: 4),
        SizedBox(
          width: 60,
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
        ),
        Text(price, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}
