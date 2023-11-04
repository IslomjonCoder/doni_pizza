abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String phoneNumber;
  final String password;

  LoginEvent({
    required this.phoneNumber,
    required this.password,
  });
}

class GoogleLoginEvent extends AuthEvent {}

class RegisterEvent extends AuthEvent {
  final String name;
  final String phoneNumber;
  final String password;

  RegisterEvent({
    required this.name,
    required this.phoneNumber,
    required this.password,
  });
}
