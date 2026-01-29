import 'package:fitmaxx/models/consumed_food_model.dart';
import 'package:fitmaxx/models/food_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitmaxx/models/user_model.dart';


/*class FoodService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String userId;

  List<Food> _foodLog = [];
  List<ConsumedFood> _dailyFoodLog = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Food> get foodLog => _foodLog;
  List<ConsumedFood> get dailyFoodLog => _dailyFoodLog;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;




  Future<void> logFood(Food food) async {
    try {
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('foodLog')
          .doc();

      await docRef.set(food.toMap());
      _foodLog.add(food);
      
    } catch (e) {
      print("Error logging food: $e");
    }
  }
}*/