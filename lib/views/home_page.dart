import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yogaappcustomer/constants/my_colors.dart';
import 'package:yogaappcustomer/constants/my_constants.dart';
import 'package:yogaappcustomer/constants/my_functions.dart';
import 'package:yogaappcustomer/constants/my_svg_data.dart';
import 'package:yogaappcustomer/controllers/cart_controller.dart';
import 'package:yogaappcustomer/controllers/data_controller.dart';
import 'package:yogaappcustomer/models/class_model.dart';
import 'package:yogaappcustomer/models/course_model.dart';
import 'package:intl/intl.dart';
import 'package:yogaappcustomer/utils/route_utils.dart';
import 'package:yogaappcustomer/views/login_page.dart';
import 'package:yogaappcustomer/views/widgets/each_class_widget_1.dart';

import '../utils/firebase_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  List<ClassModel> allClasses = [];
  List<CourseModel> allCourses = [];

  CartController cartController = CartController();

  @override
  void initState() {
    initLoad();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> initLoad() async{

    //seeding
    isLoading.value = true;
    await updateData();
    isLoading.value = false;

  }

  Future<void> updateData() async{
    try{
      allCourses.clear();
      allClasses.clear();
      //course seeds
      for(final each in await FirebaseService().getCourses()){
        final model = CourseModel.fromFireStore(data: each);
        allCourses.add(model);
      }
      //class seeds
      for(final each in await FirebaseService().getClasses()){
        final model = ClassModel.fromFireStore(data: each);
        allClasses.add(model);
      }
      await Future.delayed(const Duration(seconds: 1));
    }
    catch(_){}
  }



  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isLoading,
      builder: (context, isLoading, child) {
        if(isLoading){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        else{
          return RefreshIndicator(
            onRefresh: () async{
              await updateData();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  if(allCourses.isNotEmpty)_coursesWidget(),
                  if(allClasses.isNotEmpty)_todayClassesWidget()
                ],
              ),
            ),
          );
        }
      },
    );
  }

  _coursesWidget(){
    final featuredCourse = allCourses.where((element) => element.isFeatured,).toList();
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: MyConstants.basePadding,
                vertical: MyConstants.basePadding/2
            ),
            child: Row(
              children: [
                Text(
                  "Popular Courses",
                  style: GoogleFonts.lato(
                    fontSize: MyConstants.baseFontSizeXL,
                    fontWeight: FontWeight.w600
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {

                  },
                  label: Text(
                    "See More",
                    style: GoogleFonts.lato(
                      color: MyColors.text1,
                      fontWeight: FontWeight.normal
                    ),
                  ),
                  iconAlignment: IconAlignment.end,
                  icon: const Icon(Icons.arrow_forward_ios_rounded,size: 12,color: MyColors.text1,),
                )
              ],
            ),
          ),
          AspectRatio(
            aspectRatio: 390/280,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: featuredCourse.length,
              separatorBuilder: (context, index) {
                return const SizedBox(width: MyConstants.basePadding,);
              },
              padding: const EdgeInsets.symmetric(
                horizontal: MyConstants.basePadding
              ),
              itemBuilder: (context, index) {
                final eachModel = featuredCourse[index];
                return InkWell(
                  onTap: () {
                    DataController dataController = DataController();
                    dataController.currentCourse = eachModel;
                    Navigator.pushNamed(context, RouteUtils.courseDetailPage);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(MyConstants.baseBorderRadius),
                    child: AspectRatio(
                      aspectRatio: 240/287,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Image.asset(
                              eachModel.getImagePath(),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: DecoratedBox(
                              decoration: const BoxDecoration(
                                color: MyColors.bgWhite
                              ),
                              child: SizedBox.expand(
                                child: LayoutBuilder(
                                  builder: (a1, c1) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: c1.maxWidth * 0.05,
                                        vertical: c1.maxHeight * 0.1
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    eachModel.courseName,
                                                    style: GoogleFonts.lato(
                                                      fontSize: MyConstants.baseFontSizeL,
                                                      fontWeight: FontWeight.w600,
                                                      color: MyColors.text1
                                                    ),
                                                    maxLines: 1,
                                                  ),
                                                ),
                                                Text(
                                                  eachModel.getPriceLabel(),
                                                  style: GoogleFonts.lato(
                                                      fontSize: MyConstants.baseFontSizeXL,
                                                      fontWeight: FontWeight.w600,
                                                      color: MyColors.primary
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                eachModel.days,
                                                style: GoogleFonts.lato(
                                                    fontSize: MyConstants.baseFontSizeL,
                                                    fontWeight: FontWeight.normal,
                                                    color: MyColors.text1
                                                ),
                                                maxLines: 1,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                SvgPicture.string(
                                                  MySvgData.people,
                                                  colorFilter: const ColorFilter.mode(MyColors.text1, BlendMode.srcIn),
                                                ),
                                                SizedBox(width: c1.maxWidth *0.025,),
                                                Text(
                                                  eachModel.capacity.toString(),
                                                  style: GoogleFonts.lato(
                                                      fontSize: MyConstants.baseFontSizeM,
                                                      fontWeight: FontWeight.normal,
                                                      color: MyColors.text1
                                                  ),
                                                  maxLines: 1,
                                                ),
                                                SizedBox(width: c1.maxWidth *0.05,),
                                                SvgPicture.string(
                                                  MySvgData.clock,
                                                  colorFilter: const ColorFilter.mode(MyColors.text1, BlendMode.srcIn),
                                                ),
                                                SizedBox(width: c1.maxWidth *0.025,),
                                                Text(
                                                  eachModel.time,
                                                  style: GoogleFonts.lato(
                                                      fontSize: MyConstants.baseFontSizeM,
                                                      fontWeight: FontWeight.normal,
                                                      color: MyColors.text1
                                                  ),
                                                  maxLines: 1,
                                                ),
                                                SizedBox(width: c1.maxWidth *0.05,),
                                                SvgPicture.string(
                                                  MySvgData.timer,
                                                  colorFilter: const ColorFilter.mode(MyColors.text1, BlendMode.srcIn),
                                                ),
                                                SizedBox(width: c1.maxWidth *0.025,),
                                                Text(
                                                  "${eachModel.duration}",
                                                  style: GoogleFonts.lato(
                                                      fontSize: MyConstants.baseFontSizeM,
                                                      fontWeight: FontWeight.normal,
                                                      color: MyColors.text1
                                                  ),
                                                  maxLines: 1,
                                                ),
                                                SizedBox(width: c1.maxWidth *0.05,),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _todayClassesWidget(){
    final tdyClasses = allClasses.where((element) {
      return MyFunctions.isSameDay(dateTime1: element.dateTime, dateTime2: DateTime.now());
    },).toList();
    if(tdyClasses.isEmpty){
      return const SizedBox.shrink();
    }
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: MyConstants.basePadding,
                vertical: MyConstants.basePadding/2
            ),
            child: Row(
              children: [
                Text(
                  "Today Classes",
                  style: GoogleFonts.lato(
                      fontSize: MyConstants.baseFontSizeXL,
                      fontWeight: FontWeight.w600
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {

                  },
                  label: Text(
                    "See More",
                    style: GoogleFonts.lato(
                        color: MyColors.text1,
                        fontWeight: FontWeight.normal
                    ),
                  ),
                  iconAlignment: IconAlignment.end,
                  icon: const Icon(Icons.arrow_forward_ios_rounded,size: 12,color: MyColors.text1,),
                )
              ],
            ),
          ),
          Column(
            children: [
              ...tdyClasses.map((eachClass) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: MyConstants.basePadding,
                    left: MyConstants.basePadding,
                    right: MyConstants.basePadding
                  ),
                  child: EachClassWidget1(eachClass: eachClass,),
                );
              },).toList()
            ],
          ),
        ],
      ),
    );
  }


}
