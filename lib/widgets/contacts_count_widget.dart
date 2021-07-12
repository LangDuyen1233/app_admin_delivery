import 'package:flutter/material.dart';
import 'auto_size_text_widget.dart';

class ContactsCountWidget extends StatelessWidget {
  final int contactsCount;

  ContactsCountWidget({this.contactsCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AutoSizeTextWidget(
        text: '${contactsCount ?? "0"} Contacts',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
