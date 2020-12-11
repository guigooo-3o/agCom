import 'package:agendador_comunitario/common/busy_button.dart';
import 'package:agendador_comunitario/common/input_field.dart';
import 'package:agendador_comunitario/constants/messages.dart';
import 'package:agendador_comunitario/controller/activity_base_controller.dart';
import 'package:agendador_comunitario/controller/chat_controller.dart';
import 'package:agendador_comunitario/controller/location_controller.dart';
import 'package:agendador_comunitario/controller/navigation_controller.dart';
import 'package:agendador_comunitario/model/activity.dart';
import 'package:agendador_comunitario/model/user.dart';
import 'package:agendador_comunitario/util/messages_stream.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider_architecture/provider_architecture.dart';

class ChatPage extends StatefulWidget {
  final Activity showingActivity;
  final AppUser currentUser;

  const ChatPage({Key key, this.showingActivity, this.currentUser}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState(showingActivity, currentUser);
}

class _ChatPageState extends State<ChatPage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  NavigationController _navigationController = locator<NavigationController>();
  final Activity showingActivity;
  final AppUser currentUser;

  String messageText;
  int hexColor;

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

//  Future<void> callback() async {
//    if (messageController.text.length > 0){
//      await _firestore.collection('messages').add({
//        'text': messageController.text,
//        'from': currentUser.fullName,
//      });
//      messageController.clear();
//      scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
//    }
//  }

  _ChatPageState(this.showingActivity, this.currentUser);

  @override
  void initState() {
    super.initState();
    hexColor= (math.Random().nextDouble() * 0xFFFFFF).toInt();
  }

  @override
  Widget build(BuildContext context) {
    final backend = ChatController(showingActivity.documentId);

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
        body: model.isUserInActivity() ? SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MessagesStream(loggedInUserEmail: currentUser.email, activityId: showingActivity.documentId),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        onChanged: (value) {
                          messageText = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        messageController.clear();
                        Map<String, dynamic> messageInstance = {
                          'text': messageText,
                          'sender': currentUser.email,
                          'username': currentUser.fullName,
                          'hexColor': hexColor,
                          'timeStamp': DateTime.now().millisecondsSinceEpoch,
                        };
                        backend.addMessage(messageInstance: messageInstance);
                      },
                      child: Text(
                        'Send',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ) : Center(child: Text('Ingresse na atividade para poder usar o chat.')),
      ),
    );
  }
//    return ViewModelProvider<ActivityBaseController>.withConsumer(
//      reuseExisting: true,
//      viewModel: ActivityBaseController(),
//      onModelReady: (model) => model.getListUsers(showingActivity),
//      builder: (context, model, child) => Scaffold(
//        appBar: AppBar(
//          leading:  IconButton(
//            icon: Icon(Icons.arrow_back),
//            onPressed: ()=> _navigationController.pop(),
//          ),
//          title: Text ("AgCom"),
//        ),
//        body: model.isUserInActivity() ? SafeArea(
//          child: Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Column(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              mainAxisSize: MainAxisSize.max,
//              children: <Widget>[
//                Expanded(
//                  child: StreamBuilder<QuerySnapshot>(
//                    stream: _firestore.collection('messages').snapshots(),
//                    builder: (context, snapshot){
//                      if (!snapshot.hasData)
//                        return Center(
//                            child: CircularProgressIndicator(),
//                        );
//                      List<DocumentSnapshot> documents= snapshot.data.docs;
//                      List<Widget> messages= documents.map((doc) => Messages(
//                        from: doc.data()['from'],
//                        text: doc.data()['text'],
//                        me: model.currentUser.fullName== doc.data()['from'],
//                      )). toList();
//                      return ListView(
//                        controller: scrollController,
//                        children: [
//                          ...messages,
//                        ],
//                      );
//                    }
//                  ),
//                ),
//                Row (
//                  children: <Widget>[
//                    Expanded(
//                      child: InputField(
//                        controller: messageController,
//                        placeholder: 'Digite sua mensagem aqui.',
//                      ),
//                    ),
//                    BusyButton(
//                      title: 'Enviar',
//                      busy: model.busy,
//                      enabled: true,
//                      onPressed: callback,
//                    )
//                  ],
//                )
//              ],
//            ),
//          ),
//        ) : Center(child: Text("Ingresse na atividade para poder ver o chat.")),
//      ),
//    );
//  }
}

//class Messages extends StatelessWidget {
//  final String from;
//  final String text;
//  final bool me;
//
//  const Messages({Key key, this.from, this.text, this.me}) : super(key: key);
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      child: Column(
//        crossAxisAlignment: me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//        children: [
//          Text (from),
//          Material (
//            color: me ? Colors.teal: Colors.red,
//            borderRadius: BorderRadius.circular(10),
//            elevation: 6,
//            child: Container(
//              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//              child: Text(text),
//            ),
//          )
//        ],
//      ),
//    );
//  }
//}

