import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat_events.dart';
import 'chat_states.dart';

class ChatBlocs extends Bloc<ChatEvents, ChatStates>{
  ChatBlocs():super(ChatStates()){
    on<TriggerMsgContentList>(_triggerMsgContentList);
    on<TriggerAddMsgContent>(_triggerAddMsgContent);
    on<TriggerMoreStatus>(_triggerMoreStatus);
    on<TriggerClearMsgList>(_triggerClearMsgList);
    on<TriggerLoadMsgData>(_triggerLoadMsgData);
  }

  void _triggerMsgContentList(TriggerMsgContentList event, Emitter<ChatStates> emit){
    //Get the total messages
    var res = state.msgcontentList.toList(); //Very important to change to a list, or it may not work. Makes it iterable
    //Below is the single message
    res.insert(0, event.msgContentList);     //0 Because we put it (or insert new messages) at the top of the list always. '.add' would put it at the last or bottom of the list that we don't want. So here, insert is better to put it or to place the latest message at the top!
    emit(state.copyWith(msgcontentList: res));
  }

  void _triggerAddMsgContent(TriggerAddMsgContent event, Emitter<ChatStates> emit){
  var res = state.msgcontentList.toList();
  res.add(event.msgContent);
  emit(state.copyWith(msgcontentList: res));
  }

  void _triggerMoreStatus(TriggerMoreStatus event, Emitter<ChatStates> emit){
    emit(state.copyWith(more_status: event.moreStatus));
  }

  //We need to trigger this to null or empty the list otherwise we will have duplicate messages.
  void _triggerClearMsgList(TriggerClearMsgList event, Emitter<ChatStates> emit){
    emit(state.copyWith(msgcontentList: []));
  }

  void _triggerLoadMsgData(TriggerLoadMsgData event, Emitter<ChatStates> emit){
    emit(state.copyWith(is_loading: event.isLoading));
  }

}