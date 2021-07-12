import 'package:app_delivery/models/Food.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
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
      automaticallyImplyLeading: false,
      title: Text("Sản phẩm"),
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFEEEEEE),
      height: 834.h,
      child: Column(
        children: [
          // search
          Container(
            margin: EdgeInsets.all(10.sp),
              decoration: BoxDecoration(
                // color: Color(0xFFEEEEEE),
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(1.w),
                ),
              ),
              // color: Colors.white,
              height: 50.h,
              child: TextField(
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 14.sp),
                autocorrect: false,
                onChanged: (text) {},
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    size: 22.sp,
                  ),
                  suffixIcon: GestureDetector(
                    child: Icon(Icons.clear, size: 22.sp),
                  ),
                  border: InputBorder.none,
                  hintText: 'Enter a search term',
                ),
              ),
          ),
          // Container(
          //   height: 40.h,
          //   padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 2.h),
          //   color: Colors.white,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: <Widget>[
          //       Expanded(
          //         child: DropdownButtonHideUnderline(
          //           child: DropdownCategories(),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 5.w),
            margin: EdgeInsets.all(6.w),
            height: 25.h,
            child: Text(
              '6 sản phẩm',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 15.sp, color: Colors.black54),
            ),
          ),
          Expanded(child: ListView.builder(
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (context, index) =>
                ProductItem(
                  item: list[index],
                ),
          ),)
        ],
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final Food item;

  const ProductItem({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(top: 1.h),
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.white,
        ),
        width: double.infinity,
        height: 105.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 6.h, left: 15.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                    child: Image.network(
                      item.img,
                      width: 80.w,
                      height: 80.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15.w, right: 10.w),
                  height: 92.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.w600),
                      ),
                      Text('Số lượng: ' + item.quantity.toString()),
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
}

// class DropdownCategories extends StatefulWidget {
//   const DropdownCategories({Key key}) : super(key: key);
//
//   @override
//   State<DropdownCategories> createState() => _DropdownCategories();
// }
//
// /// This is the private State class that goes with MyStatefulWidget.
// class _DropdownCategories extends State<DropdownCategories> {
//   String dropdownValue = 'Tất cả sản phẩm';
//
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButton<String>(
//       value: dropdownValue,
//       icon: (null),
//       style: TextStyle(
//         color: Colors.black54,
//         fontSize: 15,
//       ),
//       elevation: 16,
//       onChanged: (String newValue) {
//         setState(() {
//           dropdownValue = newValue;
//         });
//       },
//       items: <String>['Tất cả sản phẩm', 'Đồ ăn', 'Thức uống']
//           .map<DropdownMenuItem<String>>((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//     );
//   }
// }
