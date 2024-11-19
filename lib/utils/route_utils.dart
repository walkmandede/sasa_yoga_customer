import 'package:flutter/material.dart';
import 'package:yogaappcustomer/views/cart_page.dart';
import 'package:yogaappcustomer/views/main_page.dart';
import 'package:yogaappcustomer/views/login_page.dart';
import 'package:yogaappcustomer/views/my_activities_page.dart';
import 'package:yogaappcustomer/views/profile_page.dart';
import 'package:yogaappcustomer/views/register_page.dart';
import 'package:yogaappcustomer/views/widgets/course_detail_page.dart';

class RouteUtils{

  static const String gatewayPage = "/";
  static const String loginPage = "/login";
  static const String registerPage = "/register";
  static const String mainPage = "/main";
  static const String profilePage = "/profile";
  static const String myActivitiesPage = "/my-activities";
  static const String cartPage = "/cart";
  static const String courseDetailPage = "/course-detail";

  final routes = {
    gatewayPage: (context) => const LoginPage(),
    loginPage: (context) => const LoginPage(),
    registerPage: (context) => const RegisterPage(),
    mainPage: (context) => const MainPage(),
    profilePage: (context) => const ProfilePage(),
    myActivitiesPage: (context) => const MyActivitiesPage(),
    cartPage: (context) => const CartPage(),
    courseDetailPage: (context) => const CourseDetailPage(),
  };

}