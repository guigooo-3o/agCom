import 'dart:io';

import 'package:agendador_comunitario/common/avatar.dart';
import 'package:agendador_comunitario/common/busy_button.dart';
import 'package:agendador_comunitario/common/input_field.dart';
import 'package:agendador_comunitario/common/list_tiles.dart';
import 'package:agendador_comunitario/common/ui_helper.dart';
import 'package:agendador_comunitario/constants/routes.dart';
import 'package:agendador_comunitario/controller/location_controller.dart';
import 'package:agendador_comunitario/controller/navigation_controller.dart';
import 'package:agendador_comunitario/controller/sign_up_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';


class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var maskFormatter = new MaskTextInputFormatter(mask: '##/##/####', filter: { "#": RegExp(r'[0-9]') });

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController= TextEditingController();
  final addressController= TextEditingController();
  final birthdateController= TextEditingController();
  final photoUrlController= TextEditingController();

  final NavigationController _navigationController = locator<
      NavigationController>();

  String get _email => emailController.text;
  String get _password => passwordController.text;
  String get _fullName => fullNameController.text;
  String get _address => addressController.text;
  String get _birthdate => birthdateController.text;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SignUpController>.withConsumer (
      viewModel: SignUpController(),
      builder: (context, model, child) =>
          Scaffold(
            appBar: AppBar(
              leading:  IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => _navigationController.navigateTo(HomePageRoute) ,
              ),
              title: Text ("AgCom"),
            ),
            endDrawer: Drawer(
              child: ListView(
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: <Color>[
                              Colors.blueGrey,
                              Colors.grey
                            ]
                        )
                    ),
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Material(
                              borderRadius: BorderRadius.all(Radius.circular(
                                  50.0)),
                              elevation: 10.0,
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'assets/images/empty_avatar.png', width: 80,
                                    height: 80,)
                              )
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Visitante', style: TextStyle(
                                color: Colors.white, fontSize: 20),),
                          )
                        ],
                      ),
                    ),
                  ),
                  MyListTile(
                    Icons.lock_open, 'Entrar', () =>
                      _navigationController.navigateTo(LoginPageRoute),
                  ),
                  MyListTile(Icons.person_add, 'Cadastrar', () =>
                      _navigationController.navigateTo(SignUpPageRoute),
                  ),
                ],
              ),
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
                      Text(
                        'Cadastrar',
                        style: TextStyle(
                          fontSize: 38,
                        ),
                      ),
                      verticalSpaceMedium,
                      InputField(
                        placeholder: 'Email',
                        textInputType: TextInputType.emailAddress,
                        controller: emailController,
                        onChanged: (email) => _updateState(),
                      ),
                      verticalSpaceSmall,
                      InputField(
                        placeholder: 'Senha',
                        password: true,
                        controller: passwordController,
                        additionalNote: 'Senha deve ter um mínimo de 6 caracteres.',
                        onChanged: (password) => _updateState(),
                      ),
                      verticalSpaceMedium,
                      InputField(
                        placeholder: 'Nome',
                        controller: fullNameController,
                        textInputType: TextInputType.name,
                        onChanged: (fullName) => _updateState(),
                      ),
                      verticalSpaceSmall,
                      InputField(
                        placeholder: 'Cidade',
                        controller: addressController,
                        onChanged: (address) => _updateState(),
                      ),
                      verticalSpaceSmall,
                      DateTimePicker(
                        type: DateTimePickerType.date,
                        textAlign: TextAlign.center,
                        initialValue: DateTime.now().toString(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2021),
                        dateLabelText: 'Data de Nascimento',
                        onChanged: (birthdate) {
                          birthdateController.text= birthdate;
                          _updateState();
                        },
                        dateMask: 'dd/MM/yyyy',
                      ),
                      // InputField(
                      //   placeholder: 'Data de nascimento',
                      //   formatter: maskFormatter,
                      //   textInputType: TextInputType.datetime,
                      //   controller: birthdateController,
                      //   onChanged: (birthdate) => _updateState(),
                      // ),
                      verticalSpaceMedium,
                      Text(
                        'Escolha sua imagem de perfil:',
                        style: TextStyle(fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey), textAlign: TextAlign.left,
                      ),
                      verticalSpaceSmall,
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black,
                            width: 3,
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>
                          [
                            CircleAvatar(
                              child: (model.selectedImage == null) ?
//                              (model.currentUser.photoUrl!=null) ? Material(
//                                child: CachedNetworkImage(
//                                  placeholder: (context, url) => Container(
//                                    child: CircularProgressIndicator(),
//                                    width: 200.0,
//                                    height: 200.0,
//                                    padding: EdgeInsets.all(20.0),
//                                  ),
//                                  imageUrl: model.currentUser.photoUrl,
//                                  width: 200.0,
//                                  height: 200.0,
//                                  fit: BoxFit.cover,
//                                ),
//                              )
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
                      verticalSpaceMedium,
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          BusyButton(
                            title: 'Cadastrar',
                            enabled: isSubmitReady(),
                            busy: model.busy,
                            onPressed: () {
                              isSubmitReady() ?
                              model.signUp(email: emailController.text,
                                password: passwordController.text,
                                address: addressController.text,
                                fullName: fullNameController.text,
                                birthdate: birthdateController.text,
                              ) : null;
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

  bool isSubmitReady(){
    bool submitEnabled = _email.isNotEmpty && _password.isNotEmpty && _fullName.isNotEmpty && _address.isNotEmpty && _birthdate.isNotEmpty;
    return submitEnabled;
  }

  void _updateState() {
    setState(() {
    });
  }
}
