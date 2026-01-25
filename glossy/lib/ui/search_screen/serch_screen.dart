import 'package:flutter/material.dart';
import 'package:glossy/component/SearchBar.dart' as glossy;
import 'package:glossy/component/AppBar.dart';
import 'package:glossy/component/Search_images_grid.dart';
import 'package:glossy/component/TagSelectSheet.dart';
import 'package:glossy/router/AppRouter.dart';
import 'package:glossy/ui/post_screen/PostDetail_Screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _currentKeyword = '';

  // true: 男, false: 女
  bool isMaleSelected = true;

  int selectedIndex = 1; // 検索画面なので初期値は1

  // assets/images/thumbnail 内の実際にある3枚だけ
  final List<String> imageUrls = [
    'assets/images/thumbnail/スクリーンショット 2026-01-26 3.25.38.png',
    'assets/images/thumbnail/スクリーンショット 2026-01-26 3.26.55.png',
    'assets/images/thumbnail/スクリーンショット 2026-01-26 3.27.53.png',
  ];

  void _showTagSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => TagSelect_Sheet(
        onTagSelected: (tag) {
          // タグ選択時の処理をここに記述
        },
      ),
    );
  }

  void _executeSearch() {
    final keyword = _searchController.text;

    debugPrint('検索キーワード: $keyword');
    debugPrint('性別: ${isMaleSelected ? '男' : '女'}');

    // 🔽 ここで画像リストを絞り込む or API / Firestore
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    '/search_history',
                  );

                  if (result != null && result is String) {
                    setState(() {
                      _currentKeyword = result;
                      _searchController.text = result;
                    });

                    _executeSearch();
                  }
                },

                child: AbsorbPointer(
                  // TextFieldの編集を無効化（タップのみ反応）
                  child: glossy.SearchBar(controller: _searchController),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.black),
              onPressed: _showTagSheet,
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 男性（トイレ標識アイコン）
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isMaleSelected = true;
                    });
                  },
                  child: Icon(
                    Icons.man,
                    size: 40,
                    color: isMaleSelected
                        ? const Color(0xFF2547DC)
                        : const Color(0xFF949494),
                  ),
                ),
                const SizedBox(width: 64),
                // 女性（トイレ標識アイコン）
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isMaleSelected = false;
                    });
                  },
                  child: Icon(
                    Icons.woman,
                    size: 40,
                    color: !isMaleSelected
                        ? const Color(0xFFE33629)
                        : const Color(0xFF949494),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(thickness: 1, color: Color(0xFF949494), height: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SearchImagesGrid(
                imageUrls: imageUrls,
                onImageTap: (index) {
                  // タップした画像に応じて投稿IDを渡す
                  String selectedId;
                  switch (index) {
                    case 0:
                      selectedId = 'ID1';
                      break;
                    case 1:
                      selectedId = 'ID2';
                      break;
                    case 2:
                      selectedId = 'h6rDmfDFpr02XE60nlsU'; // 遷移したい画像
                      break;
                    default:
                      selectedId = 'ID_DEFAULT';
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PostDetailScreen(hairstyleId: selectedId),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: BottomAppBarCustom(
          selectedIndex: 1,
          onTap: (index) {
            AppRouter.navigate(context, 1, index);
          },
        ),
      ),
    );
  }
}
