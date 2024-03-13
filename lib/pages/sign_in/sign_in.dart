import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learn_teacher_bloc/pages/sign_in/sign_in_controller.dart';
import 'package:learn_teacher_bloc/pages/sign_in/widgets/sign_in_widget.dart';

import '../../common/widgets/base_text_widget.dart' as reuse;
import 'bloc/sign_in_blocs.dart';
import 'bloc/sign_in_events.dart';
import 'bloc/signin_states.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(builder: (context, state) {
      return Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: reuse.buildAppBar("Log In"),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 70.h,),
                  Center(
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: reuse.reusableText("Use your Username and Password to login", fontSize: 13.sp)),),
                  Container(
                    margin: EdgeInsets.only(top: 36.h),
                    padding: EdgeInsets.only(left: 25.w, right: 25.w),
                    child: Column(
                      //To get the words on the screen! In and above the text box.
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        reuse.reusableText("Teacher"),
                        SizedBox(
                          height: 5.h,
                        ),
                        buildTextField(
                            "Enter your name", "name", "user",
                            (value) {
                          context.read<SignInBloc>().add(UserNameEvent(value));
                        }),
                        reuse.reusableText("Password"),
                        SizedBox(
                          height: 5.h,
                        ),
                        buildTextField(
                            "Enter your password", "password", "lock", (value) {
                          context
                              .read<SignInBloc>()
                              .add(PasswordEvent(value)); //The states get saved
                        })
                      ],
                    ),
                  ),
                  forgotPassword(/*context:context*/),
                  SizedBox(height: 70.h,),
                  buildLoginAndRegButton("Log In", "login", () {
                    SignInController(context:context).handleSignIn("email");
                  }),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
