import 'package:flutter/material.dart';
import 'package:glossy/component/SearchBar.dart' as glossy;
import 'package:glossy/component/AppBar.dart';
import 'package:glossy/component/TagSelectSheet.dart';

class SearchHistoryScreen extends StatefulWidget {
  const SearchHistoryScreen({super.key});

  @override
  State<SearchHistoryScreen> createState() => _SearchHistoryScreenState();
}

class _SearchHistoryScreenState extends State<SearchHistoryScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: glossy.SearchBar(
                    onChanged: (value) {},
                    onSubmitted: (value) {
                      Navigator.pop(context, value);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.black),
                  onPressed: _showTagSheet,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Stack(
              children: [
                const Divider(
                  thickness: 1,
                  color: Color(0xFF949494),
                  height: 1,
                ),
                Positioned(
                  left: 0,
                  bottom: -20,
                  child: Text(
                    '検索ランキング',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // 検索ランキング
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              '検索ランキング',
              style: TextStyle(
                fontSize: 26,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('1. スパイキーショート', style: TextStyle(fontSize: 20)),
                SizedBox(height: 4),
                Text('2. グランジパーマ', style: TextStyle(fontSize: 20)),
                SizedBox(height: 4),
                Text('3. フェードスタイル', style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // 検索履歴
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              '検索履歴',
              style: TextStyle(
                fontSize: 26,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
              child: ListView(
                children: [
                  Text('・センターパート', style: TextStyle(fontSize: 20)),
                  Divider(thickness: 1, color: Color(0xFF949494), height: 1),
                  Text('・マッシュ', style: TextStyle(fontSize: 20)),
                  Divider(thickness: 1, color: Color(0xFF949494), height: 1),
                  Text('・ウルフスタイル', style: TextStyle(fontSize: 20)),
                  Divider(thickness: 1, color: Color(0xFF949494), height: 1),
                  Text('・フェードスタイル', style: TextStyle(fontSize: 20)),
                  Divider(thickness: 1, color: Color(0xFF949494), height: 1),
                  Text('・サーフカール', style: TextStyle(fontSize: 20)),
                  Divider(thickness: 1, color: Color(0xFF949494), height: 1),
                  Text('・ダウンパーマ', style: TextStyle(fontSize: 20)),
                  Divider(thickness: 1, color: Color(0xFF949494), height: 1),
                  Text('・スパイキーショート', style: TextStyle(fontSize: 20)),
                  Divider(thickness: 1, color: Color(0xFF949494), height: 1),
                  Text('・ピンパーマスパイキーショート', style: TextStyle(fontSize: 20)),
                  Divider(thickness: 1, color: Color(0xFF949494), height: 1),
                  Text('・グランジパーマ', style: TextStyle(fontSize: 20)),
                  Divider(thickness: 1, color: Color(0xFF949494), height: 1),
                  Text('・スパイラルパーマ', style: TextStyle(fontSize: 20)),
                  Divider(thickness: 1, color: Color(0xFF949494), height: 1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}