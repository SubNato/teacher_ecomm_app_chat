import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:learn_teacher_bloc/common/routes/names.dart';

import '../../common/apis/user.dart';
import '../../common/entities/user.dart';
import '../../common/values/constants.dart';
import '../../common/widgets/flutter_toast.dart';
import '../../global.dart';
import 'bloc/sign_in_blocs.dart';

class SignInController {
  final BuildContext context;

  SignInController({required this.context});
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> handleSignIn(String type) async {

        final state = context.read<SignInBloc>().state; //To use the bloc "(context.read<>())" that accesses the UI.
        String username = state.username; //Calling the state above allows access to everything in that class. Which is needed!
        String password = state.password;

            LoginRequestEntity loginRequestEntity = LoginRequestEntity();

            loginRequestEntity.username = username;
            loginRequestEntity.password = password;

            await asyncPostAllData(loginRequestEntity);

          }

  Future<void> asyncPostAllData(LoginRequestEntity loginRequestEntity) async {
    EasyLoading.show(
      indicator: CircularProgressIndicator(),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true
    );
    var result = await UserAPI.login(params:loginRequestEntity);
    if(result.code==200){
      try{
        Global.storageService.setString(AppConstants.STORAGE_USER_PROFILE_KEY, jsonEncode(result.data!));     //The '!' means not null.
        print("............. My token is ${result.data!.access_token!}....................");
        //Used for authorization, that's why it is saved.
        Global.storageService.setString(AppConstants.STORAGE_USER_TOKEN_KEY, result.data!.access_token!);
        EasyLoading.dismiss();
        if(context.mounted){
          //Navigator.of(context).pushNamedAndRemoveUntil("/application", (route) => false);
          Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.Message, (Route<dynamic> route) => false);
        }
      }catch(e){
        print("Saving local storage error ${e.toString()}");
      }
    }else{
      EasyLoading.dismiss();
      toastInfo(msg: "An unknown error occurred");
    }
  }

}
