import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:yogaappcustomer/constants/my_functions.dart';
import 'package:yogaappcustomer/controllers/cart_controller.dart';
import 'package:yogaappcustomer/models/class_model.dart';
import 'package:yogaappcustomer/models/course_model.dart';

import '../../constants/my_colors.dart';
import '../../constants/my_constants.dart';
import '../../constants/my_svg_data.dart';

class EachClassWidget1 extends StatelessWidget {
  final ClassModel eachClass;
  final bool isCartButtonIncluded;
  final CourseModel? courseModel;
  const EachClassWidget1({super.key,required this.eachClass,this.isCartButtonIncluded = true,required this.courseModel});

  @override
  Widget build(BuildContext context) {
    CartController cartController = CartController();
    final baseWidth = MyFunctions.getMediaQuerySize(context: context).width;
    return DecoratedBox(
      decoration: BoxDecoration(
          color: MyColors.bgWhite,
          borderRadius: BorderRadius.circular(MyConstants.baseBorderRadius)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: MyConstants.basePadding,
          vertical: MyConstants.basePadding * 0.7,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: baseWidth * 0.1,
              height: baseWidth * 0.1,
              child: AspectRatio(
                aspectRatio: 1,
                child: CircleAvatar(
                  backgroundColor: MyColors.primary,
                  backgroundImage: Image.asset(eachClass.getImagePath()).image,
                ),
              ),
            ),
            SizedBox(width: baseWidth * 0.05,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: baseWidth * 0.1,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 4,
                                child: FittedBox(
                                  child: Text(
                                    eachClass.className,
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w600,
                                      color: MyColors.text1,
                                      fontSize: MyConstants.baseFontSizeS
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              const Expanded(flex: 1,child: SizedBox.shrink()),
                              Expanded(
                                flex: 4,
                                child: FittedBox(
                                  child: Text(
                                    courseModel==null?"-":courseModel!.getPriceLabel(),
                                    style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w600,
                                        color: MyColors.primary,
                                        fontSize: MyConstants.baseFontSizeS
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              const Expanded(flex: 1,child: SizedBox.shrink())
                            ],
                          ),
                        ),
                        if(isCartButtonIncluded)SizedBox(
                          width: baseWidth * 0.1,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: ValueListenableBuilder(
                              valueListenable: cartController.selectedData,
                              builder: (context, selectedData, child) {
                                final isInCart = cartController.isAlreadyInCart(model: eachClass);
                                return InkWell(
                                  onTap: () {
                                    cartController.toggleItem(model: eachClass);
                                  },
                                  child: SvgPicture.string(
                                    isInCart?MySvgData.removeFromCart:MySvgData.addToCart,
                                  ),
                                );
                              },
                            )
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: MyConstants.basePadding*0.5,),
                  Text(
                    eachClass.comment,
                    style: GoogleFonts.lato(
                        fontSize: MyConstants.baseFontSizeM,
                        fontWeight: FontWeight.normal,
                        color: MyColors.text1
                    ),
                    textAlign: TextAlign.left,
                    maxLines: 3,
                  ),
                  const SizedBox(height: MyConstants.basePadding*0.5,),
                  Row(
                    children: [
                      SvgPicture.string(
                        MySvgData.person,
                        colorFilter: const ColorFilter.mode(MyColors.text1, BlendMode.srcIn),
                      ),
                      SizedBox(width: baseWidth * 0.015,),
                      Expanded(
                        child: Text(
                          eachClass.teacherName,
                          style: GoogleFonts.lato(
                              fontSize: MyConstants.baseFontSizeM,
                              fontWeight: FontWeight.normal,
                              color: MyColors.text1
                          ),
                          maxLines: 1,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: MyConstants.basePadding*0.7,),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: MyColors.primary,
                      borderRadius: BorderRadius.circular(40000)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4
                      ),
                      child: Text(
                        DateFormat("MMM dd, yyyy").format(eachClass.dateTime),
                        style: GoogleFonts.lato(
                            color: MyColors.primaryOver,
                            fontSize: MyConstants.baseFontSizeM,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
    return AspectRatio(
      aspectRatio: 358/175,
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: MyColors.bgWhite,
            borderRadius: BorderRadius.circular(MyConstants.baseBorderRadius)
        ),
        child: LayoutBuilder(
          builder: (a1, c1) {
            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: c1.maxWidth * 0.05,
                  vertical: c1.maxHeight * 0.1
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: MyColors.primary,
                    backgroundImage: Image.asset(eachClass.getImagePath()).image,
                  ),
                  SizedBox(width: c1.maxWidth * 0.05,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        eachClass.className,
                                        style: GoogleFonts.lato(
                                            fontSize: MyConstants.baseFontSizeXL,
                                            fontWeight: FontWeight.w600,
                                            color: MyColors.text1
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          SvgPicture.string(
                                            MySvgData.person,
                                            colorFilter: const ColorFilter.mode(MyColors.text1, BlendMode.srcIn),
                                          ),
                                          SizedBox(width: c1.maxWidth * 0.025,),
                                          Expanded(
                                            child: Text(
                                              eachClass.teacherName,
                                              style: GoogleFonts.lato(
                                                  fontSize: MyConstants.baseFontSizeL,
                                                  fontWeight: FontWeight.normal,
                                                  color: MyColors.text1
                                              ),
                                              maxLines: 1,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // SizedBox()
                              ValueListenableBuilder(
                                valueListenable: cartController.selectedData,
                                builder: (context, selectedData, child) {
                                  final isInCart = cartController.isAlreadyInCart(model: eachClass);
                                  return InkWell(
                                    onTap: () {
                                      cartController.toggleItem(model: eachClass);
                                    },
                                    child: SvgPicture.string(
                                      isInCart?MySvgData.removeFromCart:MySvgData.addToCart,
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              eachClass.comment,
                              style: GoogleFonts.lato(
                                  fontSize: MyConstants.baseFontSizeL,
                                  fontWeight: FontWeight.normal,
                                  color: MyColors.text1
                              ),
                              maxLines: 3,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: FittedBox(
                            alignment: Alignment.centerLeft,
                            child: Chip(
                              backgroundColor: MyColors.primary,
                              label: Text(
                                DateFormat("MMM dd, yyyy").format(eachClass.dateTime),
                                style: GoogleFonts.lato(
                                    color: MyColors.primaryOver,
                                    fontSize: MyConstants.baseFontSizeL,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                            ),
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
    );
  }
}
