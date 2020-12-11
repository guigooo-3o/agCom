import 'package:agendador_comunitario/common/avatar.dart';
import 'package:agendador_comunitario/common/list_tiles.dart';
import 'package:agendador_comunitario/constants/routes.dart';
import 'package:agendador_comunitario/controller/auth_controller.dart';
import 'package:agendador_comunitario/controller/location_controller.dart';
import 'package:agendador_comunitario/controller/navigation_controller.dart';
import 'package:agendador_comunitario/controller/startup_controller.dart';
import 'package:agendador_comunitario/view/atividades.dart';
import 'package:agendador_comunitario/view/historico.dart';
import 'package:agendador_comunitario/view/inicio.dart';
import 'package:agendador_comunitario/view/minhas_atividades.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';

class OnlineHomePage extends StatelessWidget {
  final NavigationController _navigationController = locator<
      NavigationController>();
  final AuthenticationController _authenticationController= locator<AuthenticationController>();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<StartUpController>.withConsumer(
      viewModel: StartUpController(),
      builder: (context, model, child) => DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            leading: Image.asset('assets/images/logo5.png'),
            centerTitle: false,
            title: Text ("AgCom"),
            bottom: TabBar(
                tabs: <Widget>[
                  Text("Início", style: TextStyle(fontSize: 18)),
                  Text("Atividades", style: TextStyle(fontSize: 18)),
                  Text("Minhas Atividades", style: TextStyle(fontSize: 18)),
                  Text("Histórico", style: TextStyle(fontSize: 18)),
                ]
            ),
          ),
          endDrawer: Drawer(
              child: ListView(
                children: <Widget>[
                  Container(
                    height: 180.0,
                    child: DrawerHeader (
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: <Color> [
                                Colors.blueGrey,
                                Colors.grey
                              ]
                          )
                      ),
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Avatar(
                              photoUrl: model.currentUser.photoUrl,
                              enableIcon: false,
                              radius: 50,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text (model.currentUser.fullName, style: TextStyle(color: Colors.white, fontSize: 20),),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  MyListTile(Icons.person, 'Perfil', ()=>_navigationController.navigateTo(ProfilePageRoute)),
                  MyListTile(Icons.notifications, 'Notificações', ()=>[]),
                  MyListTile(Icons.settings, 'Configurações', ()=>[]),
                  MyListTile(Icons.lock, 'Log Out', ()=> {_authenticationController.SignOut(), _navigationController.navigateTo(HomePageRoute)}),
                ],
              )
          ),
          body: TabBarView(
            children: <Widget>[
              Inicio(),
              Atividades(),
              MinhasAtividades(),
              Historico(),
            ],
          ),
        ),
      ),
    );
  }
}
