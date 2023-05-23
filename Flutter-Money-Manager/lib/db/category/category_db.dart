import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager/models/category/category_model.dart';

// ignore: constant_identifier_names
const CATEGORY_DB_NAME = 'CategoryDB';

//Abstract class
abstract class CategoryDbFuctions {
  //Get
  Future<List<CategoryModel>> getCategories();
  //Insert
  Future<void> insertCategory(CategoryModel obj);
  //Delete
  Future<void> deleteCategory(String categoryId);
}

//Open database
Future<Box<CategoryModel>> hiveCategoryDbAccess() async {
  final db = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
  return db;
}

class CategoryDB implements CategoryDbFuctions {
  //SingleTon
  CategoryDB._internal();
  static CategoryDB instance = CategoryDB._internal();
  factory CategoryDB() {
    return instance;
  }
  //SingleTon

  ValueNotifier<List<CategoryModel>> incomeCategoryListNotifier =
      ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCategoryListNotifier =
      ValueNotifier([]);

  @override
  Future<void> insertCategory(CategoryModel obj) async {
    final db = await hiveCategoryDbAccess();

    // await db.add(obj);  //save with its auto-increment key.
    await db.put(obj.id,obj); //save with our id

   await refreshCategoryUI();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
  
    final db = await hiveCategoryDbAccess();
    return db.values.toList();
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    
    final db = await hiveCategoryDbAccess();
    await db.delete(categoryId);
    
    await refreshCategoryUI();
  }

  Future<void> refreshCategoryUI() async {
    incomeCategoryListNotifier.value.clear();
    expenseCategoryListNotifier.value.clear();

    final allCategories = await getCategories();

    
    Future.forEach(allCategories, (CategoryModel obj) {
      if (obj.type == CategoryType.income) {
        incomeCategoryListNotifier.value.add(obj);
      } else {
        expenseCategoryListNotifier.value.add(obj);
      }
    });
    incomeCategoryListNotifier.notifyListeners();
    expenseCategoryListNotifier.notifyListeners();
  }
}
