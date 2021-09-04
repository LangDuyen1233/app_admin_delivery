import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/apis.dart';
import 'package:app_delivery/models/Restaurant.dart';
import 'package:app_delivery/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class AddressMap extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddressMap();
  }
}

class _AddressMap extends State<AddressMap> {
  LatLng center;

  // = new LatLng(10.873286, 106.7914436);
  GoogleMapController controller;

  LatLng newLocation;

  List<Marker> allMarkers = [];

  Restaurants restaurants;

  @override
  void initState() {
    restaurants = Get.arguments['restaurant'];
    addMarket();

    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sửa vị trí'),
        centerTitle: true,
        elevation: 0,
        leading: BackButton(),
      ),
      body: Container(
        height: 834.h,
        width: 414.w,
        child: Column(
          children: [
            Container(
              height: 730.h,
              child: GoogleMap(
                mapType: MapType.normal,
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: center,
                  zoom: 17.5,
                ),
                onMapCreated: _onMapCreated,
                markers: Set.from(allMarkers),
                // onTap: handleTap,
              ),
            ),
            InkWell(
              onTap: () async {
                await updateLocationAddress();
              },
              child: Container(
                margin: EdgeInsets.only(
                    top: 10.h, bottom: 10.h, left: 10.w, right: 10.w),
                height: 45.h,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Center(
                  child: Text(
                    'Đồng ý'.toUpperCase(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addMarket() async {
    if (restaurants.lattitude != null && restaurants.longtitude != null) {
      setState(() {
        center = new LatLng(double.parse(restaurants.lattitude),
            double.parse(restaurants.longtitude));
        allMarkers.add(
          Marker(
              markerId: MarkerId('myMarker'),
              draggable: true,
              onTap: () {
                print('Marker Tapped');
              },
              position: center,
              onDragEnd: ((newPosition) {
                print(newPosition.latitude);
                print(newPosition.longitude);
                setState(() {
                  newLocation =
                      new LatLng(newPosition.latitude, newPosition.longitude);
                });
              })),
        );
      });
    } else {
      Location location = await transferLocation(restaurants.address);
      print(location);
      setState(() {
        center = new LatLng(double.parse(restaurants.lattitude),
            double.parse(restaurants.longtitude));
        allMarkers.add(
          Marker(
              markerId: MarkerId('myMarker'),
              draggable: true,
              onTap: () {
                print('Marker Tapped');
              },
              position: center,
              onDragEnd: ((newPosition) {
                print(newPosition.latitude);
                print(newPosition.longitude);
                setState(() {
                  newLocation =
                      new LatLng(newPosition.latitude, newPosition.longitude);
                });
              })),
        );
      });
    }
  }

  Future<Location> transferLocation(String address) async {
    List<Location> locations = await locationFromAddress(address);
    return locations.first;
  }

  Future<List<Placemark>> transferAddress(LatLng latLng) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    return placemarks;
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

  Future<void> updateLocationAddress() async {
    print(newLocation);
    String token = (await getToken());
    String address = '';

    List<Placemark> placemark = await transferAddress(newLocation);

    String street = await getStreet(placemark);
    String locality = await getLocality(placemark);
    String a = await getAddress(placemark);

    address = street + ', ' + locality + ', ' + a;

    try {
      http.Response response = await http.post(
        Uri.parse(Apis.updateLocationUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer $token",
        },
        body: jsonEncode(<String, dynamic>{
          'id': restaurants.id,
          'address': address,
          'longtitude': newLocation.longitude,
          'lattitude': newLocation.latitude,
        }),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        Restaurants restaurant =
            RestaurantJson.fromJson(parsedJson).restaurants;
        Get.back(result: restaurant);
      }
      if (response.statusCode == 401) {
        showToast('Cập nhật vị trí thất bại!');
      }
      if (response.statusCode == 500) {
        showToast("Hệ thống bị lỗi, Vui lòng thử lại sau!");
      }
    } on TimeoutException catch (e) {
      showError(e.toString());
    } on SocketException catch (e) {
      showError(e.toString());
      print(e.toString());
    }
  }
}
