import 'package:bloc/bloc.dart';
import 'package:dating_app/services/swip_service.dart';
import 'package:equatable/equatable.dart';

part 'ad_event.dart';
part 'ad_state.dart';

class AdBloc extends Bloc<AdEvent, AdState> {
  AdBloc() : super(AdInitial()) {
    on<AdCompletedAndSwipResetEvent>((event, emit)async {
      emit(SwipResetLoadingState());
      await SwipeService().resetDailySwipeCount();
      emit(SwipResetedState());
    });
  }
}
