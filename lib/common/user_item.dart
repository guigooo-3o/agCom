import 'package:agendador_comunitario/common/avatar.dart';
import 'package:agendador_comunitario/model/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserItem extends StatelessWidget {
  final AppUser user;

  const UserItem({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey,
              child: (user.photoUrl!=null && user.photoUrl!="") ?
              CachedNetworkImage(
                imageUrl: user.photoUrl,
              ): Icon(Icons.person, size: 35,color: Colors.black,)
            ),
            title: Center(child: Text(user.fullName, textAlign: TextAlign.center,)),
          ),
        ),
    );
  }
}
