import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yogaappcustomer/constants/my_assets_path.dart';
import 'package:yogaappcustomer/constants/my_colors.dart';
import 'package:yogaappcustomer/constants/my_constants.dart';
import 'package:yogaappcustomer/constants/my_functions.dart';
import 'package:yogaappcustomer/constants/my_svg_data.dart';
import 'package:yogaappcustomer/controllers/data_controller.dart';
import 'package:yogaappcustomer/utils/dialog_service.dart';
import '../utils/route_utils.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  DataController dataController = DataController();
  double baseAspectRatio = 390/187;

  Future<void> onClickLogOut() async{
    DialogService().showConfirmDialog(
      context: context,
      label: "Are you sure to logout?",
      onClickYes: () async{
        await Future.delayed(const Duration(milliseconds: 100));
        Navigator.pushNamedAndRemoveUntil(context, RouteUtils.loginPage,(route) => false,);
        superPrint(Navigator.defaultRouteName);
      },
      yesBg: MyColors.redDanger
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
          "Profile",
          style: GoogleFonts.inter(
            color: MyColors.text1,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: SizedBox.expand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: baseAspectRatio,
              child: SizedBox.expand(
                child: LayoutBuilder(
                  builder: (a1, c1) {
                    return Stack(
                      children: [
                        Image.asset(
                          MyAssetsPath.profileBg,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Transform.translate(
                          offset: Offset(
                              c1.maxWidth * 0.05,
                              c1.maxHeight * 0.75
                          ),
                          child: SizedBox(
                            height: c1.maxHeight * 0.5,
                            child: AspectRatio(
                                aspectRatio: 1,
                                child: DecoratedBox(
                                  decoration: const BoxDecoration(
                                      color: MyColors.primaryOver,
                                      shape: BoxShape.circle
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(c1.maxHeight * 0.025),
                                    child: Hero(
                                      tag: "profileImage",
                                      child: CircleAvatar(
                                        backgroundColor: MyColors.primary,
                                        child: Padding(
                                          padding: EdgeInsets.all(c1.maxHeight * 0.1),
                                          child: FittedBox(
                                            alignment: Alignment.center,
                                            child: ValueListenableBuilder(
                                              valueListenable: dataController.profileModel,
                                              builder: (context, profileModel, child) {
                                                return Text(
                                                  profileModel.getInitial(),
                                                  style: GoogleFonts.roboto(
                                                      color: MyColors.primaryOver,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 100
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
            //spacer
            AspectRatio(
              aspectRatio: baseAspectRatio * 4,
            ),
            Expanded(
              child: SizedBox.expand(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: MyConstants.basePadding,
                    vertical: MyConstants.basePadding
                  ),
                  child: ValueListenableBuilder(
                    valueListenable: dataController.profileModel,
                    builder: (context, profileModel, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profileModel.name,
                            style: GoogleFonts.inter(
                              color: MyColors.text1,
                              fontSize: MyConstants.baseFontSizeXXL,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                          ),
                          const SizedBox(height: 10,),
                          Text(
                            profileModel.email,
                            style: GoogleFonts.inter(
                              color: MyColors.text2,
                              fontSize: MyConstants.baseFontSizeL,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20,),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: MyColors.bgWhite,
                              borderRadius: BorderRadius.circular(MyConstants.baseBorderRadius)
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: MyConstants.basePadding,
                                  vertical: MyConstants.basePadding
                                ),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(context, RouteUtils.myActivitiesPage);
                                      },
                                      child: Row(
                                        children: [
                                          SvgPicture.string(
                                            MySvgData.myActivities,
                                            colorFilter: const ColorFilter.mode(MyColors.text1, BlendMode.srcIn),
                                          ),
                                          const SizedBox(width: 16,),
                                          Text(
                                            "My activities",
                                            style: GoogleFonts.inter(
                                              color: MyColors.text1,
                                              fontWeight: FontWeight.w500,
                                              fontSize: MyConstants.baseFontSizeL
                                            ),
                                          ),
                                          const Spacer(),
                                          const Icon(Icons.arrow_forward_ios_rounded,color: MyColors.text1,)
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: MyConstants.basePadding,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        onClickLogOut();
                                      },
                                      child: Row(
                                        children: [
                                          SvgPicture.string(
                                            MySvgData.logOut,
                                            colorFilter: const ColorFilter.mode(MyColors.redDanger, BlendMode.srcIn),
                                          ),
                                          const SizedBox(width: 16,),
                                          Text(
                                            "Logout",
                                            style: GoogleFonts.inter(
                                              color: MyColors.redDanger,
                                              fontWeight: FontWeight.w500,
                                              fontSize: MyConstants.baseFontSizeL
                                            ),
                                          ),
                                        ],
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
                  )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
