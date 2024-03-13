import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/values/colors.dart';

AppBar buildAppBar(){
  return AppBar(
    bottom: PreferredSize(

      preferredSize: const Size.fromHeight(1.0),
      child: Container(
        color: AppColors.primarySecondaryBackground,
        //height defines the thickness of the line.
        height: 1.0,
      ),
    ),
    title: Center(
      child: Text(
        "Log In",
        style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 16.sp,
            fontWeight: FontWeight.normal ),
      ),
    ),
  );
}

// We need context for accessing Bloc.
Widget buildThirdPartyLogin(BuildContext context){
return Container(
  margin: EdgeInsets.only(top: 40.h, bottom: 20.h,),
 padding: EdgeInsets.only(left: 25.w, right: 25.w),
 child:Row(
   mainAxisAlignment: MainAxisAlignment.spaceAround,
   children: [
     _reusableIcons("google"),
     _reusableIcons("apple"),
     _reusableIcons("facebook")
   ],
 ),
);
}

Widget _reusableIcons(String iconName){         //Underscore lets it be private to its class.
  return GestureDetector(     //In order to make the buttons clickable.
    onTap: (){         //What happens after the button is pressed!

    },
    child: SizedBox(
      width: 40.w,
      height: 40.w,
      child: Image.asset("assets/icons/$iconName.png"),
    ),
  );
}

Widget reusableText(String text){
  return Container(
    margin: EdgeInsets.only(bottom: 5.h,),
        child: Text(
      text,
          style: TextStyle(
            color: Colors.grey.withOpacity(0.5),      //Used to add the level texture to the text.
            fontWeight: FontWeight.normal,
            fontSize: 14.sp
          ),
  ),
  );
}

Widget buildTextField(String hintText, String textType, String iconName,
    void Function(String value)?  func
){
  return Container(
    width: 325.w,
    height: 50.h,
    margin: EdgeInsets.only(bottom: 20.h),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(15.w)),
      border: Border.all(color: AppColors.primaryFourthElementText)
    ),
    child: Row(
     children: [
       Container(
         width: 16.w,
         margin: EdgeInsets.only(left: 17.w),
         height: 16.w,
         child: Image.asset("assets/icons/$iconName.png"),
       ),
       SizedBox(
         width: 270.w,
         height: 50.h,
         child: TextField(
           onChanged: (value)=>func!(value),          //To add a value to the function NAMED 'func' that is not null (!)
           keyboardType: TextInputType.multiline,
           decoration: InputDecoration(
             hintText:hintText ,
             border: const OutlineInputBorder(
               borderSide: BorderSide(          //To fix/edit the borders to let it look great!
                 color: Colors.transparent
               )
             ),
               enabledBorder: const OutlineInputBorder(
                   borderSide: BorderSide(
                       color: Colors.transparent
                   )
               ),
               disabledBorder: const OutlineInputBorder(
                   borderSide: BorderSide(
                       color: Colors.transparent
                   )
               ),
               focusedBorder: const OutlineInputBorder(
                   borderSide: BorderSide(
                       color: Colors.transparent
                   )
               ),
               hintStyle: const TextStyle(
                 color: AppColors.primarySecondaryElementText
               ),

           ),
           style: TextStyle(
             color: AppColors.primaryText  ,
             fontFamily: "Avenir",
             fontWeight: FontWeight.normal,
             fontSize: 14.sp
           ),
           autocorrect: false,
           obscureText: textType == "password"?true:false,
         ),
       )
     ], 
    )
  );
}

Widget forgotPassword(){
  return Container(
    margin: EdgeInsets.only(left: 25.w),
    width: 260.w,
    height: 44.h,
    child: GestureDetector(
      onTap: (){

      },
      child: Text(
        "Forgot Password",
        style: TextStyle(
          color: AppColors.primaryText,
          decoration: TextDecoration.underline,
          decorationColor: AppColors.primaryText,
          fontSize: 12.sp
        ),
      ),
    ),
  );
}

Widget buildLoginAndRegButton(String buttonName, String buttonType, void Function()? func){
  return GestureDetector(
    onTap: func,
    child: Container(
      width: 325.w,
      height: 50.h,
      margin: EdgeInsets.only(left: 25.w, right: 25.w, top: buttonType == "Login"?40.h:20.h),
      decoration: BoxDecoration(
        color: buttonType=="login"?
        AppColors.primaryElement:
        AppColors.primaryBackground,
        borderRadius: BorderRadius.circular(15.w),
        border: Border.all(
          //Check for registration button border color
          color:buttonType=="login"?
          Colors.transparent:
          AppColors.primaryFourthElementText
        ),
        boxShadow: [
          BoxShadow(
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
              color: Colors.grey.withOpacity(0.1)

          )
        ]
      ),
      child: Center(child: Text(
          buttonName,
          style: TextStyle(
          fontSize: 16.sp,
        fontWeight: FontWeight.normal,
        color: buttonType=="login"?
        AppColors.primaryBackground:
         AppColors.primaryText
      ),
      )),
    ),
  );
}