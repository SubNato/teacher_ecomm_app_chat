import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_teacher_bloc/pages/sign_in/bloc/sign_in_events.dart';
import 'package:learn_teacher_bloc/pages/sign_in/bloc/signin_states.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState>{
  SignInBloc():super(const SignInState()){
    on<UserNameEvent>(_userNameEvent);

    on<PasswordEvent>(_passwordEvent);
  }

  void _userNameEvent(UserNameEvent event, Emitter<SignInState>emit){
    emit(state.copyWith(username: event.username));
  }

  void _passwordEvent(PasswordEvent event, Emitter<SignInState>emit){
    //print("My Password is ${event.password}");          //So as you would type in either fields (email or password) an event would get triggered. (kind of like a stack, adding one letter at a time.)
    emit(state.copyWith(password: event.password));
  }
}