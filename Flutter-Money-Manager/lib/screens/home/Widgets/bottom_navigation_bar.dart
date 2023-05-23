import 'package:flutter/material.dart';


class BottomNavBar extends StatelessWidget {
  BottomNavBar({Key? key}) : super(key: key);

  static ValueNotifier<int> selectedIndex = ValueNotifier(0);
  
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedIndex,
      builder: (BuildContext context, int newIndex, _) {
        return BottomNavigationBar(
          items: const [

            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Transactions'),
            BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Category')
          ],
          currentIndex: newIndex,
          onTap: (index){
            
            selectedIndex.value = index;
          },
        );
      }
    );
  }
}
