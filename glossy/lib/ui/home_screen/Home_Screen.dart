import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glossy/component/AppBar.dart';
import 'package:glossy/res/Color.dart';
import 'package:glossy/router/AppRouter.dart';

class HomeScreen extends StatefulWidget{
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen>{
int _selectedIndex = 0;
  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.customwhite,
          elevation: 0,
          title: TabBar(
            dividerColor: Colors.transparent,
            indicatorColor:AppColors.customgreen ,
            indicatorWeight: 2.5,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: AppColors.customgreen,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold
            ),
            tabs: [
              Tab(text: "レディース",),
              Tab(text: "フォロー中",),
              Tab(text: "メンズ",),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: AppColors.customblack,),
              onPressed: () {
                // 検索アイコンが押されたときの処理
              },
            ),
          ],
        ),
        body:TabBarView(
          physics: const NeverScrollableScrollPhysics(), // 横スワイプ防止（事故防止）
          children: [
            GenrePage(
              genreName: 'レディース',
              colorList: [Colors.pink, Colors.red, Colors.purple],
            ),
            GenrePage(
              genreName: 'フォロー中',
              colorList: [Colors.blue, Colors.lightBlue, Colors.indigo],
            ),
            GenrePage(
              genreName: 'メンズ',
              colorList: [Colors.black, Colors.grey, Colors.brown],
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBarCustom(
          selectedIndex: _selectedIndex,
          onTap: (index) {
            AppRouter.navigate(context, _selectedIndex, index);
            setState(() => _selectedIndex = index);
          },
        )
      ),
    );
  }
}
class GenrePage extends StatefulWidget {
  final List<Color> colorList;
  final String genreName; // レディース / メンズ など

  const GenrePage({
    super.key,
    required this.colorList,
    required this.genreName,
  });

  @override
  State<GenrePage> createState() => _GenrePageState();
}

class _GenrePageState extends State<GenrePage> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: widget.colorList.length,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      itemBuilder: (context, index) {
        return Container(
          color: widget.colorList[index],
          child: SafeArea(
            child: Stack(
              children: [
                /// 中央表示（動画の代わり）
                Center(
                  child: Text(
                    '${widget.genreName}\nVIDEO $index',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                /// 右下インジケータ（TikTokっぽさ）
                Positioned(
                  right: 16,
                  bottom: 32,
                  child: Column(
                    children: [
                      const Icon(Icons.favorite, color: Colors.white),
                      const SizedBox(height: 16),
                      const Icon(Icons.comment, color: Colors.white),
                      const SizedBox(height: 16),
                      const Icon(Icons.bookmark, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
      