import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:the_chat/widget/messages.dart';
import 'package:the_chat/widget/new_message.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((event) {
      print(event);
      return;
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print(event);
      return;
    });
    final fbm = FirebaseMessaging.instance;
    fbm.subscribeToTopic('messages');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stream'),
        actions: [
          DropdownButton(
            underline: Container(),
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Row(
                  children: const [
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.black87,
                    ),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
                value: 'logout',
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: Messages()),
          NewMessage(),
        ],
      ),
    );
  }
}
