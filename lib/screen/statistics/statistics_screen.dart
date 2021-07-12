import 'package:app_delivery/components/choose_item.dart';
import 'package:app_delivery/screen/statistics/statistics_order/statistics_order_screen.dart';
import 'package:app_delivery/screen/statistics/statistics_revenue/statistics_revenue_screen.dart';
import 'package:app_delivery/screen/statistics/statistics_warehouse/statistics_warehouse_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'chartss.dart';

class StatisticsScreen extends StatelessWidget {
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
      title: Text("Báo cáo"),
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFEEEEEE),
      height: 834.h,
      width: double.infinity,
      child: Column(
        children: [
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

        ],
      ),
    );
  }
}
