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
import 'package:yogaappcustomer/utils/firebase_services.dart';
import 'package:yogaappcustomer/views/widgets/each_class_widget_1.dart';

import '../constants/my_widgets.dart';

class ClassesPage extends StatefulWidget {
  const ClassesPage({super.key});

  @override
  State<ClassesPage> createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  List<ClassModel> allClasses = [];
  List<CourseModel> allCourses = [];

  CartController cartController = CartController();
  TextEditingController txtSearch = TextEditingController(text: "");

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
    return RefreshIndicator(
      onRefresh: () async{
        await updateData();
      },
      child: Column(
        children: [
          _searchWidget(),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: isLoading,
              builder: (context, isLoading, child) {
                if(isLoading){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                else{
                  return _allClassesWidget();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  _searchWidget(){
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: MyConstants.basePadding,
        vertical: MyConstants.basePadding
      ),
      child: MyWidgets.customTextField(
          hPadding: 0,
          baseTextField: TextField(
            controller: txtSearch,
            onTapOutside: (event) => dismissKeyboard(),
            onChanged: (value) async{
              isLoading.value = true;
              await Future.delayed(const Duration(milliseconds: 500));
              isLoading.value = false;
            },
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w600
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search classes by teacher name",
                prefixIcon: const Icon(Icons.search_rounded),
                hintStyle: GoogleFonts.inter(
                    color: MyColors.text2
                )
            ),
          )
      ),
    );
  }

  _allClassesWidget(){
    final query = txtSearch.text.replaceAll(" ", "").trim().toLowerCase();
    List<ClassModel> filteredClasses = [...allClasses];
    if(query.isNotEmpty){
      filteredClasses = [...allClasses.where((eachClass) {
        final teacherName = eachClass.teacherName.replaceAll(" ", "").trim().toLowerCase();
        if(teacherName.contains(query) || query.contains(teacherName)){
          return true;
        }
        else{
          return false;
        }
      },).toList()];
    }
    return SizedBox(
      width: double.infinity,
      child: ListView.separated(
        itemCount: filteredClasses.length,
        padding: const EdgeInsets.symmetric(
          horizontal: MyConstants.basePadding,
          vertical: MyConstants.basePadding
        ),
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: MyConstants.basePadding,
          );
        },
        itemBuilder: (context, index) {
          final eachClass = filteredClasses[index];
          return EachClassWidget1(eachClass: eachClass);
        },
      ),
    );
  }


}
