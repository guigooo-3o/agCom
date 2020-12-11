import 'dart:ui';

import 'package:agendador_comunitario/common/busy_button.dart';
import 'package:agendador_comunitario/common/input_field.dart';
import 'package:agendador_comunitario/common/named_divider.dart';
import 'package:agendador_comunitario/common/text_link.dart';
import 'package:agendador_comunitario/common/ui_helper.dart';
import 'package:agendador_comunitario/constants/routes.dart';
import 'package:agendador_comunitario/controller/activity_base_controller.dart';
import 'package:agendador_comunitario/controller/location_controller.dart';
import 'package:agendador_comunitario/controller/navigation_controller.dart';
import 'package:date_format/date_format.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';



class CreateActivityPage extends StatefulWidget {
  @override
  _CreateActivityPageState createState() => _CreateActivityPageState();
}

class _CreateActivityPageState extends State<CreateActivityPage> {

  var maskFormatterDate = new MaskTextInputFormatter(mask: '##/##/####', filter: { "#": RegExp(r'[0-9]') });
  var maskFormatterHour = new MaskTextInputFormatter(mask: '##:##', filter: { "#": RegExp(r'[0-9]') });

  NavigationController _navigationController = locator<NavigationController>();
  final hourController= TextEditingController();
  final dateController= TextEditingController();
  final otherController= TextEditingController();
  final descriptionController= TextEditingController();
  final participantsController= TextEditingController();
  final titleController= TextEditingController();
  final addressController= TextEditingController();
  final priceController= TextEditingController();
  String type;
  String groupValue;
  
  bool isOutros;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ActivityBaseController>.withConsumer(
      reuseExisting: true,
      viewModel: ActivityBaseController(),
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
                  text: 'Nova Atividade',
                ),
                // Row(
                //   mainAxisSize: MainAxisSize.max,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                  //   Flexible (
                  //     child: Text('Data:', style: TextStyle(fontStyle: FontStyle.italic,
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.blueGrey), textAlign: TextAlign.left,),
                  //   ),
                  //   horizontalSpaceTiny,
                  //   Expanded(
                  //     flex: 2,
                  //     child: InputField(
                  //       placeholder: 'xx/xx/xxxx',
                  //       formatter: maskFormatterDate,
                  //       controller: dateController,
                  //       textInputType: TextInputType.datetime,
                  //       onChanged: (date) {
                  //         _updateState();
                  //         },
                  //     ),
                  //   ),
                  //   horizontalSpaceMedium,
                  //   Flexible (
                  //     child: Text ('Horário:', style: TextStyle(fontStyle: FontStyle.italic,
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.blueGrey), textAlign: TextAlign.left,),
                  //   ),
                  //   horizontalSpaceTiny,
                  //   Flexible (
                  //     child: InputField(
                  //       placeholder: 'xx:xx',
                  //       formatter: maskFormatterHour,
                  //       controller: hourController,
                  //       textInputType: TextInputType.number,
                  //       onChanged: (hour) => _updateState(),
                  //     ),
                  //   ),
                    DateTimePicker(
                      type: DateTimePickerType.dateTimeSeparate,
                      dateMask: 'd MMM, yyyy',
                      initialValue: DateTime.now().toString(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      icon: Icon(Icons.event),
                      dateLabelText: 'Data',
                      timeLabelText: "Hora",
                      selectableDayPredicate: (date) {
                        return true;
                      },
                      onChanged: (val) {dateController.text= val.substring(0,10); hourController.text = val.substring(11);}
                    ),
                verticalSpaceMedium,
                //   ],
                // ),
                Text ('Tipo', style: TextStyle(fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey), textAlign: TextAlign.left,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonBar(
                      children: [
                        Text('Lazer'),
                        new Radio(
                          onChanged: (value) => checkRadio(value),
                          activeColor: Colors.blueGrey,
                          value: 'Lazer',
                          groupValue: groupValue,
                        ),
                        Text('Ensino'),
                        new Radio(
                          onChanged: (value) => checkRadio(value),
                          activeColor: Colors.blueGrey,
                          value: 'Ensino',
                          groupValue: groupValue,
                        ),
                        Text ('Outros'),
                        new Radio(
                          onChanged: (value) => checkRadio(value),
                          activeColor: Colors.blueGrey,
                          value: 'Outros',
                          groupValue: groupValue,
                        ),
                      ],
                    ),
                  ],
                ),
                verticalSpaceSmall,
                Visibility(
                  visible: isOutros!= null ? isOutros : false,
                  child: Column(
                    children: <Widget>[
                      Text('Descrição do tipo', style: TextStyle(fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey)
                      ),
                      verticalSpaceSmall,
                      InputField(
                        placeholder: 'Descreva o tipo de atividade que deseja criar.',
                        controller: otherController,
                        textInputType: TextInputType.text,
                      ),
                    ],
                  ),
                ),
                verticalSpaceSmall,
                Text('Titulo', style: TextStyle(fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey), textAlign: TextAlign.left,),
                InputField(
                  placeholder: 'Titulo',
                  controller: titleController,
                  textInputType: TextInputType.text,
                  onChanged: (title) => _updateState(),
                ),
                verticalSpaceSmall,
                Text ('Descrição', style: TextStyle(fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey), textAlign: TextAlign.left,),
                InputField(
                  placeholder: 'Descreva sua atividade',
                  controller: descriptionController,
                  textInputType: TextInputType.text,
                  onChanged: (description) => _updateState(),
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
                        placeholder: 'Participantes',
                        controller: participantsController,
                        textInputType: TextInputType.number,
                        onChanged: (nParticipants) => _updateState(),
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
                        placeholder: 'Valor',
                        controller: priceController,
                        textInputType: TextInputType.number,
                        onChanged: (price) => _updateState(),
                      ),
                    )
                  ],
                ),
                verticalSpaceMedium,
                Text('Cidade', style: TextStyle(fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey), textAlign: TextAlign.left,),
                InputField(
                  controller: addressController,
                  textInputType: TextInputType.text,
                  placeholder: 'Cidade',
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BusyButton(
                      title: 'Criar',
                      enabled: isSubmitReady(),
                      busy: model.busy,
                      onPressed: (){
                        if (!model.busy && isSubmitReady()){
                          model.addActivity(type: type, title: titleController.text, date: dateController.text, hour: hourController.text, description: descriptionController.text, address: addressController.text, typeDescription: otherController.text, price: double.parse(priceController.text), numberParticipants: int.parse(participantsController.text), status: "Created");
                        }
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isSubmitReady(){
    bool submitEnabled;
    if (type != null && type.compareTo('Outros')== 0)
      submitEnabled = titleController.text.isNotEmpty && descriptionController.text.isNotEmpty && dateController.text.isNotEmpty  && type.isNotEmpty && participantsController.text.isNotEmpty && priceController.text.isNotEmpty && otherController.text.isNotEmpty;
    else
      submitEnabled = titleController.text.isNotEmpty && descriptionController.text.isNotEmpty && dateController.text.isNotEmpty  && type.isNotEmpty && participantsController.text.isNotEmpty && priceController.text.isNotEmpty;

    return submitEnabled;
  }

  void _updateState() {
    setState(() {
    });
  }

  checkRadio(value) {
    setState(() {
      isOutros= false;
      groupValue = value;
      type= value;
      if (value.compareTo('Outros') == 0){
        isOutros= true;
      }
    });
  }
}
