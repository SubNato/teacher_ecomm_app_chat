import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learn_teacher_bloc/common/routes/routes.dart';
import 'package:learn_teacher_bloc/common/style/theme.dart';
import 'package:learn_teacher_bloc/global.dart';

Future<void> main() async {
  await Global.init();
  runApp(MyApp());

}



class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [...AppPages.Blocer(context)],
        child: ScreenUtilInit(
            designSize: Size(375, 812),
            builder: (context, child) => MaterialApp(
              title: 'ulearn_teacher',
              theme: AppTheme.light,
              navigatorKey: Global.navigatorKey,
              scaffoldMessengerKey: Global.rootScaffoldMessengerKey,
             builder: EasyLoading.init(),
             // builder: Global.MaterialAppBuilder(),
              debugShowCheckedModeBanner: false,
              navigatorObservers: [AppPages.observer],
              initialRoute: AppRoutes.INITIAL,
              onGenerateRoute: AppPages.GenerateRouteSettings,
            ))
    );
  }
}

