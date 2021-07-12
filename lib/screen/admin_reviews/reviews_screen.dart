import 'package:app_delivery/models/Images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      title: Text("Danh sách đánh giá"),

    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFEEEEEE),
      height: 834.h,
      // child: Expanded(
      child: ListView(
        children: [
          ReviewItem(),
          ReviewItem(),
          ReviewItem(),
        ],
        // ),
      ),
    );
  }
}

class ReviewItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(10),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ReviewItemTop(),
            Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(width: 0.5, color: Colors.grey[300])))),
            ReviewBody()
          ],
        ),
      ),
    );
  }
}

class ReviewItemTop extends StatelessWidget {
  double _rating = 3;

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
                  // margin: EdgeInsets.all(5),
                  //image
                  child: Container(
                    width: 50.w,
                    height: 50.h,
                    padding: EdgeInsets.only(
                        right: 12.w, bottom: 12.h, left: 12.w, top: 12.h),
                    child: Image.asset(
                      'assets/images/person.png',
                      fit: BoxFit.fill,
                      color: Colors.black26,
                    ),
                  )),
              //user name
              Container(
                padding: EdgeInsets.only(left: 5.w),
                child: Text('duyen duyen'),
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
                        initialRating: 3,
                        minRating: 3,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 14,
                        itemPadding: EdgeInsets.symmetric(horizontal: 0.1),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(_rating);
                          print(rating);
                          _rating = rating;
                          print(_rating);
                        },
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Container(
                        child: Text(
                          '3.0',
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
                  child: Text(
                    '02/06/2021',
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
              'Lafm own nhuw lol dfghjklhjklhjkl qwefghjklwasgfhjkwertyuiwertyu dfghjkldfghjk dfghjkldfghjk dfghjkdfghjkl dfghjklrtyuio dfghjkdfghjkfghjcghjnccvbnmccvbn',
              softWrap: true,
            ),
          ),
          Container(
            height: 140.h,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: false,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            right: 5.0.w, top: 10.h, bottom: 5.h),
                        child: Container(
                          width: 70,
                          height: 70,
                          color: Colors.grey,
                          child: Image.asset(
                            list[index].imageReview,
                            fit: BoxFit.fill,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  height: 45.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          alignment: Alignment.center,
                          width: 190.w,
                          child: Text('Xem đơn hàng'),
                        ),
                      ),
                      Center(
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(
                                        width: 1, color: Colors.greenAccent)))),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          alignment: Alignment.center,
                          width: 190.w,
                          child: Text('Trả lời'),
                        ),
                      )
                    ],
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
