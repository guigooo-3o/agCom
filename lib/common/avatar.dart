import 'dart:io';

import 'package:agendador_comunitario/controller/sign_up_controller.dart';
import 'package:agendador_comunitario/model/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider_architecture/_viewmodel_provider.dart';

//class Avatar extends StatefulWidget {
//  final String photoUrl;
//  final double radius;
//
//  const Avatar({Key key, this.photoUrl, this.radius}) : super(key: key);
//
//  @override
//  _AvatarState createState() => _AvatarState();
//}
//
//class _AvatarState extends State<Avatar> {
//  final String photoUrl;
//  final double radius;
//  File imageFileAvatar;
//  _AvatarState(this.photoUrl, this.radius);
//
//  Future getImage() async {
//    var image= await ImagePicker.pickImage(source: ImageSource.gallery);
//    setState(() {
//      imageFileAvatar = image;
//    });
//
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return ViewModelProvider<SignUpController>.withConsumer(
//      viewModel: SignUpController(),
//      builder: (context, model, child) =>
//      Container(
//        decoration: BoxDecoration(
//          shape: BoxShape.circle,
//          border: Border.all(
//            color: Colors.black,
//            width: 3,
//          ),
//        ),
//        child: Stack(
//          alignment: Alignment.center,
//          children: <Widget> [
//            CircleAvatar(
//              child: (imageFileAvatar == null) ? (photoUrl ==null) ? Icon(Icons.person, size: 100, color: Colors.black,) :
//              Material(
//                child: CachedNetworkImage (
//                  placeholder: (context, url) => Container(
//                    child: CircularProgressIndicator(
//                      strokeWidth: 2.0,
//                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
//                    ),
//                    width: 200.0,
//                    height: 200.0,
//                    padding: EdgeInsets.all(20.0),
//                  ),
//                  imageUrl: photoUrl,
//                  width: 200.0,
//                )
//              ),
//              radius: widget.radius,
//              backgroundColor: Colors.black12,
////              Image.file(model.selectedImage, width: 200.0, height: 200.0, fit: BoxFit.cover),
////              radius: widget.radius,
////              backgroundColor: Colors.black12,
////              backgroundImage: widget.photoUrl!= null ? NetworkImage(widget.photoUrl) : null ,
////              child: widget.photoUrl== null ? Icon(Icons.person, size: 100, color: Colors.black,) : null,
//            ),
//            IconButton(
//              icon: Icon(
//                Icons.camera_alt, color: Colors.white54.withOpacity(0.3),
//              ),
//              onPressed: () => model.selectImage(),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}

class Avatar extends StatelessWidget {
  final String photoUrl;
  final double radius;
  final bool enableIcon;
  File imageFileAvatar;

  Avatar({Key key, this.photoUrl, this.radius, this.imageFileAvatar, this.enableIcon}) : super(key: key);

//  Future getImage() async {
//    imageFileAvatar= await ImagePicker.pickImage(source: ImageSource.gallery);
//  }

  bool isIconEnabled(){
      return enableIcon;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SignUpController>.withConsumer(
      viewModel: SignUpController(),
      builder: (context, model, child) => Container(
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
              child: (model.selectedImage == null) ? (photoUrl!=null && photoUrl!="") ? Material(
                child: CachedNetworkImage(
                  placeholder: (context, url) => Container(
                    child: CircularProgressIndicator(),
                    width: 200.0,
                    height: 200.0,
                    padding: EdgeInsets.all(20.0),
                  ),
                  imageUrl: photoUrl,
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(125.0)),
                clipBehavior: Clip.hardEdge,
              ) : Icon(Icons.person, size: radius*2, color: Colors.black,) :
              Material(
                child: Image.file(model.selectedImage, width: 200.0, height: 200.0, fit: BoxFit.cover),
                borderRadius: BorderRadius.all(Radius.circular(125.0)),
                clipBehavior: Clip.hardEdge,
              ),
              radius: radius,
              backgroundColor: Colors.black12,
            ),
            isIconEnabled() ?
            IconButton(
              icon: Icon(
                Icons.camera_alt, color: Colors.white54.withOpacity(0.3),
              ),
              onPressed: () => model.selectImage(),
            ) : Container(),
          ],
        ),
      ),
    );
  }
}
