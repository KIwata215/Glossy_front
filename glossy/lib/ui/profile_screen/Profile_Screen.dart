import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glossy/component/AppBar.dart';
import 'package:glossy/res/Color.dart';
import 'package:glossy/router/AppRouter.dart';

class Profile_Screen extends StatefulWidget {
  @override
  State<Profile_Screen> createState() => _Profile_Screen();
}

class _Profile_Screen extends State<Profile_Screen> {
  Future<Map<String, int>>? _countsFuture;
  // グリッド表示切り替え用インデックス
  int _selectedGridIndex = 0;
  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    _countsFuture = fetchProfileCounts(uid);
  }
  Future<int> getCollectionCount({
    required String uid,
    required String subCollection,
  }) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection(subCollection)
        .get();

    return snapshot.size; // 無ければ 0
  }

  Future<Map<String, int>> fetchProfileCounts(String uid) async {
    final followers = getCollectionCount(
      uid: uid,
      subCollection: 'followers',
    );

    final following = getCollectionCount(
      uid: uid,
      subCollection: 'following',
    );

    final results = await Future.wait([followers, following]);

    return {
      'followers': results[0],
      'following': results[1],
    };
  }
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(child: Text('ユーザー情報が見つかりません')),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final username = data['name'] ?? 'No Name';
        final imageUrl = data['icon_url'] as String?;
        return Scaffold(
          backgroundColor: AppColors.customwhite,
          body: CustomScrollView(
            slivers: [
              //プロフィール上部
              SliverAppBar(
                pinned: true, //スクロールしても上に残る
                centerTitle: false,
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.customwhite,
                elevation: 0,
                // 左：ユーザーネーム
                titleSpacing: 12, // 左余白調整
                title: Text(
                  username, // ← Firebaseから取得したname
                  style: const TextStyle(
                    color: AppColors.customgreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                // 右：ハンバーガーメニュー
                actions: [
                  IconButton(
                    icon: const Icon(Icons.menu),
                    color: AppColors.customblack,
                    onPressed: () {
                      // 設定・プロフィール・ログアウトなど
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('メニュー'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  title: const Text('設定'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    // 設定画面に遷移
                                  },
                                ),
                                ListTile(
                                  title: const Text('プロフィール'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    // プロフィール画面に遷移
                                  },
                                ),
                                ListTile(
                                  title: const Text('ログアウト'),
                                  onTap: () async {
                                    Navigator.pop(context);
                                    await FirebaseAuth.instance.signOut();
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/',
                                      (route) => false,
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              //プロフィール情報
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // プロフィール画像
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage:
                                (imageUrl != null && imageUrl.isNotEmpty)
                                    ? NetworkImage(imageUrl)
                                    : null,
                            child: (imageUrl == null || imageUrl.isEmpty)
                                ? const Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.grey,
                                  )
                                : null,
                          ),
                          //投稿数・フォロワー・フォロー数
                          Expanded(
                            child: _countsFuture == null
                            ? const SizedBox()
                            : FutureBuilder<Map<String, int>>(
                                future: _countsFuture,
                                builder: (context, snapshot) {
                                  final counts = snapshot.data ?? {
                                    'followers': 0,
                                    'following': 0,
                                  };
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const ProfileStat(
                                        label: '投稿',
                                        count: '10',
                                      ),
                                      ProfileStat(
                                        label: 'フォロワー',
                                        count: '${counts['followers']}',
                                      ),
                                      ProfileStat(
                                        label: 'フォロー中',
                                        count: '${counts['following']}',
                                      ),
                                    ],
                                  );
                                },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              //グリッド切り替えボタン
              SliverPersistentHeader(
                delegate: _GridTabHeader(
                  selectedIndex: _selectedGridIndex,
                  onTap: (index) {
                    setState(() {
                      _selectedGridIndex = index;
                      });
                  },
                ), 
              ),
              // //投稿一覧グリッド
              SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Container(
                      color: Colors.grey.shade300,
                    );
                  },
                  childCount: 20,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // ← 横4つ
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                ),
              ),
            ],
          ),
          //ナビゲーションバー
          bottomNavigationBar: SafeArea(
            child: BottomAppBarCustom(
              selectedIndex: 4,
              onTap: (index) {
                AppRouter.navigate(context, 4, index);
              },
            ),
          ),
        );
      },
    );
  }
}

// プロフィール統計表示用ウィジェット（投稿数、フォロワー数、フォロー数）
class ProfileStat extends StatelessWidget {
  final String label;
  final String count;

  const ProfileStat({
    super.key,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            color: AppColors.customgreen,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.customgreen,
          ),
        ),
      ],
    );
  }
}

// グリッドの表示切り替えボタン
class _GridTabHeader extends SliverPersistentHeaderDelegate {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  _GridTabHeader({
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  double get minExtent => 50;
  @override
  double get maxExtent => 50;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: AppColors.customwhite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _tabItem(Icons.grid_on, 0),
          _tabItem(Icons.favorite_border, 1),
          _tabItem(Icons.bookmark_border, 2),
        ],
      ),
    );
  }

  Widget _tabItem(IconData icon, int index) {
    final isSelected = selectedIndex == index;

    return IconButton(
      onPressed: () => onTap(index),
      icon: Icon(
        icon,
        color: isSelected
            ? AppColors.custompurple
            : AppColors.customgreen,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _GridTabHeader oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex;
  }
}