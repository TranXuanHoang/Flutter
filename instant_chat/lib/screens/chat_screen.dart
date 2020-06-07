import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../widgets/chat/messages.dart';
import '../widgets/chat/new_message.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();

    // Request permissions for receiving Push Notifications.
    // This will bring up a permissions dialog for the user to confirm on iOS.
    // It's a no-op on Android. For more detail about this, head over to
    // https://pub.dev/packages/firebase_messaging#dartflutter-integration
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(
      onMessage: (message) {
        print('onMessage: $message');
        return;
      },
      onResume: (message) {
        print('onResume: $message');
        return;
      },
      onLaunch: (message) {
        print('onLaunch: $message');
        return;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room'),
        actions: <Widget>[
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 8),
                      Text('Logout')
                    ],
                  ),
                ),
                value: 'logout',
                onTap: () {
                  FirebaseAuth.instance.signOut();
                },
              ),
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.announcement),
                      SizedBox(width: 8),
                      Text('Announcement')
                    ],
                  ),
                ),
                value: 'announcement',
                onTap: () {
                  print('announcement');
                },
              ),
            ],
            onChanged: (value) {
              print('onChange: $value');
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Messages(),
          ),
          NewMessage(),
        ],
      ),
    );
  }
}
