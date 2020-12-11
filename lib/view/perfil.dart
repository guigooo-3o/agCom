import 'package:agendador_comunitario/common/avatar.dart';
import 'package:agendador_comunitario/common/busy_button.dart';
import 'package:agendador_comunitario/common/input_field.dart';
import 'package:agendador_comunitario/common/ui_helper.dart';
import 'package:agendador_comunitario/constants/routes.dart';
import 'package:agendador_comunitario/controller/auth_controller.dart';
import 'package:agendador_comunitario/controller/location_controller.dart';
import 'package:agendador_comunitario/controller/navigation_controller.dart';
import 'package:agendador_comunitario/controller/sign_up_controller.dart';
import 'package:agendador_comunitario/model/user.dart';
import 'package:agendador_comunitario/view/signup.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var maskFormatter = new MaskTextInputFormatter(mask: '##/##/####', filter: { "#": RegExp(r'[0-9]') });

  AuthenticationController _authenticationController= locator<
      AuthenticationController>();
  NavigationController _navigationController= locator<
      NavigationController>();
  final fullNameController= TextEditingController();
  final addressController= TextEditingController();
  final birthdateController= TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SignUpController>.withConsumer(
      viewModel: SignUpController(),
      builder: (context, model, child) =>
          Scaffold(
            appBar: AppBar(
              leading:  IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: ()=> _navigationController.navigateTo(HomePageRoute),
              ),
              title: Text ("AgCom"),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                              width: 3,
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget> [
                              CircleAvatar(
                                child: (model.selectedImage == null) ?
                                (model.currentUser.photoUrl!=null && model.currentUser.photoUrl.isNotEmpty) ? Material(
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Container(
                                      child: CircularProgressIndicator(),
                                      width: 200.0,
                                      height: 200.0,
                                      padding: EdgeInsets.all(20.0),
                                    ),
                                    imageUrl: model.currentUser.photoUrl,
                                    width: 200.0,
                                    height: 200.0,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(125.0)),
                                  clipBehavior: Clip.hardEdge,
                                ) :
                                Icon(Icons.person, size: 100, color: Colors.black,) :
                                Material(
                                  child: Image.file(model.selectedImage, width: 500.0, height: 500.0, fit: BoxFit.cover),
                                  borderRadius: BorderRadius.all(Radius.circular(125.0)),
                                  clipBehavior: Clip.hardEdge,
                                ),
                                radius: 50,
                                backgroundColor: Colors.black12,
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.camera_alt, color: Colors.white54.withOpacity(0.3),
                                ),
                                onPressed: () => model.selectImage(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      verticalSpaceMedium,
                      Text(
                        'Nome : ', style: TextStyle(fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey), textAlign: TextAlign.left,
                      ),
                      verticalSpaceSmall,
                      InputField(
                        placeholder: model.currentUser.fullName,
                        controller: fullNameController,
                        textInputType: TextInputType.name,
                      ),
                      verticalSpaceSmall,
                      Text(
                        'Cidade : ', style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey), textAlign: TextAlign.left,
                      ),
                      verticalSpaceSmall,
                      InputField(
                        placeholder: model.currentUser.address,
                        controller: addressController,
                      ),
                      verticalSpaceSmall,
                      Text(
                        'Data de Nascimento : ', style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey), textAlign: TextAlign.left,
                      ),
                      verticalSpaceSmall,
                      DateTimePicker(
                        textAlign: TextAlign.center,
                        type: DateTimePickerType.date,
                        initialValue: model.currentUser.birthdate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2021),
                        onChanged: (birthdate) => birthdateController.text= birthdate,
                        dateMask: 'dd/MM/yyyy',
                      ),
                      // InputField(
                      //   formatter: maskFormatter,
                      //   placeholder: model.currentUser.birthdate,
                      //   controller: birthdateController,
                      //   textInputType: TextInputType.datetime,
                      // ),
                      verticalSpaceMedium,
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          BusyButton(
                            title: 'Atualizar',
                            busy: model.busy,
                            onPressed: () {
                              model.editUser(AppUser(id: model.currentUser.id,
                                fullName: fullNameController.text=="" ? model.currentUser.fullName : fullNameController.text,
                                email: model.currentUser.email,
//                                password: model.currentUser.password,
                                address: addressController.text=="" ? model.currentUser.address : addressController.text,
                                birthdate: birthdateController.text=="" ? model.currentUser.birthdate : birthdateController.text,
                              ));
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }

  Widget _buildAvatar(AppUser user){
    return Column(
      children: <Widget>[
        Avatar(
          photoUrl: user.photoUrl,
          radius: 50,
        ),
        verticalSpaceSmall,
      ],
    );
  }
}



//class ProfilePage extends StatelessWidget {
//  AuthenticationController _authenticationController= locator<
//      AuthenticationController>();
//  NavigationController _navigationController= locator<
//      NavigationController>();
//  final fullNameController= TextEditingController();
//  final addressController= TextEditingController();
//  final birthdateController= TextEditingController();
//
//  @override
//  Widget build(BuildContext context) {
//    final Account account= ModalRoute.of(context).settings.arguments;
//
//    return ViewModelProvider<SignUpController>.withConsumer(
//      viewModel: SignUpController(),
//      builder: (context, model, child) => Scaffold(
//        appBar: AppBar(
//          title: Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Text("agCom"),
//          ),
//        ),
//        body: Center(
//          child: SingleChildScrollView(
//            child: Padding(
//              padding: const EdgeInsets.symmetric(horizontal: 50.0),
//              child: Column(
//                mainAxisSize: MainAxisSize.max,
//                mainAxisAlignment: MainAxisAlignment.center,
//                crossAxisAlignment: CrossAxisAlignment.center,
//                children: <Widget>[
//                  Center(child: _buildAvatar(model.currentUser)),
//                  Text(
//                  'Nome : ', style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.blueGrey), textAlign: TextAlign.left,
//                  ),
//                  verticalSpaceSmall,
//                  InputField(
//                    placeholder: model.currentUser.fullName,
//                    controller: fullNameController,
//                    textInputType: TextInputType.name,
//                  ),
//                  verticalSpaceSmall,
//                  Text(
//                    'Cidade : ', style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.blueGrey), textAlign: TextAlign.left,
//                  ),
//                  verticalSpaceSmall,
//                  InputField(
//                    placeholder: model.currentUser.address,
//                    controller: addressController,
//                  ),
//                  verticalSpaceSmall,
//                  Text(
//                    'Data de Nascimento : ', style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.blueGrey), textAlign: TextAlign.left,
//                  ),
//                  verticalSpaceSmall,
//                  InputField(
//                    //TODO date mask
//                    placeholder: model.currentUser.birthdate,
//                    controller: birthdateController,
//                    textInputType: TextInputType.datetime,
//                  ),
//                  verticalSpaceMedium,
//                  Row(
//                    mainAxisSize: MainAxisSize.max,
//                    mainAxisAlignment: MainAxisAlignment.end,
//                    children: [
//                      BusyButton(
//                        title: 'Atualizar',
//                        busy: model.busy,
//                        onPressed: () {
////                        model.signUp(email: account.email.text, password: account.password.text, );
//                        },
//                      )
//                    ],
//                  )
//                ],
//              ),
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//
//  Widget _buildAvatar(AppUser user){
//    return Column(
//      children: <Widget>[
//        Avatar(
//          photoUrl: user.photoUrl,
//          radius: 50,
//        ),
//        verticalSpaceSmall,
//        Text(
//          user.fullName,
//          style: TextStyle(color: Colors.white),
//        ),
//        verticalSpaceSmall,
//      ],
//    );
//  }
//}

