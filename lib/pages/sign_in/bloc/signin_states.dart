class SignInState {
  final String username;
  final String password;

  const SignInState({this.username = "", this.password = ""});

  SignInState copyWith({    //Optional named parameter. Makes it assigned to any value(the value called, and not both)
    String? username,
    String? password,
  })  {        // The '?' sign makes it optional. So it means option value.
    return SignInState(
      username: username ?? this.username,       //This means IF it is NOT '?' empty use whatever is there, IF it IS empty '?'
      password: password ?? this.password,          //use the other value previously stated in the const method above.
    );
  }

}
