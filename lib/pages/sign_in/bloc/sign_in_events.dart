abstract class SignInEvent{
  const SignInEvent();
}

class UserNameEvent extends SignInEvent{
  final String username;
  const UserNameEvent(this.username);
}

class PasswordEvent extends SignInEvent{
  final String password;
  const PasswordEvent(this.password);
}