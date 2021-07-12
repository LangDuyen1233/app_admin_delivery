import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_delivery/screen/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Avatar extends StatefulWidget {
  // final String defaultImage;
  // final String name;
  //
  // const Avatar({Key key, this.defaultImage, this.name}) : super(key: key);

  @override
  _AvatarState createState() => new _AvatarState();
}

class _AvatarState extends State<Avatar> {
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        _image = File('widget.defaultImage');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: defaulColorThem,
      width: MediaQuery.of(context).size.width,
      height: 210.h,
      padding: EdgeInsets.only(top: 25.h),
      child: Center(
        child: Column(
          children: [
            Container(
              // height: 100.h,
              // width: 100.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: InkWell(
                onTap: () {
                  print("vô đây nèo");
                  getImage();
                },
                child: _image == null
                    ? Container(
                        width: 90.w,
                        height: 90.h,
                        padding: EdgeInsets.only(right: 12, bottom: 12,left: 12,top: 10),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black12),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        child: Image.asset(
                          "",
                          fit: BoxFit.fill,
                          color: Colors.black26,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        child: Image.file(
                          _image,
                          fit: BoxFit.cover,
                          width: 90.w,
                          height: 90.h,
                        ),
                      ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20.h),
              child: Text(
                'widget.name',
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
      // child: _image == null
      //     ? Text('No image selected.')
      //     : Image.file(_image),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: getImage,
      //   tooltip: 'Pick Image',
      //   child: Icon(Icons.add_a_photo),
      // ),
    );
  }
}
