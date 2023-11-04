import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryIndexCubit extends Cubit<int> {
  CategoryIndexCubit() : super(-1);

  changeCategory(int index) {
    emit(index);
  }
}
