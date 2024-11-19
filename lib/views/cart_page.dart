import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yogaappcustomer/constants/my_colors.dart';
import 'package:yogaappcustomer/constants/my_constants.dart';
import 'package:yogaappcustomer/controllers/cart_controller.dart';
import 'package:yogaappcustomer/utils/dialog_service.dart';
import 'package:yogaappcustomer/utils/firebase_services.dart';
import 'package:yogaappcustomer/utils/route_utils.dart';
import 'package:yogaappcustomer/views/widgets/each_class_widget_1.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {

    CartController cartController = CartController();

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
          Navigator.pushReplacementNamed(context, RouteUtils.mainPage);
          Navigator.pushNamed(context, RouteUtils.myActivitiesPage);
        },
      );
    }


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
                    return EachClassWidget1(eachClass: eachClass);
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
                    child: SizedBox(
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
                  ),
                ),
              )
            ],
          );
        },
      )
    );
  }

}

