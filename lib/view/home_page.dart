import 'package:agendador_comunitario/controller/startup_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<StartUpController>.withConsumer(
      viewModel: StartUpController(),
      onModelReady: (model) => model.handleStartUpLogic(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: 300,
                height: 100,
                child: Image.asset('assets/images/logo3.png'),
              ),
              CircularProgressIndicator(strokeWidth: 3, valueColor: AlwaysStoppedAnimation(Colors.black26),)
            ],
          ),
        ),
      )
    );
  }
}


