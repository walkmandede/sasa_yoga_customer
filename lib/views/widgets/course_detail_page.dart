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
import 'package:yogaappcustomer/views/login_page.dart';
import 'package:yogaappcustomer/views/widgets/each_class_widget_1.dart';

import '../../utils/firebase_services.dart';

class CourseDetailPage extends StatefulWidget {
  const CourseDetailPage({super.key});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  List<ClassModel> allClasses = [];
  List<CourseModel> allCourses = [];

  CartController cartController = CartController();
  ValueNotifier<CourseModel?> courseModel = ValueNotifier(null);
  DataController dataController = DataController();

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

    isLoading.value = true;
    await updateData();
    isLoading.value = false;

  }

  Future<void> updateData() async{
    try{
      courseModel.value = dataController.currentCourse;
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: MyColors.bgWhite,
        elevation: 0,
        title: ValueListenableBuilder(
          valueListenable: courseModel,
          builder: (context, courseModel, child) {
            if(courseModel==null){
              return const SizedBox.shrink();
            }
            return Text(
              courseModel.courseName,
              style: GoogleFonts.lato(
                color: MyColors.text1,
                fontWeight: FontWeight.w600,
                fontSize: MyConstants.baseFontSizeXL
              ),
            );
          },
        )
      ),
      body: ValueListenableBuilder(
        valueListenable: isLoading,
        builder: (context, isLoading, child) {
          if(isLoading){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else{
            return ValueListenableBuilder(
              valueListenable: courseModel,
              builder: (context, courseModel, child) {
                if(courseModel==null){
                  return const Center(
                    child: Icon(
                      Icons.error_outline_rounded,
                      color: MyColors.redDanger,
                    ),
                  );
                }
                else{
                  return RefreshIndicator(
                    onRefresh: () async{
                      await updateData();
                    },
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                          horizontal: MyConstants.basePadding,
                          vertical: MyConstants.basePadding
                      ),
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: LayoutBuilder(
                        builder: (a1, c1) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(MyConstants.baseBorderRadius),
                                child: Image.asset(
                                  courseModel.getImagePath(),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Text(
                                courseModel.days,
                                style: GoogleFonts.lato(
                                    fontSize: MyConstants.baseFontSizeL,
                                    fontWeight: FontWeight.w600,
                                    color: MyColors.text1
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SvgPicture.string(
                                    MySvgData.people,
                                    colorFilter: const ColorFilter.mode(MyColors.text1, BlendMode.srcIn),
                                  ),
                                  SizedBox(width: c1.maxWidth *0.025,),
                                  Text(
                                    courseModel.capacity.toString(),
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
                                    courseModel.time,
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
                                    "${courseModel.duration}",
                                    style: GoogleFonts.lato(
                                        fontSize: MyConstants.baseFontSizeM,
                                        fontWeight: FontWeight.normal,
                                        color: MyColors.text1
                                    ),
                                    maxLines: 1,
                                  ),
                                  SizedBox(width: c1.maxWidth *0.05,),
                                  const Spacer(),
                                  Text(
                                    courseModel.getPriceLabel(),
                                    style: GoogleFonts.lato(
                                        fontSize: MyConstants.baseFontSizeXL,
                                        fontWeight: FontWeight.bold,
                                        color: MyColors.primary
                                    ),
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              Text(
                                courseModel.description,
                                style: GoogleFonts.lato(
                                    fontSize: MyConstants.baseFontSizeM,
                                    fontWeight: FontWeight.normal,
                                    color: MyColors.text1
                                ),
                              ),
                              const SizedBox(height: 20,),
                              _classesPanel(),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }

  Widget _classesPanel(){
    if(courseModel.value == null){
      return const SizedBox.shrink();
    }
    List<ClassModel> thisCourseClasses = allClasses.where((element) {
      return element.courseId.toString() == courseModel.value!.id.toString();
    },).toList();
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Classes",
              style: GoogleFonts.lato(
                  fontSize: MyConstants.baseFontSizeXL,
                  fontWeight: FontWeight.w800,
                  color: MyColors.text1
              ),
            ),
            const SizedBox(width: 10,),
            CircleAvatar(
              radius: 10,
              backgroundColor: MyColors.primary,
              child: FittedBox(
                child: Text(
                  thisCourseClasses.length.toString(),
                  style: GoogleFonts.lato(
                      fontSize: MyConstants.baseFontSizeM,
                      fontWeight: FontWeight.w800,
                      color: MyColors.primaryOver
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(width: 10,),
        ...thisCourseClasses.map(
          (eachClass) {
            return Column(
              children: [
                const SizedBox(height: MyConstants.basePadding,),
                EachClassWidget1(
                  eachClass: eachClass,
                  courseModel: eachClass.getCourseModel(courses: allCourses),
                ),
              ],
            );
          },
        ).toList()
      ],
    );
  }

}
