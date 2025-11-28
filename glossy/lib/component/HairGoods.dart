import 'package:flutter/material.dart';

class HairGoodsSelector extends StatefulWidget {
  final Function(int)? onSelected;
  final int initialIndex;

  const HairGoodsSelector({
    Key? key,
    this.onSelected,
    this.initialIndex = 2, // 初期はスタイリング剤
  }) : super(key: key);

  @override
  State<HairGoodsSelector> createState() => _HairGoodsSelectorState();
}

class _HairGoodsSelectorState extends State<HairGoodsSelector> {
  final List<String> items = [
    'ヘアケア',
    'ヘアーアイロン',
    'スタイリング剤',
    'ドライヤー',
    'その他',
  ];

  late int selectedIndex;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    // 初期表示時に「スタイリング剤」の場合のみ中央にスクロール
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (selectedIndex == 2) {
        _scrollToCenter(selectedIndex);
      }
    });
  }

  void _scrollToCenter(int index) {
    // 各アイテムの幅を計算
    List<double> itemWidths = List.generate(items.length, (i) {
      final style = TextStyle(
        fontSize: i == index ? 16 : 13,
        fontWeight: i == index ? FontWeight.w800 : FontWeight.w400,
      );
      final painter = TextPainter(
        text: TextSpan(text: items[i], style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout();
      return painter.width + 16; // padding分
    });

    const double separatorWidth = 10.0;
    const double horizontalPadding = 16.0 * 2;
    double screenWidth = MediaQuery.of(context).size.width;

    // 選択中のindexまでの合計幅を計算
    double offset = 0;
    for (int i = 0; i < index; i++) {
      offset += itemWidths[i] + separatorWidth;
    }
    // 選択中のアイテムの半分を足す
    offset += itemWidths[index] / 2;
    // 画面中央に来るように調整
    offset -= (screenWidth - horizontalPadding) / 2;
    if (offset < 0) offset = 0;

    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _scrollToEdgeIfNeeded(int index) {
    // 先頭を選択した場合は左端に、末尾を選択した場合は右端にスクロール
    if (index == 0) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else if (index == items.length - 1) {
      // 「その他」選択時は右端ピッタリ
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else if (index == 2) {
      // スタイリング剤は中央
      _scrollToCenter(index);
    } else if (index == 1) {
      // ヘアーアイロン選択時はヘアケアが左端に来るように
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else if (index == 3) {
      // ドライヤー選択時は「その他」が右端に来るように
      List<double> itemWidths = List.generate(items.length, (i) {
        final style = TextStyle(
          fontSize: i == index ? 16 : 13,
          fontWeight: i == index ? FontWeight.w800 : FontWeight.w400,
        );
        final painter = TextPainter(
          text: TextSpan(text: items[i], style: style),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout();
        return painter.width + 16;
      });
      const double separatorWidth = 10.0;
      const double horizontalPadding = 16.0 * 2;
      double screenWidth = MediaQuery.of(context).size.width;

      // 全アイテムの合計幅
      double totalWidth = 0;
      for (int i = 0; i < items.length; i++) {
        totalWidth += itemWidths[i];
        if (i != items.length - 1) totalWidth += separatorWidth;
      }
      // その他（index=4）が右端に来るようにoffsetを計算
      double offset = totalWidth - screenWidth + horizontalPadding;
      if (offset < 0) offset = 0;
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      // それ以外は左端に前の項目が見えるように
      List<double> itemWidths = List.generate(items.length, (i) {
        final style = TextStyle(
          fontSize: i == index ? 16 : 13,
          fontWeight: i == index ? FontWeight.w800 : FontWeight.w400,
        );
        final painter = TextPainter(
          text: TextSpan(text: items[i], style: style),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout();
        return painter.width + 16;
      });
      const double separatorWidth = 10.0;
      double offset = 0;
      for (int i = 0; i < index; i++) {
        offset += itemWidths[i] + separatorWidth;
      }
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 48,
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final bool isSelected = selectedIndex == index;
              final text = items[index];
              final textStyle = TextStyle(
                fontSize: isSelected ? 16 : 13,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w400,
                color: const Color(0xFF1C331D),
              );

              // テキスト幅を計算（下線の長さ用）
              final textPainter = TextPainter(
                text: TextSpan(text: text, style: textStyle),
                maxLines: 1,
                textDirection: TextDirection.ltr,
              )..layout();

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                  _scrollToEdgeIfNeeded(index);
                  if (widget.onSelected != null) {
                    widget.onSelected!(index);
                  }
                },
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 40,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textStyle,
                      ),
                      if (isSelected)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          height: 2,
                          width: textPainter.width,
                          color: const Color(0xFF1C331D),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '???件',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF1C331D),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Row(
                children: const [
                  Icon(
                    Icons.sort, // 並び替えアイコン
                    size: 18,
                    color: Color(0xFF1C331D),
                  ),
                  SizedBox(width: 4),
                  Text(
                    '人気順',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF1C331D),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}