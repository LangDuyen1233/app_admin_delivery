import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/models/Food.dart';
import 'package:app_delivery/models/Topping.dart';
import 'package:app_delivery/screen/products/admin/edit_food.dart';
import 'package:app_delivery/screen/widget/empty_screen.dart';
import 'package:app_delivery/screen/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../apis.dart';
import '../../../utils.dart';
import 'choose_products.dart';
import 'edit_topping.dart';

class ListProduct extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListProduct();
  }
}

RxList<Food> food;
RxList<Topping> topping = new RxList<Topping>();
int food_id;

class _ListProduct extends State<ListProduct>
    with SingleTickerProviderStateMixin {
  int category_id;

  @override
  void initState() {
    category_id = Get.arguments['category_id'];
    print('lisst product$category_id');
    food = new RxList<Food>();
    fetchFood();
    fetchTopping();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text("Thực đơn"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              print("Thêm một món ăn mới");
              Get.to(() => ChooseProducts(),
                  arguments: {'category_id': category_id});
              // Get.off(() => ChooseProducts(),
              //     arguments: {'category_id': category_id});
              final result = await Get.arguments['food'];
              print(result);
              if (result != null) {
                food.add(result);
                food.refresh();
              }
            },
          ),
        ],
      ),
      body: Container(
        color: Color(0xFFEEEEEE),
        height: 834.h,
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                constraints: BoxConstraints.expand(height: 50),
                child: TabBar(
                  unselectedLabelColor: Colors.black87,
                  tabs: [
                    Tab(text: "Món"),
                    Tab(text: "Topping"),
                  ],
                  indicatorColor: Colors.blue,
                  labelColor: Colors.blue,
                ),
              ),
              Expanded(
                child: Container(
                  child: TabBarView(children: [
                    // list product food
                    FutureBuilder(
                        future: fetchFood(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Loading();
                          } else {
                            if (snapshot.hasError) {
                              return EmptyScreen(text: 'Bạn chưa có món ăn nào.');
                            } else {
                              // return buildLoading();
                              return RefreshIndicator(
                                onRefresh: () => fetchFood(),
                                child: Obx(
                                      () => food.length == 0
                                      ? EmptyScreen(
                                    text: "Bạn chưa có món ăn nào.",
                                  )
                                      : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: food.length,
                                        itemBuilder: (context, index) {
                                          return Slidable(
                                            actionPane: SlidableDrawerActionPane(),
                                            actionExtentRatio: 0.12,
                                            child: ProductItem(
                                              item: food[index],
                                            ),
                                            secondaryActions: <Widget>[
                                              Container(
                                                child: IconSlideAction(
                                                  caption: 'Edit',
                                                  color: Color(0xFFEEEEEE),
                                                  icon: Icons.edit,
                                                  foregroundColor: Colors.blue,
                                                  onTap: () async {
                                                    var result = await Get.to(() => EditFood(),
                                                        arguments: {
                                                          'category_id': category_id,
                                                          'food_id': food.value[index].id
                                                        });
                                                    // final result = await Get.arguments['food'];
                                                    // print(result);
                                                    setState(() {
                                                      if (result != null) {
                                                        fetchFood();
                                                        // food.add(result);
                                                        // food.refresh();
                                                      }
                                                    });
                                                  },
                                                ),
                                              ),
                                              Container(
                                                child: IconSlideAction(
                                                  caption: 'Delete',
                                                  color: Color(0xFFEEEEEE),
                                                  icon: Icons.delete,
                                                  foregroundColor: Colors.red,
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                              title: Text('Xóa món ăn'),
                                                              content: const Text(
                                                                  'Bạn có chắc chắn muốn xóa không?'),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed: () => Get.back(),
                                                                  child: const Text('Hủy'),
                                                                ),
                                                                TextButton(
                                                                  onPressed: () async {
                                                                    await deleteFood(
                                                                        food[index].id);

                                                                    setState(() {
                                                                      food.removeAt(index);
                                                                      food.refresh();
                                                                      Get.back();
                                                                      showToast(
                                                                          "Xóa thành công");
                                                                    });

                                                                    // Get.to(ListProduct());

                                                                    // food.refresh();
                                                                  },
                                                                  child: const Text(
                                                                    'Xóa',
                                                                    style: TextStyle(
                                                                        color: Colors.red),
                                                                  ),
                                                                ),
                                                              ]);
                                                        });
                                                  },
                                                ),
                                              )
                                            ],
                                          );
                                        },
                                      ),
                                ),
                              );
                            }
                          }
                        }),
                    // list topping and size food
                    FutureBuilder(
                        future: fetchTopping(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Loading();
                          } else {
                            if (snapshot.hasError) {
                              return EmptyScreen(text: 'Bạn chưa có món ăn nào.');
                            } else {
                              // return buildLoading();
                              return RefreshIndicator(
                                onRefresh: () => fetchTopping(),
                                child: Obx(
                                      () => topping.length == 0
                                      ? EmptyScreen(
                                    text: "Bạn chưa có món ăn nào.",
                                  )
                                      : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: topping.length,
                                        itemBuilder: (context, index) {
                                          return Slidable(
                                            actionPane: SlidableDrawerActionPane(),
                                            actionExtentRatio: 0.12,
                                            child: ToppingItem(
                                              item: topping[index],
                                            ),
                                            secondaryActions: <Widget>[
                                              Container(
                                                child: IconSlideAction(
                                                  caption: 'Edit',
                                                  color: Color(0xFFEEEEEE),
                                                  icon: Icons.edit,
                                                  foregroundColor: Colors.blue,
                                                  onTap: () async {
                                                    var result = await Get.to(
                                                            () => EditToppings(),
                                                        arguments: {
                                                          'category_id': category_id,
                                                          'topping_id':
                                                          topping.value[index].id
                                                        });
                                                    // final result =
                                                    //     await Get.arguments['topping'];
                                                    // print(result);
                                                    setState(() {
                                                      if (result != null) {
                                                        fetchTopping();
                                                        // topping.add(result);
                                                        // topping.refresh();
                                                      }
                                                    });
                                                  },
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 5),
                                                child: IconSlideAction(
                                                  caption: 'Delete',
                                                  color: Color(0xFFEEEEEE),
                                                  icon: Icons.delete,
                                                  foregroundColor: Colors.red,
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                              title: Text('Xóa topping'),
                                                              content: const Text(
                                                                  'Bạn có chắc chắn muốn xóa không?'),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed: () => Get.back(),
                                                                  child: const Text('Hủy'),
                                                                ),
                                                                TextButton(
                                                                  onPressed: () async {
                                                                    await deleteTopping(
                                                                        topping[index].id);

                                                                    setState(() {
                                                                      topping.removeAt(index);
                                                                      topping.refresh();
                                                                      Get.back();
                                                                    });

                                                                    // Get.to(ListProduct());

                                                                    // food.refresh();
                                                                  },
                                                                  child: const Text(
                                                                    'Xóa',
                                                                    style: TextStyle(
                                                                        color: Colors.red),
                                                                  ),
                                                                ),
                                                              ]);
                                                        });
                                                  },
                                                ),
                                              )
                                            ],
                                          );
                                        },
                                      ),
                                ),
                              );
                            }
                          }
                        }),
                  ]),
                ),
              ),
              SizedBox(
                height: 10.h,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchFood() async {
    var listFood = await getFood();
    if (listFood != null) {
      // printInfo(info: listFood.length.toString());
      // print(listFood.length);
      food.assignAll(listFood);
      food.refresh();
      
      // print(food.length);
    }
  }

  Future<List<Food>> getFood() async {
    List<Food> list;
    String token = (await getToken());
    int categoryId = Get.arguments['category_id'];
    print(categoryId.toString() + " dduj mas m");
    Map<String, String> queryParams = {
      'category_id': categoryId.toString(),
    };
    String queryString = Uri(queryParameters: queryParams).query;
    try {
      print(Apis.getFoodUrl);
      http.Response response = await http.get(
        Uri.parse(Apis.getFoodUrl + '?' + queryString),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        print(parsedJson['food']);
        list = ListFoodJson.fromJson(parsedJson).food;
        print(list);
        return list;
      }
      if (response.statusCode == 401) {
        showToast("Loading faild");
      }
    } on TimeoutException catch (e) {
      showError(e.toString());
    } on SocketException catch (e) {
      showError(e.toString());
      print(e.toString());
    }
    return null;
  }

  Future<void> fetchTopping() async {
    var listTopping = await getTopping();
    if (listTopping != null) {
      printInfo(info: listTopping.length.toString());
      topping.assignAll(listTopping);
      topping.refresh();
    }
  }

  Future<List<Topping>> getTopping() async {
    List<Topping> list;
    String token = (await getToken());
    try {
      print(Apis.getToppingUrl);
      http.Response response = await http.get(
        Uri.parse(Apis.getToppingUrl),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        print(parsedJson['topping']);
        list = ListTopping.fromJson(parsedJson).topping;
        print(list);
        return list;
      }
      if (response.statusCode == 401) {
        showToast("Loading faild");
      }
    } on TimeoutException catch (e) {
      showError(e.toString());
    } on SocketException catch (e) {
      showError(e.toString());
      print(e.toString());
    }
    return null;
  }

  Future<Food> deleteFood(int food_id) async {
    String token = await getToken();
    print(token);
    print('category $category_id');
    print('food id $food_id');

    try {
      EasyLoading.show(status: 'Loading...');
      http.Response response = await http.post(
        Uri.parse(Apis.deleteFoodUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer $token",
        },
        body: jsonEncode(<String, dynamic>{
          'food_id': food_id,
        }),
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        var parsedJson = jsonDecode(response.body);
        // print(parsedJson['success']);
        Food f = Food.fromJson(parsedJson['food']);
        return f;
        // food.remove(f);
        // food.refresh();
        // Get.off(ListProduct(),
        //     arguments: {'food': food, 'category_id': category_id});
        // showToast("Sửa thành công");
      }
      if (response.statusCode == 404) {
        EasyLoading.dismiss();
        var parsedJson = jsonDecode(response.body);
        print(parsedJson['error']);
      }
    } on TimeoutException catch (e) {
      showError(e.toString());
    } on SocketException catch (e) {
      showError(e.toString());
    }
  }

  Future<Topping> deleteTopping(int topping_id) async {
    String token = await getToken();
    print(token);
    print('category $category_id');
    print('food id $food_id');

    try {
      EasyLoading.show(status: 'Loading...');
      http.Response response = await http.post(
        Uri.parse(Apis.deleteToppingUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer $token",
        },
        body: jsonEncode(<String, dynamic>{
          'topping_id': topping_id,
        }),
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        var parsedJson = jsonDecode(response.body);
        // print(parsedJson['success']);
        Topping tp = Topping.fromJson(parsedJson['topping']);
        return tp;
        // food.remove(f);
        // food.refresh();
        // Get.off(ListProduct(),
        //     arguments: {'food': food, 'category_id': category_id});
        // showToast("Sửa thành công");
      }
      if (response.statusCode == 404) {
        EasyLoading.dismiss();
        var parsedJson = jsonDecode(response.body);
        print(parsedJson['error']);
      }
    } on TimeoutException catch (e) {
      showError(e.toString());
    } on SocketException catch (e) {
      showError(e.toString());
    }
  }
}

class ProductItem extends StatelessWidget {
  final Food item;

  ProductItem({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
        margin: EdgeInsets.only(top: 10.h, left: 15, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.sp)),
          color: Colors.white,
        ),
        // height: 120.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Image.network(
                      Apis.baseURL + item.image[0].url,
                      width: 100.w,
                      height: 100.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15.w, right: 10.w),
                  // height: 92.h,
                  width: 275.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.size == null
                            ? item.name
                            : item.name + " Size " + item.size,
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.w600),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            item.discountId == null
                                ? Text(
                                    'Giá : ${NumberFormat.currency(locale: 'vi').format(item.price)}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  )
                                : Row(
                                    children: [
                                      Text(
                                          'Giá :  ${NumberFormat.currency(locale: 'vi').format((item.price - item.price * (double.parse(item.discount.percent) / 100)).round())}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500)),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(
                                        '${NumberFormat.currency(locale: 'vi').format(item.price)}',
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough),
                                      )
                                    ],
                                  ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Text(
                              'Thành phần: ' + item.ingredients.toString(),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Text(
                              'Topping: ' + tp(item.topping),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  String tp(List<Topping> l) {
    String result = "";
    for (int i = 0; i < l.length; i++) {
      if (i == l.length - 1) {
        result += l[i].name;
      } else
        result += l[i].name + ', ';
    }
    return result;
  }
}

class ToppingItem extends StatelessWidget {
  final Topping item;

  const ToppingItem({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
          margin: EdgeInsets.only(top: 10.h, left: 15, right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.sp)),
            color: Colors.white,
          ),
          height: 70.h,
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.only(left: 15.w, right: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  item.name,
                  style:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
                ),
                Text('Giá bán : ' + item.price.toString() + ' VNĐ'),
              ],
            ),
          )),
    );
  }
}
