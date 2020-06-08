import 'package:flutter/material.dart';

class MessageBuble extends StatelessWidget {
  /// This key here is to help the parent widget (ListView) of this
  /// widget managing the re-rendering/updating its child widgets
  /// more effeciently
  final Key key;
  final String message;
  final String username;
  final String profileImageUrl;
  final bool isMe;

  MessageBuble({
    @required this.message,
    @required this.username,
    @required this.profileImageUrl,
    @required this.isMe,
    this.key,
  });

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
          constraints: BoxConstraints(maxWidth: 300),
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          margin: EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 8,
          ),
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    username,
                    textAlign: isMe ? TextAlign.right : TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isMe
                          ? Colors.black
                          : Theme.of(context)
                              .accentTextTheme
                              .headline6
                              .color,
                    ),
                  ),
                  Text(
                    message,
                    style: TextStyle(
                      color: isMe
                          ? Colors.black
                          : Theme.of(context)
                              .accentTextTheme
                              .headline6
                              .color,
                    ),
                  ),
                ],
              ),
              Positioned(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(profileImageUrl),
                  radius: 25,
                ),
                top: -40,
                left: isMe ? -45 : null,
                right: !isMe ? -45 : null,
              )
            ],
            overflow: Overflow.visible,
          ),
        ),
      ],
    );
  }
}
