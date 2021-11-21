import 'package:address_picker_vn/address_picker.dart';
import 'package:app_delivery/components/item_field.dart';
import 'package:app_delivery/utils.dart';
import 'package:app_delivery/widgets/form_add_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressRestaurant extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddressRestaurant();
  }
}

class _AddressRestaurant extends State<AddressRestaurant> {
  LatLng latLng;
  String a = '';
  TextEditingController addressDetail;
  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    checkPermision();
    addressDetail = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    addressDetail.dispose();
    super.dispose();
  }

  Future<void> checkPermision() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text("Địa chỉ quán"),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xFFEEEEEE),
          child: Form(
            key: formKey,
            child: Builder(
              builder: (BuildContext ctx) => Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await checkPermision();
                      String address = await getCurrentAddress();
                      print(address);
                      Get.back(result: address);
                    },
                    child: Container(
                      width: 414.w,
                      height: 60.h,
                      margin: EdgeInsets.only(
                          left: 12.w, right: 12.w, top: 12.h, bottom: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black26, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.red,
                          ),
                          Text('Sử dụng vị trí hiện tại')
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Color(0xFFEEEEEE),
                    child: FormAddWidget(
                      widget: Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(left: 10.w, right: 10.w),
                        margin: EdgeInsets.only(top: 5.h),
                        child: AddressPicker(
                          onAddressChanged: (address) {
                            if (address.province.isNotEmpty &&
                                address.ward.isNotEmpty &&
                                address.district.isNotEmpty) {
                              a = address.ward +
                                  ', ' +
                                  address.district +
                                  ', ' +
                                  address.province;
                            }
                            print(address);
                          },
                          buildItem: (text) {
                            return Text(text,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16.sp));
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ItemField(
                    controller: addressDetail,
                    hintText: "Địa chỉ cụ thể",
                    validator: (val) {
                      if (val.length == 0) {
                        return 'Vui lòng nhập địa chỉ cụ thể';
                      } else
                        return null;
                    },
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (Form.of(ctx).validate()) {
                        if (a == '') {
                          showToast('Vui lòng chọn đầy đủ thông tin');
                        } else {
                          String address = addressDetail.text + ', ' + a;
                          print(address);
                          Location location = await transferLocation(address);

                          address = address +
                              '|' +
                              location.latitude.toString() +
                              '|' +
                              location.longitude.toString();

                          print(address);
                          Get.back(result: address);
                        }
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 30.h, bottom: 10.h, left: 12.w, right: 12.w),
                      height: 45.h,
                      width: MediaQuery.of(context).size.width / 1.1,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Center(
                        child: Text(
                          'Hoàn thành'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Location> transferLocation(String address) async {
    List<Location> locations = await locationFromAddress(address);
    return locations.first;
  }

  Future<String> getCurrentAddress() async {
    String address = '';

    List<Placemark> placemark = await getPosition();

    String street = await getStreet(placemark);
    String locality = await getLocality(placemark);
    String a = await getAddress(placemark);

    address = street + ', ' + locality + ', ' + a;
    address = address +
        '|' +
        latLng.latitude.toString() +
        '|' +
        latLng.longitude.toString();

    return address;
  }

  Future<String> getStreet(List<Placemark> placemarks) async {
    for (int i = 0; i < placemarks.length; i++) {
      if (placemarks[i].street.isNotEmpty) {
        return placemarks[i].street;
      }
    }
    return '';
  }

  Future<String> getLocality(List<Placemark> placemarks) async {
    for (int i = 0; i < placemarks.length; i++) {
      if (placemarks[i].locality.isNotEmpty) {
        return placemarks[i].locality;
      }
    }
    return '';
  }

  Future<String> getAddress(List<Placemark> placemarks) async {
    String address = '';

    for (int i = 0; i < placemarks.length; i++) {
      print(placemarks[i]);
      if (placemarks[i].administrativeArea.isNotEmpty &&
          placemarks[i].subAdministrativeArea.isNotEmpty &&
          placemarks[i].country.isNotEmpty) {
        print('vào dât đi bạn');
        address = placemarks[i].subAdministrativeArea +
            ', ' +
            placemarks[i].administrativeArea +
            ', ' +
            placemarks[i].country;
      }
    }
    return address;
  }

  Future<List<Placemark>> getPosition() async {
    Position position = await Geolocator.getCurrentPosition();

    latLng = new LatLng(position.latitude, position.longitude);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    return placemarks;
  }
}
