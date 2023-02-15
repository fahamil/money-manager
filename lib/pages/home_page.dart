import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_manager_pro/data/db_helper.dart';

import 'package:money_manager_pro/pages/income_expence_adding.dart';
import 'package:money_manager_pro/pages/settings_screen.dart';

import '../constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DbHelper dbHelper = DbHelper();
  int totalBalance = 0;
  int totalIncome = 0;
  int totalExpence = 0;

  getTotelBalance(Map entireData) {
    totalBalance = 0;
    totalIncome = 0;
    totalExpence = 0;
    entireData.forEach((key, value) {
      if (value['type'] == "Income") {
        totalBalance += (value['amount'] as int);
        totalIncome += (value['amount'] as int);
      } else {
        totalBalance -= (value['amount'] as int);
        totalExpence += (value['amount'] as int);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: FloatingActionButton(
          backgroundColor: kPrimaryColor,
          elevation: 0,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            );
          },
          child: const Icon(Icons.settings),
        ),
        actions: [
          FloatingActionButton(
            elevation: 0,
            backgroundColor: kPrimaryColor,
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                builder: (context) => const Additems(),
              ))
                  .whenComplete(() {
                setState(() {});
              });
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder<Map>(
          future: dbHelper.fetch(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Error"),
                );
              }
            }
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("No VAlue Found !"),
                );
              }
              getTotelBalance(snapshot.data!);
              //(snapshot.data!);
              return ListView(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    margin: const EdgeInsets.all(12.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        gradient: const LinearGradient(
                          colors: [kPrimaryColor, Colors.black],
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: Column(
                        children: [
                          const Text(
                            'Total Balance',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'RS $totalBalance',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                          const SizedBox(
                            height: 22,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                cardIncome(totalIncome.toString()),
                                cardExpence(totalExpence.toString()),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  //
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      "Expence",
                      style: TextStyle(
                          fontSize: 23,
                          color: Colors.white70,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                  
                  // chart Expence and income
                  Container(
                    color: Colors.white,
                    height: 300,
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                              spots: [
                                FlSpot(1, 4),
                                FlSpot(2, 4),
                                FlSpot(3, 4),
                                FlSpot(4, 5),
                              ],
                              isCurved: false,
                              barWidth: 2.5,
                              color: kPrimaryColor),
                        ],
                      ),
                    ),
                  ),
                  
                  
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      "Recent Expence",
                      style: TextStyle(
                          fontSize: 23,
                          color: Colors.white70,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                  //
                  //
                  //
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Map dataAtIndex = snapshot.data![index];
                        if (dataAtIndex['type'] == "Income") {
                          return incomeTile(
                              dataAtIndex['amount'], dataAtIndex['note']);
                        } else {
                          return expenceTile(
                              dataAtIndex['amount'], dataAtIndex['note']);
                        }
                      })
                ],
              );
            } else {
              return const Text("Has data");
            }
          }),
    );
  }

  Widget cardIncome(String value) {
    return Row(
      children: [
        Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: const EdgeInsets.all(6.0),
            margin: const EdgeInsets.only(right: 8.0),
            child: const Icon(
              Icons.arrow_downward,
              size: 25,
              color: Colors.green,
            )),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Income",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            )
          ],
        )
      ],
    );
  }

  Widget cardExpence(String value) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: const EdgeInsets.all(6.0),
          margin: const EdgeInsets.only(right: 8.0),
          child: const Icon(
            Icons.arrow_upward,
            size: 25,
            color: Colors.red,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Expence",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            )
          ],
        )
      ],
    );
  }

  Widget expenceTile(int value, String note) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: const Color(0xffced4eb),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.arrow_circle_up_outlined,
                color: Colors.red[700],
                size: 27,
              ),
              const SizedBox(
                width: 8,
              ),
              const Text(
                "Expence",
                style: TextStyle(
                  fontSize: 20,
                ),
              )
            ],
          ),
          const SizedBox(
            width: 16,
          ),
          Text(
            "-$value",
            style: const TextStyle(
              fontSize: 18,
            ),
          )
        ],
      ),
    );
  }

  Widget incomeTile(int value, String note) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: const Color(0xffced4eb),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.arrow_circle_down_outlined,
                color: Colors.green[700],
                size: 27,
              ),
              const SizedBox(
                width: 8,
              ),
              const Text(
                "Income",
                style: TextStyle(
                  fontSize: 20,
                ),
              )
            ],
          ),
          const SizedBox(
            width: 16,
          ),
          Text(
            "+$value",
            style: const TextStyle(
              fontSize: 18,
            ),
          )
        ],
      ),
    );
  }
}
