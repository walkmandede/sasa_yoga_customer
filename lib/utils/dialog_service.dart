import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yogaappcustomer/constants/my_colors.dart';
import 'package:yogaappcustomer/constants/my_constants.dart';

DialogRoute? dialogRoute;


class DialogService {

  void dismissDialog({required BuildContext context}) {
    try {
      if (dialogRoute != null) {
        Navigator.of(context).removeRoute(dialogRoute!);
        dialogRoute = null;
      }
    } catch (_) {}
  }

  Future<void> showConfirmDialog({
    required BuildContext context,
    String label = "Are you sure?",
    String yesLabel = "Confirm",
    String noLabel = "Cancel",
    Function()? onClickYes,
    Function()? onClickNo,
    Color yesBg = MyColors.primary
  }) async {

    if (dialogRoute != null) {
      dismissDialog(context: context);
    }

    dialogRoute = DialogRoute(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: MyColors.bgWhite,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(MyConstants.baseBorderRadius)
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: MyConstants.basePaddingL,
                vertical: MyConstants.basePaddingL
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                      fontSize: MyConstants.baseFontSizeL,
                      fontWeight: FontWeight.w600
                  ),
                ),
                const SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        height: MyConstants.baseButtonHeightMS,
                        child: ElevatedButton(
                          onPressed: () {
                            if (onClickNo != null) onClickNo();
                            dismissDialog(context: context);
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: MyColors.textFieldBg
                          ),
                          child: Text(
                            noLabel,
                            style: GoogleFonts.inter(
                                fontSize: MyConstants.baseFontSizeM,
                                fontWeight: FontWeight.w600,
                                color: MyColors.text1
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        height: MyConstants.baseButtonHeightMS,
                        child: ElevatedButton(
                          onPressed: () {
                            if (onClickYes != null) onClickYes();
                            dismissDialog(context: context);
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: yesBg
                          ),
                          child: Text(
                            yesLabel,
                            style: GoogleFonts.inter(
                                fontSize: MyConstants.baseFontSizeM,
                                fontWeight: FontWeight.w600,
                                color: MyColors.primaryOver
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
    Navigator.of(context).push(dialogRoute!);
  }


  Future<void> showLoadingDialog({
    required BuildContext context,
  }) async {
    if (dialogRoute != null) {
      dismissDialog(context: context);
    }

    dialogRoute = DialogRoute(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MyConstants.basePaddingL,
                vertical: MyConstants.basePaddingL
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: MyColors.primary,
              ),
            ),
          ),
        );
      },
    );
    Navigator.of(context).push(dialogRoute!);
  }

}
