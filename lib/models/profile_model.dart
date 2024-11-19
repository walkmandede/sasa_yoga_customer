import 'package:flutter/material.dart';

class ProfileModel{

  String id;
  String name;
  String email;
  String password;

  ProfileModel({
    required this.id,
    required this.email,
    required this.name,
    required this.password
  });

  factory ProfileModel.fromFireStore({required Map<String,dynamic> data,required String id}){
    return ProfileModel(
      id: id,
      email: data["email"].toString(),
      name: data["name"].toString(),
      password: data["password"].toString()
    );
  }

  String getInitial(){
    List<String> words = name.trim().split(' ');

    if (words.length > 1) {
      return '${words.first[0].toUpperCase()}${words.last[0].toUpperCase()}';
    }

    return words.first[0].toUpperCase();
  }

  bool isValidProfile(){
    return id != "";
  }

}