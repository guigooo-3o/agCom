
import 'package:agendador_comunitario/controller/activity_base_controller.dart';
import 'package:agendador_comunitario/controller/auth_controller.dart';
import 'package:agendador_comunitario/controller/cloud_storage_controller.dart';
import 'package:agendador_comunitario/controller/dialog_controller.dart';
import 'package:agendador_comunitario/controller/firestore_controller.dart';
import 'package:agendador_comunitario/controller/navigation_controller.dart';
import 'package:agendador_comunitario/controller/notification_controller.dart';
import 'package:agendador_comunitario/controller/startup_controller.dart';
import 'package:agendador_comunitario/util/image_selector.dart';
import 'package:get_it/get_it.dart';

GetIt locator= GetIt.instance;

void setupLocator(){
  locator.registerLazySingleton(() => AuthenticationController());
  locator.registerLazySingleton(() => NavigationController());
  locator.registerLazySingleton(() => DialogController());
  locator.registerLazySingleton(() => FirestoreController());
  locator.registerLazySingleton(() => CloudStorageController());
  locator.registerLazySingleton(() => ImageSelector());
  locator.registerLazySingleton(() => ActivityBaseController());
  locator.registerLazySingleton(() => NotificationController());
}