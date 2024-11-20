
import 'package:flutter/cupertino.dart';
import 'package:yogaappcustomer/models/course_model.dart';
import 'package:yogaappcustomer/models/profile_model.dart';

import '../constants/my_svg_data.dart';
import '../views/main_page.dart';


enum EnumMainPageTabs{
  home(label: "Home",iconPath: MySvgData.home),
  courses(label: "Courses",iconPath: MySvgData.courses),
  classes(label: "Clases",iconPath: MySvgData.classes),
  ;
  final String label;
  final String iconPath;
  const EnumMainPageTabs({required this.label,required this.iconPath});
}

class MainPageController {

  MainPageController._privateConstructor();
  static final MainPageController _instance = MainPageController._privateConstructor();

  factory MainPageController() {
    return _instance;
  }

  PageController pageController = PageController();
  ValueNotifier<EnumMainPageTabs> currentTab = ValueNotifier(EnumMainPageTabs.home);


  void updateTab({required EnumMainPageTabs tab}){
    currentTab.value = tab;
    pageController.animateToPage(
        EnumMainPageTabs.values.indexOf(tab),
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear
    );
  }
}