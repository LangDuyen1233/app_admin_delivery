import 'package:app_delivery/binding/instance_binding.dart';
import 'package:app_delivery/routes.dart';
import 'package:app_delivery/screen/auth/check_login.dart';
import 'package:app_delivery/screen/auth/login.dart';
import 'package:app_delivery/screen/index.dart';
import 'package:app_delivery/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

/// This is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white, // navigation bar color
      statusBarColor: Colors.transparent, // status bar color
      statusBarIconBrightness: Brightness.dark, // status bar icons' color
      systemNavigationBarIconBrightness:
          Brightness.dark, //navigation bar icons' color
    ));
    return ScreenUtilInit(
      designSize: Size(414, 896),
      builder: () => GetMaterialApp(
        initialBinding: InstanceBinding(),
        title: _title,
        // home: SignIn(),
        // home: CheckLogin(),
        // initialRoute: "/",
        // getPages: routes(),
        home: handleAuth(),
        builder: EasyLoading.init(),
      ),
    );
  }
}
