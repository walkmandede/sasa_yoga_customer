import 'package:yogaappcustomer/constants/my_assets_path.dart';
import 'package:yogaappcustomer/constants/my_functions.dart';

class ClassModel{
  String id;
  String courseId;
  String className;
  DateTime dateTime;
  String teacherName;
  String comment;
  bool isDeleted;

  ClassModel({
    required this.id,
    required this.dateTime,
    required this.comment,
    required this.teacherName,
    required this.courseId,
    required this.className,
    required this.isDeleted
  });

  factory ClassModel.fromFireStore({required Map<String,dynamic> data}){
    superPrint(data);
    return ClassModel(
      id: data["id"].toString(),
      teacherName: data["teacher"].toString(),
      courseId: data["courseId"].toString(),
      comment: data["comment"].toString(),
      className: data["className"].toString(),
      dateTime: DateTime.tryParse(data["date"].toString())??DateTime(0),
      isDeleted: bool.tryParse(data["deleted"].toString())??false
    );
  }

  String getImagePath ()=> MyAssetsPath.classDummy;

  String getInitial(){
    List<String> words = teacherName.trim().split(' ');

    if (words.length > 1) {
      return '${words.first[0].toUpperCase()}${words.last[0].toUpperCase()}';
    }

    return words.first[0].toUpperCase();
  }

}