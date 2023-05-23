import 'package:hive_flutter/hive_flutter.dart';
part 'category_model.g.dart';

@HiveType(typeId: 2)
enum CategoryType {

  @HiveField(0)
  income,
  @HiveField(1)
  expense,
}

@HiveType(typeId: 1)
class CategoryModel {
  
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String categoryName;

  @HiveField(2)
  final CategoryType type;

  @HiveField(3)
  final bool isDeleted; //soft deleting

  CategoryModel(
      {required this.id,
      required this.categoryName,
      required this.type,
      this.isDeleted = false});
  
  @override
  String toString() {
    
    return '$categoryName $type';
  }
  
}

