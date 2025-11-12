import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dating_app/models/user_current_model.dart';
import 'package:dating_app/models/user_profile_model.dart';
import 'package:dating_app/services/favorite_service.dart';
import 'package:equatable/equatable.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final service = FavoriteService();
  List<UserProfile> _favorites = [];
  FavoriteBloc() : super(FavoriteInitial()) {
    on<FavoriteActionEvent>((event, emit) {
      emit(FavoriteLoadingState());
      _favorites = List.from(_favorites)
        ..removeWhere((u) => u.id == event.user.id);
      emit(FavoriteLoadedState(favorites: _favorites));
    });

     on<FetchAllFavoritesEvent>((event, emit) async{
      emit(FavoriteLoadingState());
      final List<String>favorites = await service.getFavoritesId();
       _favorites = await service.fetchUsersByIds(favorites);

      log(favorites.toString());
      log("favorites fetched");
      //emit(favorites)
      emit(FavoriteLoadedState(favorites: _favorites));
    });
  }
}
