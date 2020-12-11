import 'package:agendador_comunitario/model/activity.dart';
import 'package:flutter/material.dart';

class ActivityItem extends StatelessWidget {
  final Activity activity;
  final Function onTap;

  const ActivityItem({Key key, this.activity, this.onTap}) : super(key: key);

  bool hasPrice(){
    if (activity.price!= null){
      return true;
    } else{
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Column(
                children: <Widget> [
                  Icon(Icons.access_time,color: Colors.black,),
                  Text(activity.date),
                  Text(activity.hour),
                ],
              ),
          title: Text(activity.title, textAlign: TextAlign.center,),
          subtitle: Text(activity.description, textAlign: TextAlign.center,),
          trailing: Visibility(
            visible: hasPrice(),
            child: Column(
              children: [
                Text(activity.type),
                Icon(Icons.attach_money, color: Colors.black,),
                Text(activity.price.toString()),
              ],
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
