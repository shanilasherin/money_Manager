import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/db/transaction/transaction_db.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({Key? key}) : super(key: key);

  static const routeName = 'Add-Transaction';

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final _formKey = GlobalKey<FormState>(); //Important ***

  final _purposeController = TextEditingController();
  final _amountController = TextEditingController();

  // DateTime? _selectedDate;
  String? _selectedDate;
  // CategoryType? _selectedCategoryType;
  CategoryType _selectedCategoryType = CategoryType.income;
  CategoryModel? _selectedCategoryModel;

  DateTime? _selectedDate2;

  // @override
  // void initState() {
  //   _selectedCategoryType = CategoryType.income;
  //   super.initState();
  // }

  String? _CategoryID;

  /*
        purpose
        amount
        Date
        expense/income
        categoryName        
      */

  @override
  Widget build(BuildContext context) {
    // CategoryDB().refreshUI();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Purpose
                TextFormField(
                    controller: _purposeController,
                    decoration: const InputDecoration(hintText: 'Purpose'),
                    validator: (givingValue) {
                      if (givingValue == null || givingValue.isEmpty) {
                        return 'value is Empty';
                      } else {
                        return null;
                      }
                    }),

                //Amount
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _amountController,
                  decoration: const InputDecoration(hintText: 'Amount'),
                  validator: (givingValue) {
                    if (givingValue == null || givingValue.isEmpty) {
                      return 'value is Empty';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),

                //Date

                // _selectedDate == null

                //     ? TextButton.icon(
                //         onPressed: () async {
                //           final _selectedDateTemp = await showDatePicker(
                //             context: context,
                //             initialDate: DateTime.now(),
                //             firstDate:
                //                 DateTime.now().subtract(const Duration(days: 60)),
                //             lastDate: DateTime.now(),
                //           );
                //           // print(_selectedDate);
                //           setState(() {
                //             _selectedDate = _selectedDateTemp;
                //           });
                //         },
                //         icon: const Icon(Icons.calendar_today),
                //         label: const Text('Select Date'),
                //       )

                //     : Text(_selectedDate.toString()),

                TextButton.icon(
                  onPressed: () async {
                    final _selectedDateTemp = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 60)),
                      lastDate: DateTime.now(),
                    );
                    // print(_selectedDate);

                    var date = DateTime.parse(_selectedDateTemp.toString());
                    var formattedDate =
                        "${date.day}-${date.month}-${date.year}";
                    setState(() {
                      // _selectedDate = _selectedDateTemp;
                      _selectedDate = formattedDate;
                      _selectedDate2 = _selectedDateTemp;
                    });
                  },
                  icon: const Icon(Icons.calendar_today),

                  // label: _selectedDate == null
                  //     ? const Text('Select Date')
                  //     // : Text(_selectedDate.toString()), //when _selectedDate is a DateTime datatype
                  //     : Text(_selectedDate!),

                  // label: Text(_selectedDate == null
                  //     ? 'Select Date'
                  //     : _selectedDamountTextate!),

                  label: Text(_selectedDate ?? 'Select Date'), //*** Important
                ),

                //Date End

                const SizedBox(
                  height: 10,
                ),

                //Income / Expense
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Radio<CategoryType>(
                          value: CategoryType.income,
                          groupValue: _selectedCategoryType,
                          onChanged: (newValue) {
                            setState(() {
                              // _selectedCategoryType = CategoryType.income;
                              _selectedCategoryType = newValue!;

                              _CategoryID = null; //Important for Dropdown
                            });
                          },
                        ),
                        const Text('Income')
                      ],
                    ),
                    Row(
                      children: [
                        Radio<CategoryType>(
                          value: CategoryType.expense,
                          groupValue: _selectedCategoryType,
                          onChanged: (newValue) {
                            setState(() {
                              //  _selectedCategoryType = CategoryType.expense;
                              _selectedCategoryType = newValue!;

                              _CategoryID = null; //Important for Dropdown
                            });
                          },
                        ),
                        const Text('Expense')
                      ],
                    ),
                  ],
                ),

                //Category Type ---> [DropDown]
                DropdownButtonFormField<String>(
                  value: _CategoryID,
                  hint: const Text('Select Category'),
                  items: (_selectedCategoryType == CategoryType.income
                          ? CategoryDB().incomeCategoryListNotifier
                          : CategoryDB().expenseCategoryListNotifier)
                      .value
                      .map((eachCategory) {
                    return DropdownMenuItem(
                      child: Text(eachCategory.categoryName),
                      value: eachCategory.id,

                      //important
                      onTap: (){ 

                        _selectedCategoryModel = eachCategory;
                      },
                    );
                  }).toList(),

                  //important
                  onChanged: (selectedItemId) { 
                    setState(() {
                      _CategoryID = selectedItemId;
                    });
                  },

                  validator: (givingValue){
                    if (givingValue == null || givingValue.isEmpty) {
                      return 'Select Category';
                    } else {
                      return null;
                    }
                  },
                ),

                //Submit
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      addEachTrasaction();
                    },
                    child: const Text('Submit'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addEachTrasaction() async {
    final purposeText = _purposeController.text;
    final amountText = _amountController.text;

    // if(purposeText.isEmpty){
    //   return;
    // }
    // if(amountText.isEmpty){
    //   return;
    // }

    //To auto Validate purposeText and amountText
    _formKey.currentState!.validate();

    final parsedAmount = double.tryParse(amountText);   //we want integer
    
    if(parsedAmount == null){   // or adding '!' in parsedAmount
      return;
    }

    //validate Datetime
    if(_selectedDate2 == null){
      return;
    }

    if(_selectedCategoryModel == null){
      return;
    }

    DateTime now = DateTime.now();
    String formattedTime = DateFormat('KK:mm a').format(now);
    print(formattedTime);

    final _model = TransactionModel(
      purpose: purposeText,
      amount: parsedAmount,
      date: _selectedDate2!,
      time: formattedTime,
      type: _selectedCategoryType,
      category: _selectedCategoryModel!,
    );

    await TransactionDB.instance.insertTransaction(_model);
    
    Navigator.pop(context);
    TransactionDB.instance.refreshTransactionUI();
  }
}
