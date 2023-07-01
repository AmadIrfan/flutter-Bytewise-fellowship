import 'package:cric_scorer/Teams/teams.dart';
import 'package:cric_scorer/about/about.dart';
import 'package:cric_scorer/about/team_scorer.dart';
import 'package:cric_scorer/my%20matches/create_match.dart';
import 'package:cric_scorer/my%20matches/my%20matches.dart';
import 'package:cric_scorer/login_singup/login_page.dart';
import 'package:cric_scorer/user profile/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get_storage/get_storage.dart';

Widget customdrawertile(_title, _leading, onpressed) {
  return ListTile(
    onTap: onpressed,
    title: Text(_title),
    leading: Icon(
      _leading,
      size: 25.0,
      color: Colors.teal,
    ),
  );
}

Widget MyDrawer(isloggedin, username, useremail, profilepic, [logout_func]) {
  final match_info_box = GetStorage('Match_Info');
  return Drawer(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          child: UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20.0),
              ),
              color: Colors.teal,
            ),
            accountName: Text(username),
            accountEmail: Text(useremail),
            currentAccountPicture: CircleAvatar(
              foregroundImage:
                  CachedNetworkImageProvider(profilepic.toString()),
              backgroundColor: Colors.teal,
              child: Icon(
                CupertinoIcons.profile_circled,
                size: 80.0,
                color: Colors.white,
              ),
            ),
            currentAccountPictureSize: Size.square(80.0),
          ),
        ),
        customdrawertile(
          'Profile',
          Icons.account_circle_rounded,
          () {
            isloggedin
                ? Get.to(() => UserProfile())
                : Get.to(() => LoginPage());
          },
        ),
        customdrawertile(
          'My Matches',
          Icons.today,
          () {
            isloggedin ? Get.to(() => Matches()) : Get.to(() => LoginPage());
          },
        ),
        customdrawertile(
          'My Teams',
          Icons.group,
          () {
            isloggedin
                ? Get.to(
                    () => Teams(),
                    transition: Transition.rightToLeft,
                  )
                : Get.to(() => LoginPage());
          },
        ),
        customdrawertile(
          'Start Match',
          Icons.arrow_right,
          () {
            match_info_box.erase();
            isloggedin
                ? Get.to(() => CreateMatch(),
                    transition: Transition.rightToLeft,
                    arguments: {
                        // 'team_name1' : '',
                        'team_name': '',
                        'team_logo': '',
                        'team_location': '',
                        'team_id': '',
                        'team_short_name': '',
                      })
                : Get.to(() => LoginPage());
          },
        ),
        isloggedin
            ? customdrawertile(
                'Logout',
                Icons.power_settings_new,
                () {
                  logout_func();
                },
              )
            : customdrawertile(
                'Login/Signup',
                Icons.power_settings_new,
                () {
                  Get.to(() => LoginPage());
                },
              ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customdrawertile(
                'Team',
                Icons.group,
                () {
                  Get.to(() => Team_scorer());
                },
              ),
              customdrawertile(
                'About',
                Icons.info_outline,
                () {
                  Get.to(() => Aboutus());
                },
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
