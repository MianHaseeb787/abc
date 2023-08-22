import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:printing/printing.dart';
import 'Hive/employee.dart';
import 'boxes.dart';

class EmployeeScreen extends StatefulWidget {
  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  // late final Box<Employee> employeeBox;
  List<Employee> employees = [];
  String selectedMonth =
      DateTime.now().month.toString(); // Default selected month

  int? selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    // employeeBox = Hive.box<Employee>('employees');

    print(selectedYear);
  }

  List<Employee> getEmployeesForSelectedMonth() {
    employees = boxEmployees.values.toList();
    return employees
        .where((employee) =>
            (employee.month == selectedMonth && employee.year == selectedYear))
        .toList();
  }

  void _addEmployee(Employee employee) {
    setState(() {
      // employees.add(employee);
      boxEmployees.add(employee);
      print('addded');
      Navigator.pop(context);
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final employeesForSelectedMonth = getEmployeesForSelectedMonth();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showMonthPicker(
            context: context,
            initialDate: DateTime.now(),
          ).then((date) {
            if (date != null) {
              setState(() {
                selectedMonth = date.month.toString();
                selectedYear = date.year;
              });
            }
          });
        },
        child: Icon(Icons.calendar_today),
      ),
      appBar: AppBar(
        title: Text('Employee Management'),
        actions: [
          ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Add Employee'),
                      content: Container(
                        width: 200,
                        height: 200,
                        child: AddEmployeeForm(onSubmit: _addEmployee),
                      ),
                    );
                  },
                );
              },
              child: Text('Add Employee')),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            child: Text("Date selected :  $selectedMonth/$selectedYear"),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: employeesForSelectedMonth.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onDoubleTap: () {
                      boxEmployees.deleteAt(index);
                      print('deleted');
                      setState(() {});
                    },
                    child: EmployeeCard(
                        employee: employeesForSelectedMonth[index],
                        index: index));
              },
            ),
          ),
        ],
      ),
    );
  }
}

// class MonthSelector extends StatefulWidget {
//   final String selectedMonth;
//   final ValueChanged<String> onChanged;

//   MonthSelector({required this.selectedMonth, required this.onChanged});

//   @override
//   _MonthSelectorState createState() => _MonthSelectorState();
// }

// class _MonthSelectorState extends State<MonthSelector> {
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButton<String>(
//       value: widget.selectedMonth,
//       onChanged: widget.onChanged,
//       items: <String>['August 2023', 'September 2023', 'October 2023'] // Add your months
//           .map<DropdownMenuItem<String>>((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//     );
//   }
// }

class AddEmployeeForm extends StatefulWidget {
  final Function onSubmit;

  AddEmployeeForm({required this.onSubmit});

  @override
  _AddEmployeeFormState createState() => _AddEmployeeFormState();
}

class _AddEmployeeFormState extends State<AddEmployeeForm> {
  final _formKey = GlobalKey<FormState>();
  String employeeName = '';
  double totalSalary = 0.0;
  // double paidSalary = 0.0;
  // double remainingSalary = 0.0;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Employee Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
            onSaved: (value) {
              employeeName = value!;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Total Salary'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a total salary';
              }
              return null;
            },
            onSaved: (value) {
              totalSalary = double.parse(value!);
            },
          ),
          // TextFormField(
          //   decoration: InputDecoration(labelText: 'Paid Salary'),
          //   keyboardType: TextInputType.number,
          //   validator: (value) {
          //     if (value == null || value.isEmpty) {
          //       return 'Please enter a paid salary';
          //     }
          //     return null;
          //   },
          //   onSaved: (value) {
          //     paidSalary = double.parse(value!);
          //   },
          // ),
          // TextFormField(
          //   decoration: InputDecoration(labelText: 'Remaining Salary'),
          //   keyboardType: TextInputType.number,
          //   validator: (value) {
          //     if (value == null || value.isEmpty) {
          //       return 'Please enter a remaining salary';
          //     }
          //     return null;
          //   },
          //   onSaved: (value) {
          //     remainingSalary = double.parse(value!);
          //   },
          // ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                print('totalSalary : $totalSalary');
                final newEmployee = Employee(
                  name: employeeName,
                  totalSalary: totalSalary,
                  // paidSalary: paidSalary,
                  // remainingSalary: remainingSalary,
                  // month: selectedMonth, // Assuming you have selectedMonth defined somewhere
                );
                widget.onSubmit(newEmployee);
              }
            },
            child: Text('Add Employee'),
          ),
        ],
      ),
    );
  }
}

class EmployeeCard extends StatefulWidget {
  final Employee employee;
  final int index;

  EmployeeCard({required this.employee, required this.index});

  @override
  _EmployeeCardState createState() => _EmployeeCardState();
}

class _EmployeeCardState extends State<EmployeeCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        title: Text(widget.employee.name,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(

                    // width: 200,
                    child: Text(
                  'Total Salary: ${widget.employee.totalSalary}',
                  style: TextStyle(fontSize: 16),
                )),
                // SizedBox(
                //   height: 20,
                // ),
                Expanded(
                    // width: 200,
                    child: Text('Paid Salary : ${widget.employee.paidSalary}',
                        style: TextStyle(fontSize: 16))),

                SizedBox(
                  width: 50,
                ),
                Expanded(
                  // width: 200,
                  child: Text(
                      "Reaming Salary : ${(widget.employee.totalSalary - widget.employee.paidSalary!)}",
                      style: TextStyle(fontSize: 16)),
                ),

                Expanded(
                  // width: 200,
                  child: TextField(
                    decoration:
                        InputDecoration(labelText: 'Update Paid Salary'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        widget.employee.paidSalary = double.parse(value);
                        // Employee? emp = boxEmployees.getAt(index);

                        widget.employee.updatePaidSalary(double.parse(value));

                        boxEmployees.putAt(widget.index, widget.employee);
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
