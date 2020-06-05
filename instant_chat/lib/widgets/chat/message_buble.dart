import 'package:flutter/material.dart';

class MessageBuble extends StatelessWidget {
  /// This key here is to help the parent widget (ListView) of this
  /// widget managing the re-rendering/updating its child widgets
  /// more effeciently
  final Key key;
  final String message;
  final bool isMe;

  MessageBuble(this.message, this.isMe, {this.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: isMe ? Colors.blue[100] : Theme.of(context).accentColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: isMe ? Radius.circular(12) : Radius.zero,
              bottomRight: !isMe ? Radius.circular(12) : Radius.zero,
            ),
          ),
          constraints: BoxConstraints(maxWidth: 340),
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          margin: EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          child: Text(
            message,
            style: TextStyle(
              color: isMe
                  ? Colors.black
                  : Theme.of(context).accentTextTheme.headline6.color,
            ),
          ),
        ),
      ],
    );
  }
}
