import 'package:yogaappcustomer/constants/my_assets_path.dart';
import 'package:yogaappcustomer/constants/my_functions.dart';

// List courseSeeders = [
//   {
//     "id": 1,
//     "courseName": "Morning Yoga",
//     "days": "Monday, Tuesday",
//     "time": "10:00",
//     "capacity": 20,
//     "duration": 60,
//     "pricePerClass": 15.0,
//     "type": "Yoga",
//     "description": "A refreshing morning yoga session",
//     "isFeatured": true,
//     "equipments": "Yoga suit, Water bottle, etc."
//   },
//   {
//     "id": 2,
//     "courseName": "Power Yoga",
//     "days": "Wednesday, Friday",
//     "time": "18:00",
//     "capacity": 25,
//     "duration": 75,
//     "pricePerClass": 20.0,
//     "type": "Yoga",
//     "description": "An intense yoga session for building strength.",
//     "isFeatured": true,
//     "equipments": "Yoga mat, Towel, Water bottle"
//   },
//   {
//     "id": 3,
//     "courseName": "Kids Yoga",
//     "days": "Saturday",
//     "time": "09:00",
//     "capacity": 15,
//     "duration": 45,
//     "pricePerClass": 10.0,
//     "type": "Yoga",
//     "description": "Fun and engaging yoga for kids.",
//     "isFeatured": false,
//     "equipments": "Yoga mat, Water bottle"
//   },
//   {
//     "id": 4,
//     "courseName": "Prenatal Yoga",
//     "days": "Thursday",
//     "time": "16:00",
//     "capacity": 10,
//     "duration": 50,
//     "pricePerClass": 18.0,
//     "type": "Yoga",
//     "description": "Yoga sessions tailored for expectant mothers.",
//     "isFeatured": true,
//     "equipments": "Yoga mat, Cushion, Water bottle"
//   },
//   {
//     "id": 5,
//     "courseName": "Advanced Ashtanga Yoga",
//     "days": "Monday, Thursday",
//     "time": "19:30",
//     "capacity": 12,
//     "duration": 90,
//     "pricePerClass": 25.0,
//     "type": "Yoga",
//     "description": "A challenging class for experienced practitioners.",
//     "isFeatured": false,
//     "equipments": "Yoga mat, Towel, Water bottle"
//   }
// ];

class CourseModel {
  int id;
  String courseName;
  String days;
  String time;
  int capacity;
  int duration;
  double pricePerClass;
  String type;
  String description;
  bool isFeatured;
  String equipments;

  CourseModel({
    required this.id,
    required this.courseName,
    required this.days,
    required this.time,
    required this.capacity,
    required this.duration,
    required this.pricePerClass,
    required this.type,
    required this.description,
    required this.isFeatured,
    required this.equipments,
  });

  factory CourseModel.fromFireStore({required Map<String, dynamic> data}) {
    superPrint(data);
    return CourseModel(
      id: data["id"],
      courseName: data["courseName"].toString(),
      days: data["day"].toString(),
      time: data["time"].toString(),
      capacity: data["capacity"],
      duration: data["duration"],
      pricePerClass: double.tryParse(data["pricePerClass"].toString()) ?? 0.0,
      type: data["type"].toString(),
      description: data["description"].toString(),
      isFeatured: data["featured"] ?? false,
      equipments: data["equipments"].toString(),
    );
  }

  String getImagePath ()=> MyAssetsPath.courseDummy;

  String getPriceLabel ()=> "£${pricePerClass.toInt()}";

}
