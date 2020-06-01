import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => Container(
          padding: EdgeInsets.all(8),
          child: Text('This works!'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Firestore.instance
              .collection('chats/hZ25P0awp3qvsGfTbAdP/messages')
              .snapshots()
              .listen((data) {
            data.documents.forEach((message) {
              print(message['text']);
            });
          });
        },
      ),
    );
  }
}
