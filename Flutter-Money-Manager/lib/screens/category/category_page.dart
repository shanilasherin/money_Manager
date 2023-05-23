import 'package:flutter/material.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/screens/category/widgets/expense_list.dart';
import 'package:money_manager/screens/category/widgets/income_list.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    // CategoryDB().getCategories().then((value) {
    //   print('Caterogy Get');
    //   print(value.toString());
    // });
    
    CategoryDB().refreshCategoryUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'INCOME'),
            Tab(text: 'EXPENSE'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [IncomeList(), ExpenseList()],
          ),
        )
      ],
    );
  }
}






// import 'package:flutter/material.dart';

// class CategoryPage extends StatefulWidget {
//   const CategoryPage({Key? key}) : super(key: key);

//   @override
//   State<CategoryPage> createState() => _CategoryPageState();
// }

// class _CategoryPageState extends State<CategoryPage> {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Column(
//         children: const [
//           TabBar(
//             labelColor: Colors.black,
//             unselectedLabelColor: Colors.grey,
//             tabs: [
//               Tab(text: 'INCOME'),
//               Tab(text: 'EXPENSE'),
//             ],
//           ),
//           Expanded(
//             child: TabBarView(
//               children: [Text('S1'), Text('S2')],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
