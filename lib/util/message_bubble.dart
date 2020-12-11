import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {@required this.sender,
        @required this.text,
        @required this.time,
        @required this.isMe,
        this.hexColor});
  final String sender;
  final String text;
  final String time;
  final int hexColor;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            time,
            style: TextStyle(
              fontSize: 11.0,
              fontWeight: FontWeight.w700,
              color: Colors.black54,
            ),
          ),
          Text(
            isMe ? 'You' : sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
              topLeft: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            )
                : BorderRadius.only(
              topRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            elevation: 5.0,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
