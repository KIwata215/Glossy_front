import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../res/Color.dart';

class TagSelect_Sheet extends StatefulWidget {
  final Function(String) onTagSelected;

  const TagSelect_Sheet({super.key, required this.onTagSelected});

  @override
  State<TagSelect_Sheet> createState() => _TagSelect_SheetState();
}

class _TagSelect_SheetState extends State<TagSelect_Sheet> {
  Map<String, Map<String, bool>> categorizedTags = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTags();
  }

  Future<void> fetchTags() async {
    final url = Uri.parse(
      'http://192.168.0.7:3000/tag/SByu7bVuFiTeWXUNfjmt', // ← 自分のIP
    );

    try {
      final res = await http.get(url);
      final data = json.decode(res.body);

      setState(() {
        categorizedTags = {
          '髪質': _toBoolMap(data['hair_type']),
          'シーン': _toBoolMap(data['scene']),
          '髪の長さ': _toBoolMap(data['man']?['length']),
          'スタイル': _toBoolMap(data['man']?['style']),
        };
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() => isLoading = false);
    }
  }

  Map<String, bool> _toBoolMap(dynamic map) {
    if (map == null) return {};
    return Map<String, bool>.from(map);
  }

  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          const Divider(height: 1),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      shrinkWrap: true,
                      children: categorizedTags.entries
                          .where((e) => e.value.isNotEmpty)
                          .map(
                            (entry) => _buildCategory(entry.key, entry.value),
                          )
                          .toList(),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 中央タイトル（常に真ん中）
          const Text(
            'タグ選択',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          // 左右ボタン
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text(
                  'キャンセル',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  '完了',
                  style: TextStyle(
                    color: AppColors.custompurple,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(String title, Map<String, bool> tags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.customgreen,
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags.entries.map((entry) {
            final tag = entry.key;
            final isEnabled = entry.value;

            return GestureDetector(
              onTap: () {
                widget.onTagSelected(tag);
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: isEnabled ? Colors.grey[300] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isEnabled ? AppColors.customgreen : Colors.grey,
                  ),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: isEnabled ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
