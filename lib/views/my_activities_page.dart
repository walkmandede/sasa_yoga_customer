import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yogaappcustomer/constants/my_assets_path.dart';
import 'package:yogaappcustomer/constants/my_colors.dart';
import 'package:yogaappcustomer/constants/my_constants.dart';
import 'package:yogaappcustomer/constants/my_functions.dart';
import 'package:yogaappcustomer/constants/my_svg_data.dart';
import 'package:yogaappcustomer/controllers/data_controller.dart';
import 'package:yogaappcustomer/models/booking_model.dart';
import 'package:yogaappcustomer/utils/dialog_service.dart';
import 'package:yogaappcustomer/utils/firebase_services.dart';
import 'package:yogaappcustomer/views/widgets/each_class_widget_1.dart';
import '../controllers/cart_controller.dart';
import '../models/class_model.dart';
import '../models/course_model.dart';
import '../utils/route_utils.dart';


class MyActivitiesPage extends StatefulWidget {
  const MyActivitiesPage({super.key});

  @override
  State<MyActivitiesPage> createState() => _MyActivitiesPageState();
}

class _MyActivitiesPageState extends State<MyActivitiesPage> {

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  List<ClassModel> allClasses = [];
  List<CourseModel> allCourses = [];
  List<BookingModel> allBookings = [];

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
      allBookings.clear();

      for(final each in await FirebaseService().getCourses()){
        final model = CourseModel.fromFireStore(data: each);
        allCourses.add(model);
      }

      for(final each in await FirebaseService().getClasses()){
        final model = ClassModel.fromFireStore(data: each);
        allClasses.add(model);
      }

      final result = await FirebaseService().getBookings();
      if(result!=null){
        for(final each in result.docs){
          final model = BookingModel.fromFireStore(data: each.data(), id: each.id);
          allBookings.add(model);
        }
      }

      await Future.delayed(const Duration(seconds: 1));
    }
    catch(e){
      superPrint(e);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.bgGrey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.bgWhite,
        centerTitle: true,
        title: Text(
          "My activities",
          style: GoogleFonts.inter(
              color: MyColors.text1,
              fontWeight: FontWeight.bold
          ),
        ),
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
            if(allBookings.isEmpty){
              return Center(
                child: Text(
                  "There is no data yet!",
                  style: GoogleFonts.lato(
                    color: MyColors.text2,
                    fontSize: MyConstants.baseFontSizeL,
                    fontWeight: FontWeight.w600
                  ),
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async{
                await updateData();
              },
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: MyConstants.basePadding,
                  vertical: MyConstants.basePadding
                ),
                separatorBuilder: (context, index) {
                  return const SizedBox(height: MyConstants.basePadding,);
                },
                itemCount: allBookings.length,
                itemBuilder: (context, index) {
                  try{
                    final bookingModel = allBookings[index];
                    final classModel = allClasses.firstWhere((element) => element.id.toString() == bookingModel.classId.toString(),);
                    return EachClassWidget1(
                      eachClass: classModel,
                      isCartButtonIncluded: false,
                      courseModel: classModel.getCourseModel(courses: allCourses),
                    );
                  }
                  catch(_){
                    return const SizedBox.shrink();
                  }
                },
              )
            );
          }
        },
      ),
    );
  }
}

