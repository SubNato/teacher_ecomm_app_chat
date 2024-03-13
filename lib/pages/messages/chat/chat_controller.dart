import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/entities/msg.dart';
import '../../../common/entities/msgcontent.dart';
import '../../../common/entities/user.dart';
import '../../../common/widgets/flutter_toast.dart';
import '../../../global.dart';
import 'bloc/chat_blocs.dart';
import 'bloc/chat_events.dart';

class ChatController {
  late BuildContext context;

  ChatController({required this.context});

  TextEditingController textEditingController = TextEditingController();
  ScrollController appScrollController = ScrollController();

  //get user profile
  UserItem? userProfile = Global.storageService.getUserProfile();

  //Get database instance
  final db = FirebaseFirestore.instance;
  late var docId;
  late var listener;
  bool isLoadMore = true;

  void init() {
    final data = ModalRoute.of(context)!.settings.arguments as Map;
    //This is the id between 2 users and is unique
    docId = data["doc_id"];
    //Here we want to load all the data from Google FireBase!
    _clearMsgNum(docId);//To clear the message num for the chats
    _chatSnapShots();
  }

  _clearMsgNum(String docId) async {
    var messageRes = await db.collection('message').doc(docId).withConverter(
        fromFirestore: Msg.fromFirestore, toFirestore: (Msg msg, options)=>msg.toFirestore()
    ).get();
    if(messageRes.data()!=null){
      var item = messageRes.data()!;
      int to_msg_num = item.to_msg_num==null?0:item.to_msg_num!;
      int from_msg_num = item.from_msg_num==null?0:item.from_msg_num!;
      if(item.from_token==userProfile?.token){   //Meaning you pulled up or have seen that person's message.
        to_msg_num = 0;
      }else{
        from_msg_num = 0;
      }

      await db.collection("message").doc(docId).update({
        "to_msg_num":to_msg_num,
        "from_msg_num":from_msg_num
      });
    }
  }

  void dispose() {
    textEditingController.dispose();
    appScrollController.dispose();
    _clearMsgNum(docId);
  }

  Future<void> _chatSnapShots() async {
    var chatContext = context;
    chatContext.read<ChatBlocs>().add(const TriggerClearMsgList());
    var messages = await db
        .collection("message")
        .doc(docId)
        .collection("msglist")
        .withConverter(
            fromFirestore: Msgcontent.fromFirestore,
            toFirestore: (Msgcontent msg, options) => msg.toFirestore())
        .orderBy("addtime", descending: true)
        .limit(15);     //Too low of a number may not work, so about 15 is good. Don't do too much as well or you may have issues.
    //not printable
    //print(jsonEncode(messages));
//This adds new data because old data is removed. But if you go into chat again after existing you see the previous length. But type new data in the new instance of chat and the old data is removed.
    //The below method gets called when you come to this chat page or open it.
    //Or when you send messages from here!
    listener = messages.snapshots().listen((event) {
      //Snapshots is very important! It helps you to get live data!
      List<Msgcontent> tempMsgList = <Msgcontent>[];
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            print('added ---: ${change.doc.data()}');
            if (change.doc.data() != null) {
              tempMsgList.add(change.doc.data()!);
              print('added');
            }
            break;
          case DocumentChangeType.modified:
            // TODO: Handle this case.
            break;
          case DocumentChangeType.removed:
            // TODO: Handle this case.
            break;
        }
      }
      //The zero index contains the last message.
      if (kDebugMode) {
        print('The length of the chat is ${tempMsgList[0].content}');
      }
      //The bottom message comes up to the top
      for (var element in tempMsgList.reversed) {
        if (kDebugMode) {
          print('${element.content}');
        }
        //The last message will stay at the top of the UI. Message that is. Because we reversed the input.
        //Also the state class holds our messages temporarily. Not the list above. it retrieves and stores it in the state object. Keep note love
        chatContext.read<ChatBlocs>().add(TriggerMsgContentList(element));
      }
    }, onError: (error) => print('Listen failed $error'));
    //Offset starts from zero. Its basically how many pixels you have scrolled from  the top. Basically really
    //maxScrollExtent starts from 0 until you start scrolling.

    appScrollController.addListener(() {
      //Offset starts as you scroll
      //Offset tells you how much you scrolled
      print('-------${appScrollController.offset}--------');     //This has to be in here for you to see the offset change.
      if ((appScrollController.offset + 10) >
          (appScrollController.position.maxScrollExtent)) {     //maxScrollExtent lists the pixel value of the items that are not on the screen.
        if (isLoadMore) {
          chatContext.read<ChatBlocs>().add(const TriggerLoadMsgData(true));
          //Trigger loading icon if you scroll up beyond a certain point (Maybe if there's no more messages or you're at the top of the screen)

          //set isLoadMore to false. It's original value is true.
          isLoadMore = false;
          print('loading......');

          //Load server data
          _asyncLoadMoreData();
          //Trigger loading icon off. Because we triggered it as on above, so you have to turn it off.
          chatContext.read<ChatBlocs>().add(const TriggerLoadMsgData(false));
        }
      }
    });
  }

  Future<void> _asyncLoadMoreData() async {
    var state = context.read<ChatBlocs>().state;
    var moreMessages = await db
        .collection("message")
        .doc(docId)
        .collection("msglist")
        .withConverter(
            fromFirestore: Msgcontent.fromFirestore,
            toFirestore: (Msgcontent msg, options) => msg.toFirestore())
        .orderBy("addtime", descending: true)
        .where("addtime", isLessThan: state.msgcontentList.last.addtime)     //Here, isLessThan returns messages that are before the current or the date chosen. For example Today 20...... Get me all the messages less than (or older than) the 18th.....
        .limit(10)     //Limits the messages that you are retrieving to the last 10(Or whatever value you put in there) amount of messages from the server or database(in this case FireBase).
        .get();

    if(moreMessages.docs.isNotEmpty){
      moreMessages.docs.forEach((element) {
        //element.data(), refers to a document in msglist
        var data = element.data();
        context.read<ChatBlocs>().add(TriggerAddMsgContent(data));
      });
//Basically forces a call back of this function. Also lets it be faster for calling whats inside it.
      SchedulerBinding.instance.addPostFrameCallback((_) {
        isLoadMore = true;
      });

    }
  }

//Between 2 people only 1 message, with a sub document that contains their chat! When you converse with a different person, another main document is formed that contains another sub-document that contains there document.
  //So one document with a token as identifier for each user. Another document per YOU talking to ANOTHER USER. So each DOCUMENT IS FOR A USER, then that SPECIFIC DOCUMENT HAS A SUBFOLDER that contains what is happening in that chat.
  sendMessage() async {
    if (textEditingController.text.isEmpty) {
      toastInfo(msg: "You cannot send an empty message");
    } else {
      print(
          '----- My sent messages: ${textEditingController.text.toString()}-----');
      String sendContent = textEditingController.text.trim();
      textEditingController
          .clear(); //Once you send the message, it clears the text field. Very important as well.
      //Create a message object
      final content = Msgcontent(
          token: userProfile?.token,
          content: sendContent,
          type: "text",
          addtime: Timestamp.now());

      await db
          .collection("message")
          .doc(docId)
          .collection("msglist")
          .withConverter(
              fromFirestore: Msgcontent.fromFirestore,
              toFirestore: (Msgcontent msg, options) => msg.toFirestore())
          .add(content)
          .then((DocumentReference doc) {
        print('-- After adding ${doc.id}-----');
      });
      //Updating
      var messageRes = await db
          .collection("message")
          .doc(docId)
          .withConverter(
              fromFirestore: Msg.fromFirestore,
              toFirestore: (Msg msg, options) => msg.toFirestore())
          .get();

      if (messageRes.data() != null) {
        var item = messageRes.data()!;

        int to_msg_num = item.to_msg_num == null ? 0 : item.to_msg_num!;
        int from_msg_num = item.from_msg_num == null ? 0 : item.from_msg_num!;
        if (item.from_token == userProfile?.token) {
          //Sender message count. Increases message number, telling if you have ever sent a message or not.
          from_msg_num = from_msg_num + 1;
        } else {
          //If the other persons sends a message, That other person's message count increases by one. Represents the amount fo messages sent per person. Sendee or sender.
          to_msg_num = to_msg_num + 1;
        }

        await db.collection("message").doc(docId).update({
          "to_msg_num": to_msg_num,
          "from_msg_num": from_msg_num,
          "last_time": Timestamp.now(),
          "last_msg": sendContent
        });
      }
    }
  }
}
