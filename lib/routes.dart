import 'package:app_delivery/screen/login_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

routes() => [
      GetPage(
        name: LoginScreen.pageId,
        page: () => LoginScreen(),
      ),
    ];
