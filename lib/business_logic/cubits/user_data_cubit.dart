import 'package:flutter_bloc/flutter_bloc.dart';

class UserDataCubit extends Cubit<UserDataState> {
  UserDataCubit() : super(UserDataState());

  void updateName(String name) {
    state.copyWith(name: name);
  }

  void updatePhoneNumber(String phoneNumber) {
    state.copyWith(phoneNumber: phoneNumber);
  }
  clear(){
    emit(UserDataState());
  }
}

class UserDataState {
  String name;
  String phoneNumber;

  UserDataState({this.name = '', this.phoneNumber = ''});

  @override
  String toString() {
    return 'UserDataState{name: $name, phoneNumber: $phoneNumber}';
  }

  factory UserDataState.fromJson(Map<String, dynamic> json) {
    return UserDataState(
      name: json['name'],
      phoneNumber: json['phoneNumber'],
    );
  }

  void copyWith({String? name, String? phoneNumber}) {
    this.name = name ?? this.name;
    this.phoneNumber = phoneNumber ?? this.phoneNumber;
  }

  Map<String, dynamic> toJson(Map<String, dynamic> data) {
    return {
      'name': data['name'],
      'phoneNumber': data['phoneNumber'],
    };
  }

  UserDataState.name({this.name = '', this.phoneNumber = ''});
}
