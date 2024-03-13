import 'package:equatable/equatable.dart';

import '../../../../common/entities/msgcontent.dart';


class ChatStates extends Equatable {
  const ChatStates({
    this.to_token="",
    this.to_name="",
    this.to_avatar="",
    this.to_online="",
    this.is_loading = false,
    this.more_status = false,
    this.msgcontentList = const <Msgcontent>[],
  });

  final String to_token;
  final String to_name;
  final String to_avatar;
  final String to_online;
  final bool is_loading;
  final bool more_status;
  final List<Msgcontent> msgcontentList;


  ChatStates copyWith({
    String? to_token,
    String? to_name,
    String? to_avatar,
    String? to_online,
    bool? is_loading,
    bool? more_status,
    List<Msgcontent>? msgcontentList,
  }) {
    return ChatStates(
      to_token: to_token ?? this.to_token,
      to_name: to_name ?? this.to_name,
      to_avatar: to_avatar ?? this.to_avatar,
      to_online: to_online ?? this.to_online,

      is_loading: is_loading ?? this.is_loading,
      more_status: more_status ?? this.more_status,
      msgcontentList: msgcontentList ?? this.msgcontentList,
    );
  }


  @override
  List<Object> get props => [to_token,to_name,to_avatar,to_online,msgcontentList,is_loading,more_status];
}