import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {

  IconData icon;
  String text;
  Function onTap;

  MyListTile(this.icon, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Container(
        decoration: new BoxDecoration(
            border: Border(bottom: BorderSide(
              color: Colors.black26,
            ))
        ),
        child: InkWell(
          splashColor: Colors.black26,
          onTap: onTap,
          child: Container(
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(icon),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(text, style: TextStyle(
                        fontSize: 16.0,
                      )),
                    )
                  ],
                ),
                Icon(Icons.arrow_right)
              ],
            ),
          ),
        ),
      ),
    );
  }
}