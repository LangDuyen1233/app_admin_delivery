import 'package:app_delivery/screen/index.dart';
import 'package:app_delivery/utils.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class CheckLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: checkIsSign(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data == true ? MyStatefulWidgetState() : SignIn();
          } else {
            return Container();
          }
        });
  }

  Future<bool> checkIsSign() async {
    String token = (await getToken());
    return token.isNotEmpty;
  }
}