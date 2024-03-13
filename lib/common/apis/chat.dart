import 'dart:io';
import 'package:dio/dio.dart';
import 'package:learn_teacher_bloc/common/entities/entities.dart';

import '../utils/http.dart';

class ChatAPI {

  static Future<BaseResponseEntity> bind_fcmtoken(
      {BindFcmTokenRequestEntity? params}
      ) async {
    var response = await HttpUtil().post(
      'teacher/bind_fcmtoken',
      queryParameters: params?.toJson(),
    );
    return BaseResponseEntity.fromJson(response);
  }

  static Future<BaseResponseEntity> call_notifications(
      {CallRequestEntity? params}
      ) async {
    var response = await HttpUtil().post(
      'teacher/send_notice',
      queryParameters: params?.toJson(),
    );
    return BaseResponseEntity.fromJson(response);
  }






}

