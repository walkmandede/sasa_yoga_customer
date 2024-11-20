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

  ValueNotifier<DateTime?> selectedDate = ValueNotifier(null);
  ValueNotifier<CourseModel?> selectedCourse = ValueNotifier(null);

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

  void refreshState() async{
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 100));
    isLoading.value = false;
  }

  void resetFilter() async{
    txtSearch.clear();
    selectedDate.value = null;
    selectedCourse.value = null;
    refreshState();
  }

  List<ClassModel> getFilteredClasses(){
    List<ClassModel> result = [...allClasses];

    //search filter
    final query = txtSearch.text.replaceAll(" ", "").trim().toLowerCase();
    if(query.isNotEmpty){
      result = [...allClasses.where((eachClass) {
        //search by both teacher name or class name
        final teacherName = eachClass.teacherName.replaceAll(" ", "").trim().toLowerCase();
        final className = eachClass.className.replaceAll(" ", "").trim().toLowerCase();
        if(teacherName.contains(query) || query.contains(teacherName) || className.contains(query) || query.contains(className)){
          return true;
        }
        else{
          return false;
        }
      },).toList()];
    }

    //date filter
    if(selectedDate.value != null){
      result = [
        ...result.where((element) {
          return MyFunctions.isSameDay(
              dateTime1: element.dateTime,
              dateTime2: selectedDate.value!
          );
        },).toList()
      ];
    }

    //course filter
    if(selectedCourse.value != null){
      result = [
        ...result.where((element) {
          superPrint(element.courseId);
          return element.courseId.toString() == selectedCourse.value!.id.toString();
        },).toList()
      ];
    }

    superPrint(result);

    return result;
  }

  void updateDate() async{
    showDatePicker(
      context: context,
      firstDate: DateTime(1), lastDate: DateTime.now().add(const Duration(days: 1000000)),
      initialDate: selectedDate.value,
    ).then((value) {
      if(value!=null){
        selectedDate.value = value;
        refreshState();
      }
    },);
  }

  void updateCourse({required CourseModel? courseModel}) async{
    selectedCourse.value = courseModel;
    refreshState();
  }

  Future<void> onClickFilterIcon() async{
    showModalBottomSheet(
        context: context,
        backgroundColor: MyColors.bgWhite,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(MyConstants.baseBorderRadius)
          )
        ),
        builder: (context) {
          return SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.all(MyConstants.basePadding),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Filter",
                          style: GoogleFonts.lato(
                            fontSize: MyConstants.baseFontSizeXL,
                            fontWeight: FontWeight.w600,
                            color: MyColors.text1
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Future.delayed(const Duration(milliseconds: 100)).then((value) => resetFilter(),);
                          },
                          child: Text(
                            "Reset",
                            style: GoogleFonts.lato(
                              color: MyColors.text2,
                              fontWeight: FontWeight.normal,
                              fontSize: MyConstants.baseFontSizeL
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      "Class date",
                      style: GoogleFonts.lato(
                          fontSize: MyConstants.baseFontSizeL,
                          fontWeight: FontWeight.normal,
                          color: MyColors.text1
                      ),
                    ),
                    const SizedBox(height: 10,),
                    InkWell(
                      onTap: () {
                        updateDate();
                      },
                      child: SizedBox(
                        width: double.infinity,
                        height: MyConstants.baseButtonHeight,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: MyColors.textFieldBg,
                              borderRadius: BorderRadius.circular(MyConstants.baseBorderRadiusS)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: MyConstants.baseButtonHeight * 0.25,
                              vertical: MyConstants.baseButtonHeight * 0.2,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ValueListenableBuilder(
                                    valueListenable: selectedDate,
                                    builder: (context, selectedDate, child) {
                                      return Text(
                                        selectedDate==null?"Choose Date":DateFormat("MMM dd, yyyy").format(selectedDate),
                                        style: GoogleFonts.lato(
                                            color: MyColors.text1,
                                            fontWeight: FontWeight.normal,
                                            fontSize: MyConstants.baseFontSizeL
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SvgPicture.string(
                                  MySvgData.calendar,
                                  colorFilter: ColorFilter.mode(MyColors.text1, BlendMode.srcIn),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Text(
                      "Courses",
                      style: GoogleFonts.lato(
                          fontSize: MyConstants.baseFontSizeL,
                          fontWeight: FontWeight.normal,
                          color: MyColors.text1
                      ),
                    ),
                    const SizedBox(height: 10,),
                    InkWell(
                      onTap: () {
                        updateDate();
                      },
                      child: SizedBox(
                        width: double.infinity,
                        height: MyConstants.baseButtonHeight,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: MyColors.textFieldBg,
                              borderRadius: BorderRadius.circular(MyConstants.baseBorderRadiusS)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: MyConstants.baseButtonHeight * 0.25,
                              // vertical: MyConstants.baseButtonHeight * 0.2,
                            ),
                            child: ValueListenableBuilder(
                              valueListenable: selectedCourse,
                              builder: (context, selectedCourse, child) {
                                return DropdownButton<CourseModel>(
                                  onChanged: (value) {
                                    updateCourse(courseModel: value);
                                  },
                                  underline: const SizedBox.shrink(),
                                  isExpanded: true,
                                  value: selectedCourse,
                                  hint: Text(
                                    "Choose Course",
                                    style: GoogleFonts.lato(
                                        fontWeight: FontWeight.normal,
                                        color: MyColors.text1,
                                        fontSize: MyConstants.baseFontSizeM
                                    ),
                                  ),
                                  items: allCourses.map((eachCourse) {
                                    return DropdownMenuItem(
                                      value: eachCourse,
                                      child: Text(
                                        eachCourse.courseName,
                                        style: GoogleFonts.lato(
                                            fontWeight: FontWeight.normal,
                                            color: MyColors.text1,
                                            fontSize: MyConstants.baseFontSizeM
                                        ),
                                      ),
                                    );
                                  },).toList(),
                                );
                              },
                            ),
                            // child: Row(
                            //   children: [
                            //     Expanded(
                            //       child: ValueListenableBuilder(
                            //         valueListenable: selectedCourse,
                            //         builder: (context, selectedCourse, child) {
                            //           return Text(
                            //             selectedCourse==null?"Choose Course":selectedCourse.courseName,
                            //             style: GoogleFonts.lato(
                            //                 color: MyColors.text1,
                            //                 fontWeight: FontWeight.normal,
                            //                 fontSize: MyConstants.baseFontSizeL
                            //             ),
                            //           );
                            //         },
                            //       ),
                            //     ),
                            //     Icon(
                            //       Icons.keyboard_arrow_down_rounded,
                            //       color: MyColors.text1,
                            //     )
                            //   ],
                            // ),
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
    );
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
      child: Row(
        children: [
          Expanded(
            child: MyWidgets.customTextField(
                hPadding: 0,
                baseTextField: TextField(
                  controller: txtSearch,
                  onTapOutside: (event) => dismissKeyboard(),
                  onChanged: (value) async{
                    refreshState();
                  },
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600
                  ),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search classes",
                      prefixIcon: const Icon(Icons.search_rounded),
                      hintStyle: GoogleFonts.inter(
                          color: MyColors.text2
                      )
                  ),
                )
            ),
          ),
          SizedBox(width: MyFunctions.getMediaQuerySize(context: context).width *0.025,),
          InkWell(
            onTap: () {
              onClickFilterIcon();
            },
            child: SizedBox(
              height: MyConstants.baseButtonHeight,
              width: MyConstants.baseButtonHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: MyColors.textFieldBg,
                  borderRadius: BorderRadius.circular(MyConstants.baseBorderRadius)
                ),
                child: LayoutBuilder(
                  builder: (a1,c1) {
                    return Padding(
                      padding: EdgeInsets.all(c1.maxWidth*0.25),
                      child: SvgPicture.string(
                        MySvgData.filter
                      ),
                    );
                  }
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _allClassesWidget(){
    List<ClassModel> filteredClasses = [...getFilteredClasses()];
    if(filteredClasses.isEmpty){
      return Center(
        child: Text(
          "No data",
          style: GoogleFonts.lato(
            fontSize: MyConstants.baseFontSizeXL,
            fontWeight: FontWeight.normal,
            color: MyColors.text2
          ),
        ),
      );
    }
    return SizedBox(
      width: double.infinity,
      child: ListView.separated(
        itemCount: filteredClasses.length,
        padding: const EdgeInsets.only(
          left: MyConstants.basePadding,
          right: MyConstants.basePadding,
          bottom: MyConstants.basePadding
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
