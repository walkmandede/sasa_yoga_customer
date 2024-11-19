
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yogaappcustomer/controllers/data_controller.dart';
import 'package:yogaappcustomer/models/class_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String collectionUsers = "users";
  static const String collectionBookings = "bookings";
  static const String collectionClasses = "classes";
  static const String collectionCourses = "courses";

  // Login function to check email and password in Firestore
  Future<QuerySnapshot<Map<String, dynamic>>?> login({
    required String email,
    required String password,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection(collectionUsers)
          .where("email", isEqualTo: email)
          .where("password", isEqualTo: password)
          .get();

      return querySnapshot;
    } catch (e) {
      return null;
    }
  }

  // Register function to add a new user to Firestore
  Future<String?> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Check if the user already exists
      final existingUser = await _firestore
          .collection(collectionUsers)
          .where("email", isEqualTo: email)
          .get();

      if (existingUser.docs.isNotEmpty) {
        return "Email already registered"; // Failure: return error message
      }

      // Add new user if email is not registered
      await _firestore.collection(collectionUsers).add({
        "email": email,
        "name" : name,
        "password": password, // Consider hashing the password for security
      });

      return null; // Success: return null
    } catch (e) {
      return "Error during registration: $e"; // Failure: return error message
    }
  }

  /// Checks if an email is already registered
  /// Returns null if there is no user, or a string error message if email is registered
  Future<String?> isEmailRegistered(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection(collectionUsers)
          .where("email", isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return "This email is already registered!";
      } else {
        return null; // Email not registered
      }
    } catch (e) {
      return "Unable to connect to the server!"; // Return error message on failure
    }
  }


  Future<String?> bookClasses({
    required ClassModel classModel,
  }) async {
    try {
      DataController dataController = DataController();
      // Add new user if email is not registered
      await _firestore.collection(collectionBookings).add({
        "classId": classModel.id,
        "userId" : dataController.profileModel.value.id,
        "bookingDate" : DateTime.now().toUtc().toIso8601String()
      });

      return null; // Success: return null
    } catch (e) {
      return "Error during registration: $e"; // Failure: return error message
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>?> getBookings() async{
    try {
      DataController dataController = DataController();
      final querySnapshot = await _firestore
          .collection(collectionBookings)
          .where("userId", isEqualTo: dataController.profileModel.value.id)
          .get();

      return querySnapshot;
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getClasses() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection(collectionClasses).get();
      return querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getCourses() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection(collectionCourses).get();
      return querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    } catch (e) {
      return [];
    }
  }

}
