import 'package:agendador_comunitario/common/activity_item.dart';
import 'package:agendador_comunitario/common/named_divider.dart';
import 'package:agendador_comunitario/common/ui_helper.dart';
import 'package:agendador_comunitario/constants/routes.dart';
import 'package:agendador_comunitario/controller/activity_base_controller.dart';
import 'package:agendador_comunitario/controller/location_controller.dart';
import 'package:agendador_comunitario/controller/navigation_controller.dart';
import 'package:agendador_comunitario/model/activity.dart';
import 'package:agendador_comunitario/model/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';

class Atividades extends StatefulWidget {
  @override
  _AtividadesState createState() => _AtividadesState();
}

class _AtividadesState extends State<Atividades>{
  bool isFiltered= false;
  NavigationController _navigationController= locator<NavigationController>();
  ActivityBaseController _activityBaseController = locator<ActivityBaseController>();
  var selectedType;
  var selectedCity;
  List filteredActivities =[];
  List activities= [];


  void _applyFilter (String city, String type){
    isFiltered= true;
    if (city!= null && city.isNotEmpty && type!=null && type.isNotEmpty) {
      filteredActivities = activities.where((activity) => (activity.address.compareTo(city)== 0 && activity.type.compareTo(type)== 0)).toList();
    } else if ((city == null || city.isEmpty) && type!=null && type.isNotEmpty) {
      filteredActivities = activities.where((activity) =>
      activity.type.compareTo(
          type.toString()) == 0).toList();
    } else if ((type == null || type.isEmpty) && city!=null && city.isNotEmpty){
      filteredActivities = activities.where((activity) =>
      activity.address.compareTo(
          city.toString()) == 0).toList();
    } else {
      filteredActivities = activities;
    }
  }

  // void _filterActivitiesByCity(value){
  //   isFiltered=true;
  //   setState(() {
  //     if (isFiltered && filteredActivities.length>0) {
  //       filteredActivities = filteredActivities.where((activity) => activity.address.compareTo(value.toString())== 0).toList();
  //     } else {
  //       filteredActivities =
  //           activities.where((activity) =>
  //           activity.address.compareTo(
  //               value.toString()) == 0).toList();
  //     }
  //   });
  // }
  //
  // void _filterActivitiesByType(value){
  //   isFiltered=true;
  //   setState(() {
  //     if (isFiltered && filteredActivities.length>0){
  //       filteredActivities= filteredActivities.where((activity) => activity.type.compareTo(value.toString())== 0).toList();
  //     } else {
  //       filteredActivities =
  //           activities.where((activity) => activity.type.compareTo(
  //               value.toString()) == 0).toList();
  //     }
  //   });
  // }

  bool getActivity (lstActivity) {
    if (lstActivity!= null){
       activities= lstActivity;
    }
    if (activities.length>0)
      return true;
    else
      return false;
  }

  List<String> _type= <String>[
    '',
    'Lazer',
    'Ensino',
    'Outros'
  ];

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ActivityBaseController>.withConsumer(
      reuseExisting: true,
      viewModel: ActivityBaseController(),
      onModelReady: (model) => model.listenToActivities(),
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
                children: [
                  Text ('Cidade: '),
                  horizontalSpaceTiny,
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('cities').snapshots(),
                    builder: (context, snapshot){
                      if (!snapshot.hasData){
                        Text ("Loading");
                      }else{
                        List<DropdownMenuItem> cityItems= [];
                        for (int i=0; i<snapshot.data.docs.length; i++){
                          DocumentSnapshot snap = snapshot.data.docs[i];
                          cityItems.add(
                            DropdownMenuItem(
                              child: Text(
                                snap.get('cidade'),
                              ),
                              value: "${snap.get('cidade')}",
                            ),
                          );
                        }
                        return DropdownButton(
                          items: cityItems,
                          onChanged: (cityValue){
                            setState(() {
                              selectedCity = cityValue;
                              _applyFilter(selectedCity,selectedType);
                              // _filterActivitiesByCity(selectedCity);
                            });
                          },
                          value: selectedCity,
                        );
                      }
                      return Container();
                    },
                  ),
                  horizontalSpaceMedium,
                  Text ('Tipo: '),
                  horizontalSpaceTiny,
                  DropdownButton(
                    items: _type.map((value) => DropdownMenuItem(
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.black),
                      ),
                      value: value,
                    )).toList(),
                    onChanged: (sType){
                      setState(() {
                        selectedType = sType;
                        _applyFilter(selectedCity, selectedType);
                        // _filterActivitiesByType(selectedType);
                      });
                    },
                    value: selectedType,
                  ),
                ],
              ),
            ),
            NamedDivider(text: 'Atividades',),
            Expanded(
              child: getActivity(model.activities) ? ListView.builder(
                itemCount: isFiltered ? filteredActivities.length : activities.length,
                itemBuilder: (context, index) => ActivityItem(
                  activity: isFiltered ? filteredActivities[index] : activities[index],
                  onTap: () => _navigationController.navigateTo(InfoActivityMenu, arguments: Chat(isFiltered ? filteredActivities[index] : activities[index], model.currentUser)),
                ),

              ): Center (
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                      Theme.of(context).primaryColor),
                ),
              ),
            ),
//            Expanded(
//              child: model.activities != null ? ListView.builder(
//                itemCount: model.activities.length ,
//                itemBuilder: (context, index) => ActivityItem(
//                  activity: model.activities[index],
//                  onTap: () => _navigationController.navigateTo(InfoActivityMenu, arguments: Chat(model.activities[index], model.currentUser)),
//                ),
//              ): Center(
//                child: CircularProgressIndicator(
//                  valueColor: AlwaysStoppedAnimation(
//                      Theme.of(context).primaryColor),
//                ),
//              ),
////              ) :
////              Center(
////                child: CircularProgressIndicator(
////                  valueColor: AlwaysStoppedAnimation(
////                    Theme.of(context).primaryColor),
////                  ),
////              ),
//            ),
          ],
        ),
      ),
    );
  }
}

//class Atividades extends StatelessWidget {
//  NavigationController _navigationController= locator<NavigationController>();
//
//  List<String> _type= <String>[
//    'Lazer',
//    'Ensino',
//    'Outros'
//  ];
//  @override
//  Widget build(BuildContext context) {
//    return ViewModelProvider<ActivityBaseController>.withConsumer(
//      reuseExisting: true,
//      viewModel: ActivityBaseController(),
//      onModelReady: (model) => model.listenToActivities(),
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
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                crossAxisAlignment: CrossAxisAlignment.center,
//                children: [
//                  Text ('Cidade: '),
//                  horizontalSpaceTiny,
//                  DropdownButton(
//                    value: 'Todos',
//                    items: [],
//
//                  ),
//                  Text ('Tipo: '),
//                  horizontalSpaceTiny,
//                  DropdownButton(
//                    items: _type.map((value) => DropdownMenuItem(
//                      child: Text(
//                        value,
//                        style: TextStyle(color: Colors.black),
//                      ),
//                      value: value,
//                    )).toList(),
//                    onChanged: (selectedType){
//
//                    },
//                  ),
//                ],
//              ),
//            ),
//            NamedDivider(text: 'Atividades',),
//            Expanded(
//              child: model.activities != null ? ListView.builder(
//                itemCount: model.activities.length ,
//                itemBuilder: (context, index) => ActivityItem(
//                  activity: model.activities[index],
//                  onTap: () => _navigationController.navigateTo(InfoActivityMenu, arguments: Chat(model.activities[index], model.currentUser)),
//                ),
//              ): Center(
//                child: CircularProgressIndicator(
//                  valueColor: AlwaysStoppedAnimation(
//                    Theme.of(context).primaryColor),
//                  ),
//              ),
////              ) :
////              Center(
////                child: CircularProgressIndicator(
////                  valueColor: AlwaysStoppedAnimation(
////                    Theme.of(context).primaryColor),
////                  ),
////              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}