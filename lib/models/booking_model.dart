import 'package:flutter/material.dart';

class BookingModel{

  String id;
  String classId;
  String userId;
  DateTime bookingDate;

  BookingModel({
    required this.id,
    required this.classId,
    required this.userId,
    required this.bookingDate
  });

  factory BookingModel.fromFireStore({required Map<String,dynamic> data,required String id}){
    return BookingModel(
        id: id,
        classId: data["classId"].toString(),
        userId: data["userId"].toString(),
        bookingDate: DateTime.tryParse(data["bookingDate"].toString())??DateTime(1)
    );
  }

}