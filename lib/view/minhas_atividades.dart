import 'package:agendador_comunitario/common/activity_item.dart';
import 'package:agendador_comunitario/common/named_divider.dart';
import 'package:agendador_comunitario/common/ui_helper.dart';
import 'package:agendador_comunitario/constants/routes.dart';
import 'package:agendador_comunitario/controller/activity_base_controller.dart';
import 'package:agendador_comunitario/controller/dialog_controller.dart';
import 'package:agendador_comunitario/controller/location_controller.dart';
import 'package:agendador_comunitario/controller/navigation_controller.dart';
import 'package:agendador_comunitario/model/chat.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';

class MinhasAtividades extends StatefulWidget {
  @override
  _MinhasAtividadesState createState() => _MinhasAtividadesState();
}

class _MinhasAtividadesState extends State<MinhasAtividades> {
  NavigationController _navigationController = locator<NavigationController>();
  DialogController _dialogController = locator<DialogController>();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ActivityBaseController>.withConsumer(
      viewModel: ActivityBaseController(),
      reuseExisting: true,
      onModelReady: (model) => model.listenToMyActivities(),
      builder: (context, model, child) => Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.add_circle_outline, color: Colors.black, size: 50,),
                    onPressed:() => _navigationController.navigateTo(CreateActivityPageRoute),
                  ),
                  horizontalSpaceMedium,
                  Text('Criar nova atividade', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold), ),
                ],
              ),
            ),
            NamedDivider(
              text: 'Minhas atividades',
            ),
            Expanded(
              child: model.myActivities != null ? ListView.builder(
                itemCount: model.myActivities.length ,
                itemBuilder: (context, index) => ActivityItem(
                  activity: model.myActivities[index],
                  onTap: () => _navigationController.navigateTo(InfoActivityMenu, arguments: Chat(model.myActivities[index], model.currentUser)),
                ),
              ): Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                      Theme.of(context).primaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//class MinhasAtividades extends StatelessWidget {
//  NavigationController _navigationController = locator<NavigationController>();
//  DialogController _dialogController = locator<DialogController>();
//
//  @override
//  Widget build(BuildContext context) {
//    return ViewModelProvider<ActivityBaseController>.withConsumer(
//      viewModel: ActivityBaseController(),
//      reuseExisting: true,
//      onModelReady: (model) => model.listenToMyActivities(),
//      builder: (context, model, child) => Container(
//        child: Column(
//          mainAxisSize: MainAxisSize.max,
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          crossAxisAlignment: CrossAxisAlignment.center,
//          children: <Widget>[
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: Row(
//                mainAxisSize: MainAxisSize.max,
//                mainAxisAlignment: MainAxisAlignment.center,
//                crossAxisAlignment: CrossAxisAlignment.center,
//                children: <Widget>[
//                  IconButton(
//                    icon: Icon(Icons.add_circle_outline, color: Colors.black, size: 50,),
//                  onPressed:() => _navigationController.navigateTo(CreateActivityPageRoute),
//                  ),
//                  horizontalSpaceMedium,
//                  Text('Criar nova atividade', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold), ),
//                ],
//              ),
//            ),
//           NamedDivider(
//             text: 'Minhas atividades',
//           ),
//            Expanded(
//              child: model.myActivities != null ? ListView.builder(
//                itemCount: model.myActivities.length ,
//                itemBuilder: (context, index) => ActivityItem(
//                  activity: model.myActivities[index],
//                  onTap: () => _navigationController.navigateTo(InfoActivityMenu, arguments: Chat(model.myActivities[index], model.currentUser)),
//                ),
//              ): Center(
//                child: CircularProgressIndicator(
//                  valueColor: AlwaysStoppedAnimation(
//                      Theme.of(context).primaryColor),
//                ),
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}
