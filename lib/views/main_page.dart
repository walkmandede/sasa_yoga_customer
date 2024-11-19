import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yogaappcustomer/constants/my_colors.dart';
import 'package:yogaappcustomer/constants/my_constants.dart';
import 'package:yogaappcustomer/constants/my_functions.dart';
import 'package:yogaappcustomer/constants/my_svg_data.dart';
import 'package:yogaappcustomer/controllers/cart_controller.dart';
import 'package:yogaappcustomer/controllers/data_controller.dart';
import 'package:yogaappcustomer/views/classes_page.dart';
import 'package:yogaappcustomer/views/courses_page.dart';
import 'package:yogaappcustomer/views/home_page.dart';

import '../utils/route_utils.dart';

enum EnumMainPageTabs{
  home(label: "Home",iconPath: MySvgData.home),
  courses(label: "Courses",iconPath: MySvgData.courses),
  classes(label: "Clases",iconPath: MySvgData.classes),
  ;
  final String label;
  final String iconPath;
  const EnumMainPageTabs({required this.label,required this.iconPath});
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  DataController dataController = DataController();
  PageController pageController = PageController();
  ValueNotifier<EnumMainPageTabs> currentTab = ValueNotifier(EnumMainPageTabs.home);
  CartController cartController = CartController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void updateTab({required EnumMainPageTabs tab}){
    currentTab.value = tab;
    pageController.animateToPage(
        EnumMainPageTabs.values.indexOf(tab),
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.bgGrey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.bgWhite,
        title: Text(
          "MindFlex",
          style: GoogleFonts.abrilFatface(
            color: MyColors.text1
          ),
        ),
        actions: [
          ValueListenableBuilder(
            valueListenable: cartController.selectedData  ,
            builder: (context, selectedData, child) {
              if(selectedData.isEmpty){
                return const SizedBox.shrink();
              }
              return Badge(
                alignment: Alignment.centerRight,
                backgroundColor: MyColors.primary,
                label: Text(
                  "${selectedData.length}",
                  style: GoogleFonts.lato(
                    color: MyColors.primaryOver,
                    fontWeight: FontWeight.w600,
                    fontSize: MyConstants.baseFontSizeM
                  ),
                ),
                child: Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RouteUtils.cartPage);
                    },
                    child: SvgPicture.string(
                      MySvgData.cart,
                      colorFilter: const ColorFilter.mode(MyColors.text1, BlendMode.srcIn),
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(width: MyFunctions.getMediaQuerySize(context: context).width *0.05,),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, RouteUtils.profilePage);
            },
            child: Hero(
              tag: "profileImage",
              child: CircleAvatar(
                backgroundColor: MyColors.primary,
                child: FittedBox(
                  alignment: Alignment.center,
                  child: ValueListenableBuilder(
                    valueListenable: dataController.profileModel,
                    builder: (context, profileModel, child) {
                      return Text(
                        profileModel.getInitial(),
                        style: GoogleFonts.roboto(
                          color: MyColors.primaryOver,
                          fontWeight: FontWeight.bold
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: MyFunctions.getMediaQuerySize(context: context).width * 0.025,)
        ],
      ),
      body: PageView.builder(
        itemCount: 3,
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          switch(index){
            case 0: return Builder(
              builder: (context) {
                return const HomePage();
              },
            );
            case 1: return Builder(
              builder: (context) {
                return const CoursesPage();
              },
            );
            case 2: return Builder(
              builder: (context) {
                return const ClassesPage();
              },
            );
            default: return const SizedBox.shrink();
          }
        },
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: currentTab,
        builder: (context, currentTab, child) {
          return BottomNavigationBar(
            backgroundColor: MyColors.bgWhite,
            onTap: (value) {
              updateTab(tab: EnumMainPageTabs.values[value]);
            },
            elevation: 5,
            selectedItemColor: MyColors.primary,
            unselectedItemColor: MyColors.text2,
            currentIndex: EnumMainPageTabs.values.indexOf(currentTab),
            selectedLabelStyle: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: MyColors.primary
            ),
            unselectedLabelStyle: GoogleFonts.inter(
                fontWeight: FontWeight.normal,
                color: MyColors.text2
            ),
            items: EnumMainPageTabs.values.map((each) {
              final xSelected = currentTab == each;
              return BottomNavigationBarItem(
                icon: SvgPicture.string(
                  each.iconPath,
                  colorFilter: ColorFilter.mode(
                      xSelected?MyColors.primary:MyColors.text2, BlendMode.srcIn),
                ),
                label: each.label,
              );
            },).toList(),
          );
        },
      ),
    );
  }
}
