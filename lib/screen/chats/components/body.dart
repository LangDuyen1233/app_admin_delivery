
import 'package:app_delivery/components/filled_outline_button.dart';
import 'package:app_delivery/models/Chat.dart';
import 'package:app_delivery/screen/messages/message_screen.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'chat_card.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: chatsData.length,
            itemBuilder: (context, index) => ChatCard(
              chat: chatsData[index],
              press: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessagesScreen(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
