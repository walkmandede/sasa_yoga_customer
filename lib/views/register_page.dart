import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yogaappcustomer/constants/my_colors.dart';
import 'package:yogaappcustomer/constants/my_constants.dart';
import 'package:yogaappcustomer/constants/my_functions.dart';
import 'package:yogaappcustomer/constants/my_svg_data.dart';
import 'package:yogaappcustomer/constants/my_widgets.dart';
import 'package:yogaappcustomer/utils/dialog_service.dart';
import 'package:yogaappcustomer/utils/firebase_services.dart';

import '../utils/route_utils.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  TextEditingController txtEmail = TextEditingController(text: "");
  TextEditingController txtName = TextEditingController(text: "");
  TextEditingController txtPassword = TextEditingController(text: "");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> onClickRegister() async{

    //validation
    if(!MyFunctions.isValidEmail(txtEmail.text)){
      DialogService().showConfirmDialog(
        context: context,
        label: "Invalid Email"
      );
    }
    else if(txtName.text.isEmpty){
      DialogService().showConfirmDialog(
          context: context,
          label: "Invalid Name"
      );
    }
    else if(txtPassword.text.length<6){
      DialogService().showConfirmDialog(
          context: context,
          label: "Password is too short"
      );
    }
    else{
      DialogService().showLoadingDialog(context: context);

      final result = await FirebaseService().register(
          email: txtEmail.text,
          password: txtPassword.text,
          name: txtName.text
      );
      DialogService().dismissDialog(context: context);

      if(result!=null){
        //fail
        DialogService().showConfirmDialog(
            context: context,
            label: result
        );
      }
      else{
        //success
        Navigator.pushReplacementNamed(context, RouteUtils.loginPage);
        DialogService().showConfirmDialog(
            context: context,
            label: "Registered successfully!\nPlease login to continue!"
        );
      }

    }

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: MyColors.bgGrey,
        ),
        backgroundColor: MyColors.bgGrey,
        resizeToAvoidBottomInset: true,
        body: SizedBox.expand(
          child: LayoutBuilder(
            builder: (a1, c1) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: c1.maxWidth,
                      height: c1.maxHeight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: MyFunctions.getMediaQuerySize(context: context).width * 0.75,
                              child: FittedBox(
                                alignment: Alignment.topLeft,
                                child: _topWidget(),
                              ),
                            ),
                          ),
                          _inputWidget()
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
    );
  }

  _topWidget() {
    return Padding(
      padding: const EdgeInsets.all(MyConstants.basePaddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: MyFunctions.getMediaQuerySize(context: context).width * 0.75,
            child: FittedBox(
              child: Text(
                "Register",
                style: GoogleFonts.abrilFatface(
                    fontSize: 35,
                    color: MyColors.text1
                ),
              ),
            ),
          ),
          SizedBox(
            width: MyFunctions.getMediaQuerySize(context: context).width * 0.5,
            child: FittedBox(
              child: Text(
                "Join our system\nEnjoy Yoga classes",
                style: GoogleFonts.roboto(
                    fontSize: 35,
                    fontWeight: FontWeight.w600,
                    color: MyColors.text1
                ),
              ),
            ),
          ),
          SizedBox(height: MyFunctions.getMediaQuerySize(context: context).height * 0.05,),
          SizedBox(
            width: MyFunctions.getMediaQuerySize(context: context).width * 0.15,
            child: Row(
              children: [
                Expanded(
                  child: FittedBox(
                    child: SvgPicture.string(
                      MySvgData.appLogoBlackDownWard,
                    ),
                  ),
                ),
                Expanded(
                  child: FittedBox(
                    child: SvgPicture.string(
                      MySvgData.appLogoWhiteUpWard,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _inputWidget() {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: MyColors.bgWhite,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(MyConstants.baseBorderRadius)
          )
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: MyConstants.basePadding,
            right: MyConstants.basePadding,
            top: MyConstants.basePadding*2,
            bottom: MyConstants.basePadding
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Display Name",
                style: GoogleFonts.inter(
                    fontSize: MyConstants.baseFontSizeXL,
                    fontWeight: FontWeight.w600,
                    color: MyColors.text1
                ),
              ),
              const SizedBox(height: 10,),
              MyWidgets.customTextField(
                  baseTextField: TextField(
                    controller: txtName,
                    onTapOutside: (event) => dismissKeyboard(),
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600
                    ),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "John Doe",
                        hintStyle: GoogleFonts.inter(
                            color: MyColors.text2
                        )
                    ),
                  )
              ),
              const SizedBox(height: 20,),
              Text(
                "Email address",
                style: GoogleFonts.inter(
                    fontSize: MyConstants.baseFontSizeXL,
                    fontWeight: FontWeight.w600,
                    color: MyColors.text1
                ),
              ),
              const SizedBox(height: 10,),
              MyWidgets.customTextField(
                  baseTextField: TextField(
                    controller: txtEmail,
                    onTapOutside: (event) => dismissKeyboard(),
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600
                    ),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "test@email.com",
                        hintStyle: GoogleFonts.inter(
                            color: MyColors.text2
                        )
                    ),
                  )
              ),
              const SizedBox(height: 20,),
              Text(
                "Password",
                style: GoogleFonts.inter(
                    fontSize: MyConstants.baseFontSizeXL,
                    fontWeight: FontWeight.w600,
                    color: MyColors.text1
                ),
              ),
              const SizedBox(height: 10,),
              MyWidgets.customTextField(
                  baseTextField: TextField(
                    controller: txtPassword,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600
                    ),
                    onTapOutside: (event) => dismissKeyboard(),
                    obscureText: true,
                    obscuringCharacter: "*",
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "********",
                      hintStyle: GoogleFonts.inter(
                          color: MyColors.text2
                      )
                    ),
                  )
              ),
              const SizedBox(height: 20,),
              SizedBox(
                width: double.infinity,
                height: MyConstants.baseButtonHeight,
                child: ElevatedButton(
                  onPressed: () {
                    onClickRegister();
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(MyConstants.baseBorderRadius)
                    )
                  ),
                  child: Text(
                    "Register Now",
                    style: GoogleFonts.inter(
                        color: MyColors.primaryOver,
                        fontWeight: FontWeight.bold,
                        fontSize: MyConstants.baseFontSizeL
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
