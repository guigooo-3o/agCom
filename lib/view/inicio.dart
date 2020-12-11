import 'package:agendador_comunitario/common/avatar.dart';
import 'package:agendador_comunitario/common/named_divider.dart';
import 'package:agendador_comunitario/common/notification_item.dart';
import 'package:agendador_comunitario/common/ui_helper.dart';
import 'package:agendador_comunitario/constants/routes.dart';
import 'package:agendador_comunitario/controller/activity_base_controller.dart';
import 'package:agendador_comunitario/controller/location_controller.dart';
import 'package:agendador_comunitario/controller/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

class Inicio extends StatelessWidget {
  NavigationController _navigationController= locator<NavigationController>();
  
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ActivityBaseController>.withConsumer(
      reuseExisting: true,
      viewModel: ActivityBaseController(),
      onModelReady: (model) => model.currentUser!=null ? model.getUserNotifications() : null,
      builder: (context, model, child) => Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row (
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Avatar(
                            photoUrl: model.currentUser!= null ? model.currentUser.photoUrl : null,
                            enableIcon: false,
                            radius: 26,
                          ),
                          horizontalSpaceMedium,
                          model.currentUser == null ? Center(
                            child: Text("Bem vindo\nVisitante",
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),),
                          )
                          : Center(child: Text("Bem vindo\n${model.currentUser.fullName}", textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold), overflow: TextOverflow.clip)),
                        ],
                    ),
                  ),
            ),
              NamedDivider(
                text: 'Notificações',
              ),
            Expanded(
                child: model.notifications!= null ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: model.notifications.length ,
                      itemBuilder: (context, index) => NotificationItem(
                        notification: model.notifications[index],
                        onTap: () async =>_navigationController.navigateTo(InfoActivityHistoricoPageRoute, arguments: await model.getActivityById(model.notifications[index].activityId)),
                        onPressed:() { model.removeNotification(model.notifications[index]); _navigationController.navigateTo(HomePageRoute);}
                      ),
                ): Center(
                  child: Text ('Você não possui nenhuma nova notificação.', style: TextStyle(fontSize: 18),),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
