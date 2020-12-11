import 'package:agendador_comunitario/common/busy_button.dart';
import 'package:agendador_comunitario/common/input_field.dart';
import 'package:agendador_comunitario/common/list_tiles.dart';
import 'package:agendador_comunitario/common/text_link.dart';
import 'package:agendador_comunitario/common/ui_helper.dart';
import 'package:agendador_comunitario/constants/routes.dart';
import 'package:agendador_comunitario/controller/location_controller.dart';
import 'package:agendador_comunitario/controller/login_controller.dart';
import 'package:agendador_comunitario/controller/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';

import 'signup.dart';

class LoginPage extends StatefulWidget {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

//  LoginPage({this.auth});
//  final BaseAuth auth;
  @override
  _LoginPageState createState() => _LoginPageState();
}

//enum FormType{
//  login,
//  signup
//}

class _LoginPageState extends State<LoginPage>{

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
//  final Function (User) onLogin;
//  final formKey= new GlobalKey<FormState>();
//
//  String _email;
//  String _password;
//  FormType _formType = FormType.login;
//
//  bool validateAndSave(){
//    final form= formKey.currentState;
//    if (form.validate()){
//      form.save();
//      return true;
//    }
//    return false;
//  }
//
//  void validateAndSubmit() async {
//    if (validateAndSave()){
//      try {
//        if (_formType == FormType.login) {
//          String userId= await widget.auth.signInWithEmailAndPassword(_email, _password);
//          print ('Signed in with $userId');
//        } else{
//          String userId= await widget.auth.createUserWithEmailAndPassword( _email, _password);
//          print ('Created $userId');
//        }
//      }catch(e){
//        print ('Error $e');
//      }
//    }
//  }
//
//  void moveToSignUp(){
//    formKey.currentState.reset();
//    setState(() {
//      _formType = FormType.signup;
//    });
//  }
//
//  void moveToLogin(){
//    formKey.currentState.reset();
//    setState(() {
//      _formType= FormType.login;
//    });
//  }

  @override
  Widget build(BuildContext context) {
    final NavigationController _navigationController = locator<
        NavigationController>();

    return ViewModelProvider<LoginController>.withConsumer(
        viewModel: LoginController(),
        builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            leading:  IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: ()=> _navigationController.navigateTo(HomePageRoute),
            ),
            title: Text ("AgCom"),
            ),
          endDrawer: Drawer(
            child: ListView(
              children: <Widget>[
                DrawerHeader (
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
                        Material (
                            borderRadius: BorderRadius.all(Radius.circular(50.0)),
                            elevation: 10.0,
                            child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Image.asset('assets/images/empty_avatar.png', width: 80, height: 80,)
                            )
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text ('Visitante', style: TextStyle(color: Colors.white, fontSize: 20),),
                        )
                      ],
                    ),
                  ),
                ),
                MyListTile(
                  Icons.lock_open, 'Entrar', ()=> _navigationController.navigateTo(LoginPageRoute),
                ),
                MyListTile(Icons.person_add, 'Cadastrar', ()=> _navigationController.navigateTo(SignUpPageRoute),
                ),
              ],
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Entrar',
                      style: TextStyle(
                        fontSize: 38,
                      ),
                    ),
                    verticalSpaceMedium,
                    InputField(
                      placeholder: 'Email',
                      controller: emailController,
                      textInputType: TextInputType.emailAddress,
                    ),
                    verticalSpaceSmall,
                    InputField(
                      placeholder: 'Senha',
                      password: true,
                      controller: passwordController,
                    ),
                    verticalSpaceMedium,
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        BusyButton(
                          title: 'Entrar',
                          busy: model.busy,
                          onPressed: () {
                            model.login(email: emailController.text, password: passwordController.text);
                          },
                        )
                      ],
                    ),
                    verticalSpaceMedium,
                    TextLink(
                      'Ainda não tem uma conta? Cadastre-se',
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => SignUpPage(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }

//  List<Widget> buildInputs(){
//    return[
//      TextFormField(
//        decoration: InputDecoration(labelText: 'Email'),
//        validator: (value)=> value.isEmpty ? 'Email não pode ser vazio' : null,
//        onSaved: (value) => _email= value,
//      ),
//      TextFormField(
//        decoration: InputDecoration(labelText: 'Password'),
//        obscureText: true,
//        validator: (value)=> value.isEmpty ? 'Senha não pode ser vazia' : null,
//        onSaved: (value) => _password= value,
//      ),
//    ];
//  }
//
//  List<Widget> buildSubmitButtons(){
//    if (_formType == FormType.login) {
//      return [
//        new RaisedButton(
//          child: Text('Login', style: TextStyle(fontSize: 20),),
//          onPressed: validateAndSubmit,
//        ),
//        FlatButton(
//          child: Text('Não possui conta? Cadastre-se', style: TextStyle(fontSize: 20),),
//          onPressed: moveToSignUp,
//        ),
//      ];
//    } else{
//      return [
//        new RaisedButton(
//          child: Text('Criar Conta', style: TextStyle(fontSize: 20),),
//          onPressed: validateAndSubmit,
//        ),
//        FlatButton(
//          child: Text('Já tem uma conta? Entrar', style: TextStyle(fontSize: 20),),
//          onPressed: moveToLogin,
//        ),
//      ];
//    }
//  }
}
