import 'package:flutter/material.dart';
import 'package:money_manager/screens/category/category_page.dart';
import 'package:money_manager/screens/category/widgets/category_add_popup.dart';
import 'package:money_manager/screens/home/Widgets/bottom_navigation_bar.dart';
import 'package:money_manager/screens/transactions/alltransactions_page.dart';
import 'package:money_manager/screens/transactions/widgets/add_transaction_page.dart';

class HomeScreen extends StatelessWidget {
  
  HomeScreen({Key? key}) : super(key: key);
  
  final pages = [TransactionPage(), CategoryPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Money Manager'),
        centerTitle: true,
      ),
      // body: const SafeArea(child: Center(child: Text('Home'))),
      body: ValueListenableBuilder(
        valueListenable: BottomNavBar.selectedIndex,
        builder: (BuildContext ctx, int newIndex, Widget? _) {
          return pages[newIndex];
          // return pages.elementAt(newIndex);
        },
      ),
      bottomNavigationBar: BottomNavBar(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (BottomNavBar.selectedIndex.value == 0) {
              // print('trans');

              Navigator.pushNamed(context, AddTransaction.routeName);
            } else {
              // print('cat');
              // final _sample = CategoryModel(
              //   id: DateTime.now().microsecondsSinceEpoch.toString(),
              //   categoryName: 'Travel',
              //   type: CategoryType.expense,
              // );
              // CategoryDB().insertCategory(_sample);
              showCategoryAddPopup(context);
            }
          },
          child: const Icon(
            Icons.add,
            size: 30,
          )),
    );
  }
}
