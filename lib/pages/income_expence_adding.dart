import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_manager_pro/data/db_helper.dart';

import '../constants.dart';

class Additems extends StatefulWidget {
  const Additems({super.key});

  @override
  State<Additems> createState() => _AdditemsState();
}

class _AdditemsState extends State<Additems> {
  int? amount;
  String note = "Some Expence";
  String type = "Income";
  DateTime selectedDate = DateTime.now();

  List<String> moths = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  Future<void> _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2023, 1),
        lastDate: DateTime(2100, 12));

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Add Transactions ",
          style: GoogleFonts.aBeeZee(
            fontSize: 18,
            letterSpacing: 1.0,
            fontWeight: FontWeight.w500,
            color: kTextColor,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          const SizedBox(
            height: 24,
          ),
          Row(
            children: [
              const Icon(Icons.attach_money),
              const SizedBox(
                width: 11,
              ),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    filled: true,
                    hintText: "0",
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    try {
                      amount = int.parse(value);
                    } catch (e) {}
                  },
                  style: const TextStyle(fontSize: 24),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            children: [
              const Icon(Icons.description),
              const SizedBox(
                width: 11,
              ),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    filled: true,
                    hintText: "Note no Transactions",
                    fillColor: Colors.white,
                  ),
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                  onChanged: (value) {
                    note = value;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            children: [
              const Icon(Icons.description),
              const SizedBox(
                width: 11,
              ),
              ChoiceChip(
                label: Text(
                  "Income",
                  style: TextStyle(
                    fontSize: 18,
                    color: type == "Income" ? Colors.black : Colors.white,
                  ),
                ),
                selected: type == "income" ? true : false,
                selectedColor: Colors.white70,
                selectedShadowColor: Colors.black,
                onSelected: (value) {
                  if (value) {
                    setState(() {
                      type = "Income";
                    });
                  }
                },
              ),
              const SizedBox(
                width: 11,
              ),
              ChoiceChip(
                label: Text(
                  "Expence",
                  style: TextStyle(
                    fontSize: 18,
                    color: type == "Expence" ? Colors.black : Colors.white,
                  ),
                ),
                selected: type == "Expence" ? true : false,
                selectedColor: Colors.white70,
                onSelected: (value) {
                  if (value) {
                    setState(() {
                      type = "Expence";
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextButton(
            onPressed: () {
              _selectedDate(context);
            },
            style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero)),
            child: Row(
              children: [
                const Icon(Icons.date_range),
                const SizedBox(
                  width: 11,
                ),
                Text("${selectedDate.day}  ${moths[selectedDate.month - 1]}"),
              ],
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            onPressed: () async {
              if (amount != null && note.isNotEmpty) {
                Navigator.of(context).pop();
                DbHelper dbHelper = DbHelper();
                await dbHelper.addData(note, amount!, selectedDate, type);
                
              } else {
                print("All feild provide !");
              }
            },
            child: const Text(
              "Add",
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
