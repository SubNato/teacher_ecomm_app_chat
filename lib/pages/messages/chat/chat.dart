import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learn_teacher_bloc/pages/messages/chat/widgets/chat_widgets.dart';

import '../../../common/values/colors.dart';
import '../../../common/widgets/base_text_widget.dart';
import '../../../common/widgets/text_field.dart';
import 'bloc/chat_blocs.dart';
import 'bloc/chat_events.dart';
import 'bloc/chat_states.dart';
import 'chat_controller.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late ChatController _chatController;

  @override
  void didChangeDependencies() {
    _chatController = ChatController(context: context);
    _chatController.init();

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _chatController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: BlocBuilder<ChatBlocs, ChatStates>(builder: (context, state) {
        return SafeArea(
          child: Scaffold(
              backgroundColor: Colors.white,
              appBar: buildAppBar("Chat"),
              body: Stack(
                //To make the text area overlap with the entire page (so that it stays there)
                alignment: Alignment.bottomCenter,
                children: [
                  //Widget for showing messages.
                  GestureDetector(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 80.h),
                      child: CustomScrollView(
                        //Default behavior is showing the zero index first.
                        //We can change it with the below setup. It reverses the whole list and out it at the bottom.
                        controller: _chatController.appScrollController,
                        shrinkWrap: true,
                        reverse: true,

                        slivers: [
                          SliverPadding(
                            padding: EdgeInsets.symmetric(horizontal: 25.w),
                            sliver: SliverList(
                              delegate:
                              SliverChildBuilderDelegate((context, index) {
                                var item = state.msgcontentList[index];
                                if(_chatController.userProfile?.token == item.token){
                                  return chatRightWidget(item);
                                }
                                return chatLeftWidget(item);
                              }, childCount: state.msgcontentList.length),
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      FocusManager.instance.primaryFocus
                          ?.unfocus(); //Allows you to be able to click anywhere on your screen.
                    },
                  ),

                  //Text field and send buttons.
                  Positioned(
                    bottom: 0.h,
                    child: Container(
                      color: AppColors.primaryBackground,
                      width: 360.w,
                      constraints: BoxConstraints(
                        //To make the text box to grow as you type in it. It is really mainly just a container.
                          maxHeight: 170.h,
                          minHeight: 70.h),
                      padding: EdgeInsets.only(
                          left: 20.w, right: 20.w, bottom: 5.h, top: 10.h),
                      child: Row(
                        //Space between the text box and the send button
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Text field plus icon button inside the row
                          Container(
                            width: 270.w,
                            constraints: BoxConstraints(
                              //To make the text box to grow as you type in it. It is really mainly just a container.
                                maxHeight: 170.h,
                                minHeight: 50.h),
                            decoration: BoxDecoration(
                                color: AppColors.primaryBackground,
                                border: Border.all(
                                    color: AppColors.primaryFourthElementText),
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              children: [
                                //This is for the text box
                                Container(
                                  constraints: BoxConstraints(
                                    //To make the text box to grow as you type in it. It is really mainly just a container.
                                      maxHeight: 150.h,
                                      minHeight: 30.h),
                                  padding: EdgeInsets.only(left: 5.w),
                                  width: 220.w,
                                  child: appTextField(
                                      "Message...", "none", (value) {},
                                      maxLines: null,
                                      controller:
                                      _chatController.textEditingController),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    //Toggle between files
                                    context.read<ChatBlocs>().add(
                                        TriggerMoreStatus(
                                            state.more_status ? false : true));
                                  },
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    width: 40.w,
                                    height: 40.h,
                                    child: Image.asset("assets/icons/05.png"),
                                  ),
                                )
                              ],
                            ),
                          ),
                          //Send button
                          GestureDetector(
                            onTap: () {
                              _chatController.sendMessage();
                            },
                            child: Container(
                              width: 40.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                  color: AppColors.primaryElement,
                                  borderRadius: BorderRadius.circular(40.w),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 2,
                                        offset: Offset(1, 1))
                                  ]),
                              child: Image.asset("assets/icons/send2.png"),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  state.more_status
                      ? Positioned(
                      right: 82.w,
                      bottom: 70.h,
                      height: 100.h,
                      width: 40.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          chatFileButtons("assets/icons/file.png"),
                          chatFileButtons("assets/icons/photo.png")
                        ],
                      ))
                      : Container()
                ],
              )),
        );
      }),
    );
  }
}
