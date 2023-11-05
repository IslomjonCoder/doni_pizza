import 'dart:io';

import 'package:doni_pizza/data/models/promotion_model.dart';
import 'package:doni_pizza/data/repositories/promotion_repo.dart';
import 'package:doni_pizza/utils/helpers/firebase_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'promotion_state.dart';

part 'promotion_event.dart';

class PromotionBloc extends Bloc<PromotionEvent, PromotionState> {
  final PromotionRepository promotionRepository;

  PromotionBloc(this.promotionRepository) : super(PromotionInitial()) {
    on<AddPromotion>(_addPromotion);
    on<GetAllPromotions>(_getAllPromotions);
    on<UpdatePromotion>(_updatePromotion);
    on<DeletePromotion>(_deletePromotion);
  }

  _addPromotion(AddPromotion event, Emitter<PromotionState> emit) async {
    emit(PromotionLoading());
    try {
      final url = await TFirebaseHelper.uploadImage(
          event.image, 'images/promotions/${event.image.uri.pathSegments.last}');
      await promotionRepository.updatePromotion(event.promotion.copyWith(imageUrl: url));
      emit(PromotionLoaded(await promotionRepository.getAllPromotions()));
    } catch (e) {
      emit(PromotionError('Failed to add promotion: $e'));
    }
  }

  _getAllPromotions(GetAllPromotions event, Emitter<PromotionState> emit) async {
    emit(PromotionLoading());
    try {
      emit(PromotionLoaded(await promotionRepository.getAllPromotions()));
    } catch (e) {
      emit(PromotionError('Failed to fetch promotions: $e'));
    }
  }

  _updatePromotion(UpdatePromotion event, Emitter<PromotionState> emit) async {
    emit(PromotionLoading());
    try {
      final url = await TFirebaseHelper.uploadImage(
          event.image, 'images/promotions/${event.image.uri.pathSegments.last}');
      await promotionRepository.updatePromotion(event.promotion.copyWith(imageUrl: url));
      emit(PromotionLoaded(await promotionRepository.getAllPromotions()));
    } catch (e) {
      emit(PromotionError('Failed to update promotion: $e'));
    }
  }

  _deletePromotion(DeletePromotion event, Emitter<PromotionState> emit) async {
    emit(PromotionLoading());
    try {
      await promotionRepository.deletePromotion(event.promotionId);
      emit(PromotionLoaded(await promotionRepository.getAllPromotions()));
    } catch (e) {
      emit(PromotionError('Failed to delete promotion: $e'));
    }
  }
}
