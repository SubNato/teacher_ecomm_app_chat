import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/entities/message.dart';
import '../../../common/entities/msg.dart';
import '../../../common/entities/user.dart';
import '../../../common/routes/names.dart';
import '../../../global.dart';
import 'cubit/message_cubits.dart';

class MessagesController{
  late BuildContext context;
  MessagesController({required this.context});
  final db = FirebaseFirestore.instance;
  UserItem? userProfile = Global.storageService.getUserProfile();
  StreamSubscription<QuerySnapshot<Object?>>? listener1;
  StreamSubscription<QuerySnapshot<Object?>>? listener2;

  void init(){
    _snapShots();
  }

  Future<void> goChat(Message item) async {
    var nav = Navigator.of(context);       //We do this as it is better practice. This is the better way of doing it.
    if(item.doc_id!=null){
      if(listener1 !=null && listener2 !=null){
        await listener1?.cancel();
        await listener2?.cancel();
      }
    }
    nav.pushNamed(AppRoutes.Chat, arguments: {
      "doc_id":item.doc_id,
      "to_token":item.token!,
      "to_avatar":item.avatar!,
      "to_online":item.online!,
    }).then((value) => _snapShots());     //Closing them when not in use and opening them for basic memory optimization.
  }

  void _snapShots(){
    var token = userProfile?.token;
    print('user token $token');

    final toMessageRef = db
        .collection("message")
        .withConverter(
        fromFirestore: Msg.fromFirestore,
        toFirestore: (Msg msg, options) =>msg.toFirestore())
    .where("to_token", isEqualTo:  token);

    final fromMessageRef = db
        .collection("message")
        .withConverter(
        fromFirestore: Msg.fromFirestore,
        toFirestore: (Msg msg, options) =>msg.toFirestore())
        .where("from_token", isEqualTo:  token);

    listener1 = toMessageRef.snapshots().listen((event) async {
      await _asyncLoadMsgData();
    });

    listener2 = fromMessageRef.snapshots().listen((event) async {
      await _asyncLoadMsgData();
    });
  }

  _asyncLoadMsgData() async {
    var msgContext = context.read<MessageCubits>();
    final fromMessageRef = await db
        .collection("message")
        .withConverter(
        fromFirestore: Msg.fromFirestore,
        toFirestore: (Msg msg, options) =>msg.toFirestore())
        .where("from_token", isEqualTo:  userProfile?.token).get();
    print(fromMessageRef.docs.length);

    final toMessageRef = await db
        .collection("message")
        .withConverter(
        fromFirestore: Msg.fromFirestore,
        toFirestore: (Msg msg, options) =>msg.toFirestore())
        .where("to_token", isEqualTo:  userProfile?.token).get();
    print(toMessageRef.docs.length);

    List<Message> messageList = <Message>[];
    if(fromMessageRef.docs.isNotEmpty){
      var message = await _addMessage(fromMessageRef.docs);
      messageList.addAll(message);
    }

    if(toMessageRef.docs.isNotEmpty){
      var message = await _addMessage(toMessageRef.docs);
      messageList.addAll(message);
    }
    //Sorting the messages according to the time. And returning that List
    messageList.sort((a, b){
//Look up/into your Dart code to get a better understanding of Dart! Then you can slowly but surely get better at Dart.
      if(b.last_time==null) return 0;
      if(a.last_time==null) return 0;
//Note, the latest or the newest time is always the biggest time. The latest chat would always be at the top!
      return b.last_time!.compareTo(a.last_time!);

    });
    msgContext.messageChanged(messageList);
    msgContext.loadStatusChanged(false);
  }
//This is where we load everything form the database! to get them stored for usage here on the frontend! Hope this helps!
  Future<List<Message>> _addMessage(List<QueryDocumentSnapshot<Msg>> data) async{
    List<Message> messageList = <Message>[];
    data.forEach((element) {
      //Refers to main document
      var item = element.data();
      Message message = Message();
      message.doc_id = element.id;
      message.last_time = item.last_time;
      message.msg_num = item.msg_num;
      message.last_msg = item.last_msg;

      if(item.from_token == userProfile?.token){
        //Since the token match we are pulling out other guys or teachers
        //Information because you don't need to pull your own information and show on the screen
        message.name = item.to_name;
        message.avatar = item.to_avatar;
        message.online = item.to_online??0;
        message.msg_num = item.to_msg_num??0;
        message.token = item.to_token;
      }else{
        //If he started chatting first, the to token is yours. Cause you didn't chat, he did to you. So you are to. Basically the opposite of above
        message.name = item.from_name;
        message.avatar = item.from_avatar;
        message.online = item.from_online??0;
        message.msg_num = item.from_msg_num??0;
        message.token = item.from_token;
      }
      messageList.add(message);
    });

    return messageList;
  }

}