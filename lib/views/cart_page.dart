import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yogaappcustomer/constants/my_colors.dart';
import 'package:yogaappcustomer/constants/my_constants.dart';
import 'package:yogaappcustomer/controllers/cart_controller.dart';
import 'package:yogaappcustomer/models/course_model.dart';
import 'package:yogaappcustomer/utils/dialog_service.dart';
import 'package:yogaappcustomer/utils/firebase_services.dart';
import 'package:yogaappcustomer/utils/route_utils.dart';
import 'package:yogaappcustomer/views/widgets/each_class_widget_1.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {


  CartController cartController = CartController();
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  List<CourseModel> allCourses = [];

  @override
  void initState() {
    initLoad();
    super.initState();
  }

  Future<void> initLoad() async{
    isLoading.value = true;
    await updateData();
    isLoading.value = false;
  }

  Future<void> updateData() async{
    try{
      allCourses.clear();
      //course
      for(final each in await FirebaseService().getCourses()){
        final model = CourseModel.fromFireStore(data: each);
        allCourses.add(model);
      }
      await Future.delayed(const Duration(seconds: 1));
    }
    catch(_){}
  }

  Future<void> onClickBooking()  async{
    DialogService().showConfirmDialog(
      context: context,
      onClickYes: () async{
        await Future.delayed(const Duration(milliseconds: 100));
        DialogService().dismissDialog(context: context);
        DialogService().showLoadingDialog(context: context);
        for(final each in cartController.selectedData.value){
          await FirebaseService().bookClasses(classModel: each);
        }
        cartController.clearCart();
        DialogService().dismissDialog(context: context);
        Navigator.pushNamedAndRemoveUntil(context, RouteUtils.mainPage,(route) => false,);
        Navigator.pushNamed(context, RouteUtils.myActivitiesPage);
      },
    );
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
          "Booking Cart",
          style: GoogleFonts.lato(
            fontSize: MyConstants.baseFontSizeXL,
            fontWeight: FontWeight.bold,
            color: MyColors.text1
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: isLoading,
        builder: (context, isLoading, child) {
          if(isLoading){
            return const Center(
              child: CircularProgressIndicator(color: MyColors.primary,),
            );
          }
          else{
            return ValueListenableBuilder(
              valueListenable: cartController.selectedData,
              builder: (context, selectedData, child) {
                if(selectedData.isEmpty){
                  return Center(
                    child: Text(
                      "There is no data in the cart yet!\nPlease add some classes to continue.",
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w600,
                        color: MyColors.text2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: MyConstants.basePadding,
                            vertical: MyConstants.basePadding
                        ),
                        itemCount: selectedData.length,
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: MyConstants.basePadding,
                          );
                        },
                        itemBuilder: (context, index) {
                          final eachClass = selectedData[index];
                          return EachClassWidget1(
                            eachClass: eachClass,
                            courseModel: eachClass.getCourseModel(courses: allCourses),
                          );
                        },
                      ),
                    ),
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        color: MyColors.bgWhite,
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(MyConstants.baseBorderRadius)
                        ),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: MyConstants.basePadding,
                              right: MyConstants.basePadding,
                              top: MyConstants.basePadding,
                              bottom: MyConstants.basePadding
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Total price",
                                    style: GoogleFonts.lato(
                                      color: MyColors.text1,
                                      fontSize: MyConstants.baseFontSizeXL,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  const Spacer(),
                                  Builder(
                                    builder: (context) {
                                      int total = 0;
                                      for (var each in cartController.selectedData.value) {
                                        final course = each.getCourseModel(courses: allCourses);
                                        if(course!=null){
                                          total = total + course!.pricePerClass.toInt();
                                        }
                                      }
                                      return Text(
                                        "£${total}",
                                        style: GoogleFonts.lato(
                                            color: MyColors.primary,
                                            fontSize: MyConstants.baseFontSizeXL,
                                            fontWeight: FontWeight.w600
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: MyConstants.basePadding,
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: MyConstants.baseButtonHeight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    onClickBooking();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(MyConstants.baseBorderRadius)
                                      )
                                  ),
                                  child: Text(
                                    "Book classes",
                                    style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w600,
                                        color: MyColors.primaryOver,
                                        fontSize: MyConstants.baseFontSizeL
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          }
        },
      )
    );
  }
}

