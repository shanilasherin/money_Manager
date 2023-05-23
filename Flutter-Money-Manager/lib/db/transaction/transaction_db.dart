import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';

const transactionDbName = 'TransactionDB';

Future<Box<TransactionModel>> transactionDbAccess()async {
  final db = await Hive.openBox<TransactionModel>(transactionDbName);
  return db;
}
 
abstract class TranscationFunctions{

  Future<void> insertTransaction(TransactionModel obj);
  Future<List<TransactionModel>> getAllTransactions();
  Future<void> deleteTransaction(String id);
}

class TransactionDB implements TranscationFunctions{

  ValueNotifier<List<TransactionModel>> transactionListNotifier = ValueNotifier([]);

  //Single Ton
  TransactionDB._internal();
  static TransactionDB instance = TransactionDB._internal();
  factory TransactionDB(){
    return instance;
  }
  
  @override
  Future<void> insertTransaction(TransactionModel obj) async {
    
    final db = await transactionDbAccess();
    db.put(obj.id, obj);

    // refreshTransactionUI();
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async{
    
    final db = await transactionDbAccess();
    return db.values.toList();
  }
  
  Future<void> refreshTransactionUI() async{
    
    final _list = await getAllTransactions();
    _list.sort((first,second) => second.date.compareTo(first.date));

    transactionListNotifier.value.clear();
    transactionListNotifier.value.addAll(_list);
    transactionListNotifier.notifyListeners();
  }

  @override
  Future<void> deleteTransaction(String id) async{
    final db = await transactionDbAccess();
    await db.delete(id);
    refreshTransactionUI();
  }


}