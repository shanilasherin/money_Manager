import 'package:flutter/material.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/models/category/category_model.dart';

class IncomeList extends StatelessWidget {
  const IncomeList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: CategoryDB().incomeCategoryListNotifier,
        builder:
            (BuildContext ctx, List<CategoryModel> newincomeList, Widget? _) {
          return ListView.separated(
              itemBuilder: (ctx, index) {
                final _incomeCat = newincomeList[index];
                return ListTile(
                  title: Text(_incomeCat.categoryName),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      CategoryDB().deleteCategory(_incomeCat.id);
                      // CategoryDB().refreshUI();
                    },
                  ),
                );
              },
              separatorBuilder: (ctx, index) {
                return const Divider();
              },
              itemCount: newincomeList.length);
        });
  }
}
