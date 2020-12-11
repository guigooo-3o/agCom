import 'package:agendador_comunitario/common/activity_item.dart';
import 'package:agendador_comunitario/common/avatar.dart';
import 'package:agendador_comunitario/common/busy_button.dart';
import 'package:agendador_comunitario/common/input_field.dart';
import 'package:agendador_comunitario/common/named_divider.dart';
import 'package:agendador_comunitario/common/ui_helper.dart';
import 'package:agendador_comunitario/common/user_item.dart';
import 'package:agendador_comunitario/constants/routes.dart';
import 'package:agendador_comunitario/controller/activity_base_controller.dart';
import 'package:agendador_comunitario/controller/location_controller.dart';
import 'package:agendador_comunitario/controller/navigation_controller.dart';
import 'package:agendador_comunitario/model/activity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';

class InformacaoAtividadesHistorico extends StatelessWidget {
  NavigationController _navigationController= locator<NavigationController>();
  final Activity showingActivity;

  InformacaoAtividadesHistorico({Key key, this.showingActivity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ActivityBaseController>.withConsumer(
      reuseExisting: true,
      viewModel: ActivityBaseController(),
      onModelReady: (model) => model.getListUsers(showingActivity),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          leading:  IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: ()=> _navigationController.pop(),
          ),
          title: Text ("AgCom"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget> [
                NamedDivider(
                  text: 'Atividade',
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible (
                      child: Text('Data:', style: TextStyle(fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey), textAlign: TextAlign.left,),
                    ),
                    horizontalSpaceTiny,
                    Expanded(
                      flex: 2,
                      child: InputField(
                        placeholder: showingActivity.date,
                        formatter: MaskTextInputFormatter(mask: '##/##/####', filter: { "#": RegExp(r'[0-9]') }),
                        isReadOnly: true,
                        textInputType: TextInputType.datetime,
                      ),
                    ),
                    horizontalSpaceMedium,
                    Flexible (
                      child: Text ('Horário:', style: TextStyle(fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey), textAlign: TextAlign.left,),
                    ),
                    horizontalSpaceTiny,
                    Flexible (
                      child: InputField(
                        placeholder: showingActivity.hour,
                        formatter: MaskTextInputFormatter(mask: '##:##', filter: { "#": RegExp(r'[0-9]') }),
                        textInputType: TextInputType.number,
                        isReadOnly: true,
                      ),
                    ),
                  ],
                ),
                Text ('Tipo', style: TextStyle(fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey), textAlign: TextAlign.left,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(showingActivity.type),
                    Checkbox(
                      value: true,
                    ),
                  ],
                ),
                verticalSpaceSmall,
                Visibility(
                  visible: showingActivity.type == '[Outro]' ? true : false,
                  child: Column(
                    children: <Widget>[
                      Text('Descrição do tipo', style: TextStyle(fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey)
                      ),
                      verticalSpaceSmall,
                      InputField(
                        placeholder: showingActivity.typeDescription,
                        isReadOnly: true,
                      ),
                    ],
                  ),
                ),
                verticalSpaceSmall,
                Text('Titulo', style: TextStyle(fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey), textAlign: TextAlign.left,),
                InputField(
                  placeholder: showingActivity.title,
                  isReadOnly: true,
                ),
                verticalSpaceSmall,
                Text ('Descrição', style: TextStyle(fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey), textAlign: TextAlign.left,),
                InputField(
                  placeholder: showingActivity.description,
                  isReadOnly: true,
                ),
                verticalSpaceSmall,
                Row (
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: Text('Número de participantes:'
                        , style: TextStyle(fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey), textAlign: TextAlign.left,),
                    ),
                    horizontalSpaceTiny,
                    Expanded(
                      flex: 2,
                      child: InputField(
                        isReadOnly: true,
                        placeholder: showingActivity.numberParticipants.toString(),
                      ),
                    ),
                    horizontalSpaceMedium,
                    Flexible(
                      child: Text('Valor:',style: TextStyle(fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey), textAlign: TextAlign.left,),
                    ),
                    horizontalSpaceTiny,
                    Flexible(
                      child: InputField(
                        isReadOnly: true,
                        placeholder: showingActivity.price.toString(),
                      ),
                    )
                  ],
                ),
                verticalSpaceSmall,
                Text('Lista de Participantes', style: TextStyle(fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey), textAlign: TextAlign.left,),
                verticalSpaceTiny,
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                  ),
                  child: model.users!= null ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: model.users.length ,
                    itemBuilder: (context, index) => UserItem(
                      user: model.users[index],
                    ),
                  ): Center(
                    child: Text ('Ainda não há usuários nessa atividade'),
                  ),
                ),
                verticalSpaceSmall,
                Text('Endereço', style: TextStyle(fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey), textAlign: TextAlign.left,),
                InputField(
                  isReadOnly: true,
                  placeholder: showingActivity.address,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BusyButton(
                      title: 'Apagar',
                      onPressed: (){
                        model.deleteUserInActivity(showingActivity.documentId, model.currentUser.id);
                        _navigationController.navigateTo(HomePageRoute);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
