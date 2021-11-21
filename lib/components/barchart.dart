import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/apis.dart';
import 'package:app_delivery/screen/widget/loading.dart';
import 'package:app_delivery/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BarChartSample2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BarChartSample2State();
}

class BarChartSample2State extends State<BarChartSample2> {
  final Color leftBarColor = const Color(0xff53fdd7);
  final Color rightBarColor = const Color(0xffff5182);
  final double width = 7;

  List<BarChartGroupData> rawBarGroups;
  List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: iniChart(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          } else {
            if (snapshot.hasData) {
              return AspectRatio(
                aspectRatio: 1,
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  color: const Color(0xff2c4260),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            makeTransactionsIcon(),
                            const SizedBox(
                              width: 38,
                            ),
                            const Text(
                              'Doanh thu trong tuần',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 22),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 38,
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: BarChart(
                              BarChartData(
                                maxY: 100,
                                barTouchData: BarTouchData(
                                  touchTooltipData: BarTouchTooltipData(
                                    tooltipBgColor: Colors.grey,
                                    getTooltipItem: (_a, _b, _c, _d) => null,
                                  ),
                                ),
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: SideTitles(
                                    showTitles: true,
                                    getTextStyles: (value) => const TextStyle(
                                        color: Color(0xff7589a2),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                    margin: 20,
                                    getTitles: (double value) {
                                      switch (value.toInt()) {
                                        case 0:
                                          return 'T2';
                                        case 1:
                                          return 'T3';
                                        case 2:
                                          return 'T4';
                                        case 3:
                                          return 'T5';
                                        case 4:
                                          return 'T6';
                                        case 5:
                                          return 'T7';
                                        case 6:
                                          return 'CN';
                                        default:
                                          return '';
                                      }
                                    },
                                  ),
                                  leftTitles: SideTitles(
                                    showTitles: true,
                                    getTextStyles: (value) => const TextStyle(
                                        color: Color(0xff7589a2),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                    margin: 32,
                                    reservedSize: 14,
                                    getTitles: (value) {
                                      if (value == 0) {
                                        return '0';
                                      } else if (value == 20) {
                                        return '200K';
                                      } else if (value == 40) {
                                        return '400K';
                                      } else if (value == 60) {
                                        return '600K';
                                      } else if (value == 80) {
                                        return '800k';
                                      } else if (value == 100) {
                                        return '1tr';
                                      } else {
                                        return '';
                                      }
                                    },
                                  ),
                                ),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                barGroups: showingBarGroups,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          }
        });
  }

  BarChartGroupData makeGroupData(int x, double y1) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        y: y1,
        colors: [leftBarColor],
        width: width,
      ),
    ]);
  }

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }

  Future<bool> iniChart() async {
    List<RevenueWeek> rw = await revenueWeek();
    double t2 = 0.0;
    double t3 = 0.0;
    double t4 = 0.0;
    double t5 = 0.0;
    double t6 = 0.0;
    double t7 = 0.0;
    double cn = 0.0;

    for (int i = 0; i < rw.length; i++) {
      if (rw[i].dayOfWeek == 2) {
        t2 += rw[i].price;
      }
      if (rw[i].dayOfWeek == 3) {
        t3 += rw[i].price;
      }
      if (rw[i].dayOfWeek == 4) {
        t4 += rw[i].price;
      }
      if (rw[i].dayOfWeek == 5) {
        t5 += rw[i].price;
      }
      if (rw[i].dayOfWeek == 6) {
        t6 += rw[i].price;
      }
      if (rw[i].dayOfWeek == 7) {
        t7 += rw[i].price;
      }
      if (rw[i].dayOfWeek == 1) {
        cn += rw[i].price;
      }
    }
    print('t2 đẩuo rồi ${t2}');
    t2 = t2 / 10000;
    t3 = t3 / 10000;
    t4 = t4 / 10000;
    t5 = t5 / 10000;
    t6 = t6 / 10000;
    t7 = t7 / 10000;
    cn = cn / 10000;

    final barGroup1 = makeGroupData(0, t2);
    final barGroup2 = makeGroupData(1, t3);
    final barGroup3 = makeGroupData(2, t4);
    final barGroup4 = makeGroupData(3, t5);
    final barGroup5 = makeGroupData(4, t6);
    final barGroup6 = makeGroupData(5, t7);
    final barGroup7 = makeGroupData(6, cn);

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
    return rw.isNotEmpty;
  }

  Future<List<RevenueWeek>> revenueWeek() async {
    String token = (await getToken());
    try {
      print(Apis.revenueWeekUrl);
      http.Response response = await http.get(
        Uri.parse(Apis.revenueWeekUrl),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        print(parsedJson['revenueWeek']);
        List<RevenueWeek> listRevenueWeek =
            ListRevenueWeek.fromJson(parsedJson).revenueWeek;
        return listRevenueWeek;
      }
      if (response.statusCode == 401) {}
    } on TimeoutException catch (e) {
      showError(e.toString());
    } on SocketException catch (e) {
      showError(e.toString());
    }
    return null;
  }
}

class ListRevenueWeek {
  List<RevenueWeek> revenueWeek;

  ListRevenueWeek({this.revenueWeek});

  ListRevenueWeek.fromJson(Map<String, dynamic> json) {
    if (json['revenueWeek'] != null) {
      revenueWeek = new List<RevenueWeek>();
      json['revenueWeek'].forEach((v) {
        revenueWeek.add(new RevenueWeek.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.revenueWeek != null) {
      data['revenueWeek'] = this.revenueWeek.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RevenueWeek {
  int price;
  String updatedAt;
  int dayOfWeek;

  RevenueWeek({this.price, this.updatedAt, this.dayOfWeek});

  RevenueWeek.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    updatedAt = json['updated_at'];
    dayOfWeek = json['day_of_week'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['updated_at'] = this.updatedAt;
    data['day_of_week'] = this.dayOfWeek;
    return data;
  }
}
