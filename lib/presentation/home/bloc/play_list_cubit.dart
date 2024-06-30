import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/song/get_play_list.dart';
import '../../../service_locator.dart';
import 'play_list_state.dart';

class PlayListCubit extends Cubit<PlayListState> {

  PlayListCubit() : super(PlayListLoading());

  Future < void > getPlayList() async {
    var returnedSongs = await sl < GetPlayListUseCase > ().call();
    returnedSongs.fold(
      (l) {
        emit(PlayListLoadFailure());
      },
      (data) {
        emit(
          PlayListLoaded(songs: data)
        );
      }
    );
  }
  
  
}