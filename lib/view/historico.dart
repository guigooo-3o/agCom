import 'package:agendador_comunitario/common/activity_item.dart';
import 'package:agendador_comunitario/common/named_divider.dart';
import 'package:agendador_comunitario/constants/routes.dart';
import 'package:agendador_comunitario/controller/activity_base_controller.dart';
import 'package:agendador_comunitario/controller/location_controller.dart';
import 'package:agendador_comunitario/controller/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';

class Historico extends StatefulWidget {
  @override
  _HistoricoState createState() => _HistoricoState();
}

class _HistoricoState extends State<Historico> {
  NavigationController _navigationController = locator<NavigationController>();
  // List activities= [];
  //
  // bool getActivity (lstActivity) {
  //   if (lstActivity!= null){
  //     activities= lstActivity;
  //   }
  //   if (activities.length>0)
  //     return true;
  //   else
  //     return false;
  // }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ActivityBaseController>.withConsumer(
      reuseExisting: true,
      viewModel: ActivityBaseController(),
      onModelReady: (model) => model.listenToMyPastActivities(),
      builder: (context, model, child) => Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            NamedDivider(
              text: 'Histórico',
            ),
            Expanded(
              child: model.myPastActivities!= null ? ListView.builder(
                itemCount: model.myPastActivities.length ,
                itemBuilder: (context, index) => ActivityItem(
                  activity: model.myPastActivities[index],
                  onTap: () => _navigationController.navigateTo(InfoActivityHistoricoPageRoute, arguments: model.myPastActivities[index]),
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

//class Historico extends StatelessWidget {
//  NavigationController _navigationController = locator<NavigationController>();
//
//  @override
//  Widget build(BuildContext context) {
//    return ViewModelProvider<ActivityBaseController>.withConsumer(
//      reuseExisting: true,
//      viewModel: ActivityBaseController(),
//      onModelReady: (model) => model.listenToMyPastActivities(),
//      builder: (context, model, child) => Container(
//        child: Column(
//          mainAxisSize: MainAxisSize.max,
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          crossAxisAlignment: CrossAxisAlignment.center,
//          children: <Widget>[
//            NamedDivider(
//              text: 'Histórico',
//            ),
//            Expanded(
//              child: model.myPastActivities != null ? ListView.builder(
//                itemCount: model.myPastActivities.length ,
//                itemBuilder: (context, index) => ActivityItem(
//                  activity: model.myPastActivities[index],
//                  onTap: () => _navigationController.navigateTo(InfoActivityHistoricoPageRoute, arguments: model.myPastActivities[index]),
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
