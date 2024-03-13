import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/entities/message.dart';
import 'message_states.dart';


class MessageCubits extends Cubit<MessageStates>{
  MessageCubits():super(const MessageStates());

  //during message load
  void loadStatusChanged(bool loadStatus){
    emit(state.copyWith(loadStatus: loadStatus));
  }

  void messageChanged(List<Message> message){
    emit(state.copyWith(message: message));
  }
}