
import 'package:flutter/material.dart';

import 'my_colors.dart';
import 'my_constants.dart';

class MyWidgets{


  static Widget customTextField({
    required TextField baseTextField,
    double hPadding = MyConstants.basePaddingL
  }){
    return SizedBox(
      width: double.infinity,
      height: MyConstants.baseButtonHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: MyColors.textFieldBg,
            borderRadius: BorderRadius.circular(MyConstants.baseBorderRadiusS)
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: hPadding
          ),
          child: Center(child: baseTextField),
        ),
      ),
    );
  }

}