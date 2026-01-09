import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glossy/res/Color.dart';

class HomeScreen extends StatefulWidget{
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen>{


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
          //タブ切り替え
          physics: BouncingScrollPhysics(),
          children: [
            LadiesTab(),
            FollowingTab(),
            MensTab(),
          ]
        ),
      ),
    );
  }
}
class LadiesTab extends StatefulWidget{
  State<LadiesTab> createState() => _LadiesTabState();
}
class _LadiesTabState extends State<LadiesTab>{
  @override
  Widget build(BuildContext context){
    return Center(  
      child: Text("レディースタブ"),
    );
  }
}
class FollowingTab extends StatefulWidget{
  State<FollowingTab> createState() => _FollowingTabState();
}
class _FollowingTabState extends State<FollowingTab>{
  @override
  Widget build(BuildContext context){
    return Center(  
      child: Text("フォロー中タブ"),
    );
  }
}
class MensTab extends StatefulWidget{
  State<MensTab> createState() => _MensTabState();
}
class _MensTabState extends State<MensTab>{
  @override
  Widget build(BuildContext context){
    return Center(
      child: Text("メンズ"),
    );
  }
}
      