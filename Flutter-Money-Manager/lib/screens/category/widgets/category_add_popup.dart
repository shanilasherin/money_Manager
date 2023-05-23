import 'package:flutter/material.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/models/category/category_model.dart';

final _categoryNameController = TextEditingController();

ValueNotifier<CategoryType> selectedTypeNotifier =
    ValueNotifier(CategoryType.income);

Future<void> showCategoryAddPopup(BuildContext context) async {
  showDialog(
    context: context,
    builder: (ctx) {
      return SimpleDialog(
        title: const Text('Add Category'),
        children: [
          //CategoryName
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _categoryNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Category Name',
              ),
            ),
          ),
          //Radio Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              RadioButton(title: 'Income', type: CategoryType.income),
              RadioButton(title: 'Expense', type: CategoryType.expense),
            ],
          ),
          //Add Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                final _name = _categoryNameController.text;
                
                final caterory = CategoryModel(
                  id: DateTime.now().microsecondsSinceEpoch.toString(),
                  categoryName: _name,
                  type: selectedTypeNotifier.value,
                );

                // CategoryDB().insertCategory(caterory);
                CategoryDB.instance.insertCategory(caterory);
                
                Navigator.pop(ctx);
                _categoryNameController.text = '';
                // CategoryDB().refreshUI();
              },
              child: const Text('Add'),
            ),
          )
        ],
      );
    },
  );
}

class RadioButton extends StatelessWidget {
  final String title;
  final CategoryType type;
  // CategoryType? selectedType;

  const RadioButton({Key? key, required this.title, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
          valueListenable: selectedTypeNotifier,
          builder: (BuildContext ctx, CategoryType newSelectedType, Widget? _) {
            return Radio<CategoryType>(
              value: type,
              groupValue: newSelectedType,
              onChanged: (value) {
                // if(value == null){
                //   return;
                // }
                // selectedTypeNotifier.value = value;

                //OR

                selectedTypeNotifier.value = value!;
                selectedTypeNotifier.notifyListeners();
              },
            );
          },
        ),
        Text(title)
      ],
    );
  }
}
