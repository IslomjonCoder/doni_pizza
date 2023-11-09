import 'package:doni_pizza/data/models/category_model.dart';
import 'package:doni_pizza/data/repositories/category_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryCubit extends Cubit<List<CategoryModel>> {
  final CategoryRepository categoryRepository;

  CategoryCubit(this.categoryRepository) : super([]) {
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final categories = await categoryRepository.getAllCategories();
      emit(categories);
    } catch (e) {

    }
  }

  Future<void> addCategory(CategoryModel category) async {
    try {
      await categoryRepository.addCategory(category);
      fetchCategories(); // Refresh the list of categories after adding a new one
    } catch (e) {
    }
  }

  Future<void> updateCategory(CategoryModel category) async {
    try {
      await categoryRepository.updateCategory(category);
      fetchCategories(); // Refresh the list of categories after updating one
    } catch (e) {
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    try {
      await categoryRepository.deleteCategory(categoryId);
      fetchCategories(); // Refresh the list of categories after deleting one
    } catch (e) {
    }
  }
}
