import 'package:app_delivery/components/choose_item.dart';
import 'package:app_delivery/screen/restaurant/restaurant_screen.dart';
import 'package:app_delivery/screen/statistics/chartss.dart';
import 'package:app_delivery/screen/statistics/statistics_order/statistics_order_screen.dart';
import 'package:app_delivery/screen/statistics/statistics_revenue/statistics_revenue_screen.dart';
import 'package:app_delivery/screen/statistics/statistics_screen.dart';
import 'package:app_delivery/screen/statistics/statistics_warehouse/statistics_warehouse_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(270.h),
        child: AppBar(
          title: Container(
            height: 70.h,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        "Xin chao Com so 1",
                        style: TextStyle(fontSize: 22.sp, color: Colors.white),
                      ),
                    ),
                    Container(
                      width: 140.w,
                      child: Text(
                        "Kiot Nong Lam, duong 8, Linh Trung, Thu Duc",
                        softWrap: true,
                        style: TextStyle(fontSize: 14.sp, color: Colors.white),
                      ),
                    )
                  ],
                ),
                Container(
                  width: 40.w,
                  child: IconButton(
                      onPressed: () {
                        Get.to(RestaurantScreen());
                      },
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: 16.sp,
                      )),
                )
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              color: Colors.white,
              tooltip: 'Notifications',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('This is a snackbar')));
              },
            )
          ],
          elevation: 0,
          backgroundColor: Colors.white,
          flexibleSpace: Stack(
            children: [
              Container(
                child: ClipPath(
                  clipper: CustomShape(),
                  // this is my own class which extendsCustomClipper
                  child: Container(
                    color: Color(0xff0D93E8),
                  ),
                ),
              ),
              Positioned(
                child: UserCard(),
                top: ((270 - 70) / 2).h,
                left: 5.w,
              )
            ],
          ),
        ),
      ),
      body: Container(
        color: Color(0xFFEEEEEE),
        height: 634.h,
        width: double.infinity,
        child: ListView(
          children: [
            BarChartPage2(),
            ChooseItem(
              icon: Icons.monetization_on,
              name: 'Báo cáo doanh thu',
              content: 'Hiện thị doanh thu của cửa hàng trong kỳ',
              page: StatisticsRevenueScreen(),
            ),
            ChooseItem(
              icon: Icons.food_bank,
              name: 'Báo cáo đơn hàng',
              content: 'Thống kê các dữ liệu tổng hợp về đơn hàng',
              page: StatisticsOrderScreen(),
            ),
            ChooseItem(
              icon: Icons.house_siding,
              name: 'Báo cáo kho',
              content: 'Tổng giá trị và số lượng sản phẩm tồn kho',
              page: StatisticsWarehouseScreen(),
            ),
            SizedBox(height: 10.h)
          ],
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400.w,
      height: 175.h,
      child: Card(
        margin: EdgeInsets.only(left: 10.w, right: 10.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 0.5, color: Colors.black12)),
                ),
                padding: EdgeInsets.only(bottom: 15.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Text(
                          "DOANH THU HÔM NAY",
                          style: TextStyle(fontSize: 18.sp, color: Colors.grey),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10.h),
                          child: Text(
                            "1.000.000",
                            style: TextStyle(
                                fontSize: 20.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => StatisticsScreen());
                      },
                      child: Row(
                        children: [
                          Text(
                            "Xem chi tiết",
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                          Icon(Icons.arrow_forward_ios,
                              size: 15.sp, color: Colors.blueAccent)
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Đơn hàng mới",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 5.h),
                            child: Text(
                              "0",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                    Column(
                      children: [
                        Text("Đơn hủy", style: TextStyle(color: Colors.grey)),
                        Container(
                            margin: EdgeInsets.only(top: 5.h),
                            child: Text(
                              "0",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                    Column(
                      children: [
                        Text("Tổng số đơn",
                            style: TextStyle(color: Colors.grey)),
                        Container(
                            margin: EdgeInsets.only(top: 5.h),
                            child: Text(
                              "0",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomShape extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    double height = size.height;
    double width = size.width;
    var path = Path();
    path.lineTo(0, height - 100);
    path.quadraticBezierTo(width / 2, height, width, height - 100);
    path.lineTo(width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

