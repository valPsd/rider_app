// ignore: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:test_lazyloading/pages/test_dropdown_widget/dropdown_widget_q.dart';

class TestDropDown extends StatefulWidget {
  const TestDropDown({super.key});

  @override
  _TestDropDownState createState() => _TestDropDownState();
}

class _TestDropDownState extends State<TestDropDown> {
  String? _selectedValue;
  late String positions;
  //String value = 'null';
  List<Map> _items = [
    {'id': '1', 'name': 'BBL ', 'imageBank': 'assets/images/BBL.png'},
    {'id': '2', 'name': 'KBank', 'imageBank': 'assets/images/KBank.png'},
    {'id': '3', 'name': 'KTB', 'imageBank': 'assets/images/KTB.png'},
    {'id': '4', 'name': 'SCB', 'imageBank': 'assets/images/SCB.png'},
    {'id': '5', 'name': 'BAY', 'imageBank': 'assets/images/BAY.jpg'},
    {'id': '6', 'name': 'TTB', 'imageBank': 'assets/images/TTB.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            SizedBox(
              height: 5,
            ),

            // Write a new DropdownButton with adding styling.
            Container(
              // width: 250,
              padding: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  // border: Border.all(),
                  color: Color.fromARGB(255, 245, 247, 247)),
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                    hint: Text(
                      "Please choose Your Bank  ",
                      style: TextStyle(
                        color: Color.fromARGB(255, 85, 84, 84),
                        fontSize: 14,
                      ),
                    ),
                    icon: Icon(Icons.arrow_drop_down_circle,
                        color: Colors.grey.withOpacity(0.7)),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedValue = newValue as String?;
                      });
                    },
                    value: _selectedValue,
                    items: _items.map((bankItem) {
                      return DropdownMenuItem(
                          value: bankItem['id'],
                          child: Row(
                            children: [
                              Image.asset(
                                bankItem['imageBank'],
                                height: 20,
                                width: 20,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text(bankItem['name']),
                              )
                            ],
                          ));
                    }).toList(),
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 15,
            ),
          ],
        ),
      ],
    );
  }
}
