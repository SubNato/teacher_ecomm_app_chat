import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_teacher_bloc/common/routes/observers.dart';
import 'package:learn_teacher_bloc/common/services/storage.dart';
import 'package:learn_teacher_bloc/global.dart';



import '../../pages/messages/chat/bloc/chat_blocs.dart';
import '../../pages/messages/chat/chat.dart';
import '../../pages/messages/message/cubit/message_cubits.dart';
import '../../pages/messages/message/message.dart';
import '../../pages/sign_in/bloc/sign_in_blocs.dart';
import '../../pages/sign_in/sign_in.dart';
import '../../pages/welcome/bloc/welcome_blocs.dart';
import '../../pages/welcome/welcome.dart';
import 'routes.dart';

class AppPages {
  static final RouteObserver<Route> observer = RouteObservers();
  static List<String> history = [];

  static List<PageEntity> Routes(){
    return [
      PageEntity(
          path:AppRoutes.INITIAL,
          page:Welcome(),
          bloc:BlocProvider(create: (_) => WelcomeBloc())
      ),

      PageEntity(
          path:AppRoutes.Sign_in,
          page:SignIn(),
          bloc:BlocProvider(create: (_) => SignInBloc())
      ),

      PageEntity(
          path:AppRoutes.Message,
          page:Messages(),
          bloc:BlocProvider(create: (_) => MessageCubits())
      ),

      PageEntity(
          path:AppRoutes.Chat,
          page:Chat(),
          bloc:BlocProvider(create: (_) => ChatBlocs())
      ),
/*
      PageEntity(
          path:AppRoutes.Profile,
          page:Profile(),
          bloc:BlocProvider(create: (_) => ProfileBloc())
      ),*/
    ];
  }

  static List<dynamic> Blocer(BuildContext context){
    List<dynamic> blocerList = <dynamic>[];
    for(var blocer in Routes()){
      blocerList.add(blocer.bloc);
    }
    return blocerList;
  }



  static MaterialPageRoute GenerateRouteSettings(RouteSettings settings) {

      if(settings.name!=null){
        var result = Routes().where((element) => element.path==settings.name);
        if(result.isNotEmpty){
          // first open App
         bool deviceFirstOpen = Global.storageService.getDeviceFirstOpen();
         if(result.first.path==AppRoutes.INITIAL && deviceFirstOpen){
           bool isLogin = Global.storageService.getIsLogin();
           //is login
           if(isLogin){
             return MaterialPageRoute<void>(builder: (_) => Messages(),settings: settings);
           }
           return MaterialPageRoute<void>(builder: (_) => SignIn(),settings: settings);
         }
          return MaterialPageRoute<void>(builder: (_) => result.first.page,settings: settings);
        }
      }

    return MaterialPageRoute<void>(builder: (_) => SignIn(),settings: settings);
  }
}

class PageEntity<T> {
  String path;
  Widget page;
  dynamic bloc;

  PageEntity({
    required this.path,
    required this.page,
    required this.bloc,
  });
}
