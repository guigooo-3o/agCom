import 'package:agendador_comunitario/controller/location_controller.dart';
import 'package:agendador_comunitario/controller/navigation_controller.dart';
import 'package:agendador_comunitario/model/activity.dart';
import 'package:agendador_comunitario/model/user.dart';
import 'package:agendador_comunitario/view/chat_page.dart';
import 'package:agendador_comunitario/view/info_atividades.dart';
import 'package:flutter/material.dart';

class BottomMenu extends StatefulWidget {
  final Activity showingActivity;
  final AppUser currentUser;

  const BottomMenu({Key key, this.showingActivity, this.currentUser}) : super(key: key);
  @override
  _BottomMenuState createState() => _BottomMenuState(showingActivity, currentUser);
}

class _BottomMenuState extends State<BottomMenu> {

  final Activity showingActivity;
  final AppUser currentUser;
  NavigationController _navigationController= locator<NavigationController>();
  int _currentIndex=0;
  _BottomMenuState(this.showingActivity, this.currentUser);

  @override
  Widget build(BuildContext context) {

    final tabs = [
      InformacaoAtividades(showingActivity: showingActivity,),
      ChatPage(showingActivity: showingActivity, currentUser: currentUser),
    ];

    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          iconSize: 30,
          onTap: (index){
            setState(() {
              _currentIndex= index;
            });
          },
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              title: Text('Detalhes'),
              icon: Icon(Icons.description),
            ),
            BottomNavigationBarItem(
              title: Text('Chat'),
              icon: Icon(Icons.comment),
            ),
          ],
        ),
    );
  }
}
