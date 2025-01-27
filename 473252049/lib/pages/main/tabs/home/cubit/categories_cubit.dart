import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../../model/category.dart';
import '../../../../../model/record.dart';
import '../../../../../repositories/categories_repository.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final CategoriesRepository repository;

  CategoriesCubit(this.repository) : super(CategoriesLoadInProcess(null));

  Future<List<CategoryWithLastRecord>> get categoriesWithLastRecords async {
    final categories = await repository.getAll();
    final categoriesWithLastRecord = <CategoryWithLastRecord>[];
    for (var category in categories) {
      categoriesWithLastRecord.add(
        CategoryWithLastRecord(
          category: category,
          lastRecord: await repository.getLastRecord(
            categoryId: category.id,
          ),
        ),
      );
    }
    return categoriesWithLastRecord;
  }

  Future<Category> getById(int categoryId) async {
    return await repository.getById(categoryId);
  }

  void loadCategories() async {
    emit(
      CategoriesLoadSuccess(
        await categoriesWithLastRecords,
      ),
    );
  }

  void add({@required Category category}) async {
    await repository.insert(category);
    emit(
      CategoryAddSuccess(
        await categoriesWithLastRecords,
        category,
      ),
    );
  }

  void addAll({@required List<Category> categories}) async {
    for (var category in categories) {
      await repository.insert(category);
    }
    emit(AllAddSuccess(await categoriesWithLastRecords, categories));
  }

  void update(Category category) async {
    await repository.update(category);
    emit(
      CategoryUpdateSuccess(
        await categoriesWithLastRecords,
        category,
      ),
    );
  }

  void delete({@required int id}) async {
    final deletedCategory = await repository.delete(id);
    emit(
      CategoryDeleteSuccess(
        await categoriesWithLastRecords,
        deletedCategory,
      ),
    );
  }

  void deleteAll() async {
    final categoriesId = (await repository.getAll()).map((e) => e.id);
    for (var id in categoriesId) {
      await repository.delete(id);
    }
    emit(AllDeleteSuccess([]));
  }

  void changePin({@required Category category}) async {
    category.isPinned = !category.isPinned;
    await repository.update(
      category,
    );
    emit(
      CategoryChangePinSuccess(
        await categoriesWithLastRecords,
        category,
      ),
    );
  }

  void unpinAll() async {
    for (var categoryWithLastRecord in state.categories) {
      if (categoryWithLastRecord.category.isPinned) {
        categoryWithLastRecord.category.isPinned = false;
        await repository.update(categoryWithLastRecord.category);
      }
    }
    emit(
      AllUnpinSuccess(
        state.categories,
      ),
    );
  }
}
