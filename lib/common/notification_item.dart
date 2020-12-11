import 'package:agendador_comunitario/common/avatar.dart';
import 'package:agendador_comunitario/model/notification.dart';
import 'package:agendador_comunitario/model/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NotificationItem extends StatelessWidget {
  final AppNotification notification;
  final Function onPressed;
  final Function onTap;

  const NotificationItem({Key key, this.notification, this.onPressed, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(notification.title),
            subtitle: Text(notification.body),
            trailing: IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: onPressed,
            ),
            onTap: onTap,
          ),
      ),
    );
  }
}
