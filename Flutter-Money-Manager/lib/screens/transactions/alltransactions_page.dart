import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/db/transaction/transaction_db.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  void initState() {
    CategoryDB().refreshCategoryUI();
    TransactionDB.instance.refreshTransactionUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return const Center(child: Text('transaction'));
    return ValueListenableBuilder(
        valueListenable: TransactionDB.instance.transactionListNotifier,
        builder: (BuildContext ctx, List<TransactionModel> newList, Widget? _) {
          return StickyGroupedListView<TransactionModel, DateTime>(
            elements: newList,
            order: StickyGroupedListOrder.DESC,
            groupBy: (TransactionModel newList) {
              return DateTime(
                  newList.date.year, newList.date.month, newList.date.day);
            },
            groupSeparatorBuilder: (TransactionModel element) => SizedBox(
              height: 50,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.blue[300],
                    border: Border.all(
                      color: Colors.blue[300]!,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${element.date.day} / ${element.date.month} / ${element.date.year}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            itemBuilder: (_, TransactionModel element) {
              return Slidable(
                key: Key(element.id!),
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (ctx) {
                        TransactionDB.instance.deleteTransaction(element.id!);
                      },
                      icon: Icons.delete,
                      label: 'Delete',
                    )
                  ],
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  elevation: 8.0,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 6.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    leading: Transform.translate(
                      offset: const Offset(-40, 0),
                      child: CircleAvatar(
                        backgroundColor: element.type == CategoryType.income
                            ? Colors.green
                            : Colors.red,
                        radius: 75,
                        child: Text(
                          parseDate(element.date),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    horizontalTitleGap: -36.0,
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        element.purpose,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(element.amount.toString()),
                    ),
                    dense: true,
                    trailing: Text(element.time),
                  ),
                ),
              );
            },
          );
        });
  }

  String parseDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final _splitedDate = _date.split(' '); //array with elements split by ' '
    return '${_splitedDate.last}\n${_splitedDate.first}';

    // return DateFormat.MMMd().format(date);
    // return '${date.day}\n${date.month}';
  }
}


// return Slidable(
                  
//                   key: Key(_data.id!),
//                   startActionPane: ActionPane(
//                     motion: const ScrollMotion(),
//                     children: [
//                       SlidableAction(onPressed: (ctx){
//                         TransactionDB.instance.deleteTransaction(_data.id!);
//                       }, icon: Icons.delete,label: 'Delete',)
//                     ],
//                   ),


//                   child: Card(
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         backgroundColor: _data.type == CategoryType.income
//                             ? Colors.green
//                             : Colors.red,
//                         radius: 75,
//                         child: Text(
//                           parseDate(_data.datetime),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                       title: Text('Rs. ${_data.amount}'),
//                       subtitle: Text(_data.category.categoryName),
//                     ),
//                   ),
//                 );