import 'package:flutter/material.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/models/category/category_model.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: CategoryDB().expenseCategoryListNotifier,
        builder:
            (BuildContext ctx, List<CategoryModel> newExpenseList, Widget? _) {
          return ListView.separated(
              itemBuilder: (ctx, index) {
                final _expenseCat = newExpenseList[index];
                return ListTile(
                  title: Text(_expenseCat.categoryName),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                       CategoryDB().deleteCategory(_expenseCat.id);
                    },
                  ),
                );
              },
              separatorBuilder: (ctx, index) {
                return const Divider();
              },
              itemCount: newExpenseList.length);
        });
  }
}
