import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yogaappcustomer/constants/my_colors.dart';
import 'package:yogaappcustomer/constants/my_constants.dart';
import 'package:yogaappcustomer/constants/my_functions.dart';
import 'package:yogaappcustomer/constants/my_svg_data.dart';
import 'package:yogaappcustomer/controllers/cart_controller.dart';
import 'package:yogaappcustomer/models/class_model.dart';
import 'package:yogaappcustomer/models/course_model.dart';
import 'package:intl/intl.dart';

import '../utils/firebase_services.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {

  ValueNotifier<bool> isLoading = ValueNotifier(false);
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
    allCourses.clear();
    await updateData();
    isLoading.value = false;

  }

  Future<void> updateData() async{
    try{
      //course seeds
      for(final each in await FirebaseService().getCourses()){
        final model = CourseModel.fromFireStore(data: each);
        allCourses.add(model);
      }
      await Future.delayed(const Duration(seconds: 1));
    }
    catch(_){}
  }



  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isLoading,
      builder: (context, _isLoading, child) {
        if(_isLoading){
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
              padding: const EdgeInsets.symmetric(
                vertical: MyConstants.basePadding
              ),
              child: Column(
                children: [
                  _featuredCoursesWidget(),
                  _allCourses()
                ],
              ),
            ),
          );
        }
      },
    );
  }

  _featuredCoursesWidget(){
    final featuredCourses = allCourses.where((element) => element.isFeatured,).toList();
    if(featuredCourses.isEmpty){
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(
        bottom: MyConstants.basePadding
      ),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 390/280,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: featuredCourses.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(width: MyConstants.basePadding,);
                },
                padding: const EdgeInsets.symmetric(
                    horizontal: MyConstants.basePadding
                ),
                itemBuilder: (context, index) {
                  final eachModel = featuredCourses[index];
                  return ClipRRect(
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _allCourses(){
    final nonFeaturedCourses = allCourses.where((element) => !element.isFeatured,).toList();
    if(nonFeaturedCourses.isEmpty){
      return const SizedBox.shrink();
    }
    superPrint(nonFeaturedCourses);
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MyConstants.basePadding,
        ),
        child: Column(
          children: [
            ...nonFeaturedCourses.map(
              (eachCourse) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: MyConstants.basePadding
                  ),
                  child: AspectRatio(
                    aspectRatio: 358/99,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: MyColors.bgWhite,
                        borderRadius: BorderRadius.circular(MyConstants.baseBorderRadius)
                      ),
                      child: LayoutBuilder(
                        builder: (a1, c1) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: c1.maxHeight * 0.1,
                              vertical: c1.maxHeight * 0.1
                            ),
                            child: Row(
                              children: [
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(eachCourse.getImagePath()),
                                        fit: BoxFit.cover
                                      ),
                                      borderRadius: BorderRadius.circular(MyConstants.baseBorderRadius)
                                    ),
                                  ),
                                ),
                                SizedBox(width: c1.maxWidth * 0.05,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                eachCourse.days,
                                                style: GoogleFonts.lato(
                                                  color: MyColors.text1,
                                                  fontSize: MyConstants.baseFontSizeM,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ),
                                            Text(
                                              eachCourse.getPriceLabel(),
                                              style: GoogleFonts.lato(
                                                color: MyColors.primary,
                                                fontSize: MyConstants.baseFontSizeL,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: 1,
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            eachCourse.courseName,
                                            style: GoogleFonts.lato(
                                              color: MyColors.text1,
                                              fontSize: MyConstants.baseFontSizeL,
                                              fontWeight: FontWeight.w600,
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
                                            SizedBox(width: c1.maxWidth *0.015,),
                                            Text(
                                              eachCourse.capacity.toString(),
                                              style: GoogleFonts.lato(
                                                  fontSize: MyConstants.baseFontSizeM,
                                                  fontWeight: FontWeight.normal,
                                                  color: MyColors.text1
                                              ),
                                              maxLines: 1,
                                            ),
                                            SizedBox(width: c1.maxWidth *0.025,),
                                            SvgPicture.string(
                                              MySvgData.clock,
                                              colorFilter: const ColorFilter.mode(MyColors.text1, BlendMode.srcIn),
                                            ),
                                            SizedBox(width: c1.maxWidth *0.015,),
                                            Text(
                                              eachCourse.time,
                                              style: GoogleFonts.lato(
                                                  fontSize: MyConstants.baseFontSizeM,
                                                  fontWeight: FontWeight.normal,
                                                  color: MyColors.text1
                                              ),
                                              maxLines: 1,
                                            ),
                                            SizedBox(width: c1.maxWidth *0.025,),
                                            SvgPicture.string(
                                              MySvgData.timer,
                                              colorFilter: const ColorFilter.mode(MyColors.text1, BlendMode.srcIn),
                                            ),
                                            SizedBox(width: c1.maxWidth *0.015,),
                                            Text(
                                              "${eachCourse.duration}",
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
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ).toList()
          ],
        ),
      ),
    );
  }

}
