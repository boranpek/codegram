import 'package:codegram/data/repositories/story_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../generic_state/generic_state.dart';

class StoryCubit extends Cubit<GenericState> {
  final StoryRepository _storyRepository;
  StoryCubit(this._storyRepository) : super(GenericInitial());

  Future<void> getStories() async {
    try {
      emit(GenericLoading());
      final response = await _storyRepository.getStories();
      emit(GenericCompleted(response));
    } on NetworkError catch (e) {
      emit(GenericError(e.message, e.statusCode));
    }
  }
}
