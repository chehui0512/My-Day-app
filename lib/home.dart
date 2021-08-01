import 'dart:ffi';

import 'package:animations/animations.dart';
// flutter
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// my day
import 'package:My_Day_app/learn.dart';
import 'package:My_Day_app/my_day_icon_icons.dart';
import 'group/group_list_page.dart';
import 'home_page.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  int _index = 0;

  final _pages = <Widget>[HomePage(), GroupListPage(), HomePage(), Learn()];

  void _onTapped(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _appBars = <Widget>[
      homePageAppBar(context),
      groupListAppBar(context),
      homePageAppBar(context),
      homePageAppBar(context)
    ];
    Color color = Theme.of(context).primaryColor;
    var size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    double iconSize = width * 0.07;

    return Container(
      color: color,
      child: SafeArea(
        child: Scaffold(
            appBar: _appBars[_index],
            body: PageTransitionSwitcher(
              transitionBuilder: (Widget child, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return SharedAxisTransition(
                  child: child,
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.vertical,
                );
              },// 動畫 Widget function 
              child: _pages[_index], // 頁面
            ),
            bottomNavigationBar: SizedBox(
              height: height*0.08,
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                fixedColor: Colors.white,
                unselectedItemColor: Colors.yellow,
                backgroundColor: color,
                elevation: 0.0,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(MyDayIcon.home, size: iconSize),
                    label: '首頁',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(MyDayIcon.group, size: iconSize),
                    label: '群組',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(MyDayIcon.temporary_group, size: iconSize),
                    label: '玩聚',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(MyDayIcon.study, size: iconSize),
                    label: '學習',
                  ),
                ],
                currentIndex: _index,
                selectedIconTheme: IconThemeData(color: Colors.white),
                onTap: _onTapped,
              ),
            )),
      ),
    );
  }
}