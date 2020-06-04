import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
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
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('chats/hZ25P0awp3qvsGfTbAdP/messages')
            .snapshots(),
        builder: (context, snapshotData) {
          if (snapshotData.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final documents =
              snapshotData.data.documents as List<DocumentSnapshot>;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) => Container(
              padding: EdgeInsets.all(8),
              child: Text(documents[index]['text']),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Firestore.instance
              .collection('chats/hZ25P0awp3qvsGfTbAdP/messages')
              .add({'text': 'This message was added when clicking the button'});
        },
      ),
    );
  }
}
