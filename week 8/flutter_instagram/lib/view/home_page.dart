import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/model_view/model/iuser.dart';
import 'package:flutter_instagram/model_view/provider/user_provider.dart';
import 'package:flutter_instagram/res/colors.dart';
import 'package:flutter_instagram/view/message_feed.dart';
import 'package:flutter_instagram/view/add_post_screen.dart';
import 'package:flutter_instagram/view/profile_screen.dart';
import 'package:flutter_instagram/view/search_screen.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider u = Provider.of<UserProvider>(context, listen: false);
    u.refreshUser();
    IUser? user = u.getUser;
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (page) {
          setState(() {
            _page = page;
          });
        },
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const FeedScreen(),
          const SearchScreen(),
          const AddPostScreen(),
          const Text('p4'),
          ProfileScreen(
            uId: (user?.userId).toString(),
          ),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _page == 0 ? primaryColor : secondColor,
              ),
              backgroundColor: primaryColor,
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: _page == 1 ? primaryColor : secondColor,
              ),
              backgroundColor: primaryColor,
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                color: _page == 2 ? primaryColor : secondColor,
              ),
              backgroundColor: primaryColor,
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: _page == 3 ? primaryColor : secondColor,
              ),
              backgroundColor: primaryColor,
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: _page == 4 ? primaryColor : secondColor,
              ),
              backgroundColor: primaryColor,
              label: ''),
        ],
        onTap: (page) {
          pageController.jumpToPage(page);
        },
      ),
    );
  }
}
