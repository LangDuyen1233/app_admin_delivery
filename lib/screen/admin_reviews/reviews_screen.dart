import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:app_delivery/models/Review.dart';
import 'package:app_delivery/screen/widget/empty_screen.dart';
import 'package:app_delivery/screen/widget/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../apis.dart';
import '../../utils.dart';

class ReviewScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ReviewScreen();
  }
}

RxList<Review> review;
List image;

class _ReviewScreen extends State<ReviewScreen> {
  @override
  void initState() {
    review = new RxList<Review>();
    fetchReview();
    // image = review.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text("Danh sách đánh giá"),
        ),
        body: Container(
          color: Color(0xFFEEEEEE),
          height: 834.h,
          child: FutureBuilder(
              future: fetchReview(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loading();
                } else {
                  if (snapshot.hasError) {
                    return EmptyScreen(text: 'Bạn chưa có đánh giá nào.');
                  } else {
                    // return buildLoading();
                    return RefreshIndicator(
                      onRefresh: () => fetchReview(),
                      child: Obx(
                        () => review.length == 0
                            ? EmptyScreen(
                                text: "Bạn chưa có đánh giá nào.",
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: review.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    // padding: EdgeInsets.all(10),
                                    child: Card(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ReviewItemTop(item: review[index]),
                                          Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          width: 0.5,
                                                          color: Colors
                                                              .grey[300])))),
                                          ReviewBody(item: review[index])
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                // ),
                              ),
                      ),
                    );
                  }
                }
              }),
        ));
  }

  Future<void> fetchReview() async {
    var list = await getReview();
    if (list != null) {
      // printInfo(info: listFood.length.toString());
      // print(listFood.length);
      review.assignAll(list);
      review.refresh();
      // print(food.length);
    }
  }

  Future<List<Review>> getReview() async {
    List<Review> list;
    String token = (await getToken());
    try {
      print(Apis.getReviewUrl);
      http.Response response = await http.get(
        Uri.parse(Apis.getReviewUrl),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        // print(parsedJson['food']);
        list = ListReviewJson.fromJson(parsedJson).review;
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
}

class ReviewItemTop extends StatelessWidget {
  final Review item;
  double _rating = 3;

  ReviewItemTop({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 2.h,
        left: 10.h,
      ),
      height: 70.h,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              //img user
              Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black12),
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  //image
                  child: Container(
                      width: 50.w,
                      height: 50.h,
                      child: item.user.avatar == null
                          ? Container(
                              padding: EdgeInsets.only(
                                  right: 10.w,
                                  bottom: 10.h,
                                  left: 10.w,
                                  top: 10.h),
                              child: ClipRRect(
                                child: Image.asset(
                                  'assets/images/person.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              child: Image.network(
                                Apis.baseURL + item.user.avatar,
                                width: 100.w,
                                height: 100.h,
                                fit: BoxFit.cover,
                              )))),
              //user name
              Container(
                padding: EdgeInsets.only(left: 5.w),
                child: Text(item.user.username),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(right: 10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //RAting
                Container(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: [
                      RatingBar.builder(
                        initialRating: double.parse(item.rate),
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 14,
                        itemPadding: EdgeInsets.symmetric(horizontal: 0.1),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        ignoreGestures: true,
                        onRatingUpdate: (double value) {  },
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Container(
                        child: Text(
                          item.rate.toString(),
                          style: TextStyle(fontSize: 14),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                // date time
                Container(
                  width: 110.w,
                  alignment: Alignment.centerRight,
                  child: Text(DateFormat('yyyy-MM-dd').format(
                      DateTime.parse(
                          item.updatedAt)),
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewBody extends StatelessWidget {
  final Review item;

// List<Image> image;
  const ReviewBody({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.w, top: 10.h),
      width: double.infinity,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              item.review.toString(),
              softWrap: true,
            ),
          ),
          Container(
            // height: 140.h,
            child: Column(
              children: [
                item.image.length != 0
                    ? Container(
                        height: 100.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: false,
                          itemCount: item.image.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  right: 5.0.w, top: 10.h, bottom: 5.h),
                              child: Container(
                                width: 70,
                                height: 70,
                                color: Colors.grey,
                                child: Image.network(
                                  Apis.baseURL + item.image[index].url,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 0.5, color: Colors.grey[300]),),),),
                // Container(
                //   height: 45.h,
                //   child: InkWell(
                //     onTap: () {},
                //     child: Container(
                //       alignment: Alignment.center,
                //       width: 190.w,
                //       child: Text('Trả lời'),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ],
      ),
    );
  }
}