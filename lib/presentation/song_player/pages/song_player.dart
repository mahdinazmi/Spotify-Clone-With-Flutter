import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/common/widgets/appbar/app_bar.dart';
import 'package:spotify/domain/entities/song/song.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_cubit.dart';
import 'package:spotify/presentation/song_player/bloc/song_player_state.dart';

import '../../../common/widgets/favorite_button/favorite_button.dart';
import '../../../core/configs/constants/app_urls.dart';
import '../../../core/configs/theme/app_colors.dart';

class SongPlayerPage extends StatelessWidget {
  final SongEntity songEntity;
  const SongPlayerPage({
    required this.songEntity,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: BasicAppbar(
        title: const Text(
          'Now playing',
          style: TextStyle(
            fontSize: 18
          ),
        ),
        action: IconButton(
          onPressed: (){},
          icon: const Icon(
            Icons.more_vert_rounded
          )
        ),
      ),
      body: BlocProvider(
        create: (_) => SongPlayerCubit()..loadSong(
          '${AppURLs.songFirestorage}${songEntity.artist} - ${songEntity.title}.mp3?${AppURLs.mediaAlt}'
        ),
        child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16
            ),
            child: Builder(
              builder: (context) {
                return Column(
                  children: [
                    _songCover(context),
                    const SizedBox(height: 20,),
                    _songDetail(),
                    const SizedBox(height: 30,),
                    _songPlayer(context)
                  ],
                );
              }
            ),
          ),
      ),
      );
  }

  Widget _songCover(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
             '${AppURLs.coverFirestorage}${songEntity.artist} - ${songEntity.title}.jpg?${AppURLs.mediaAlt}'
          )
        )
      ),
    );
  }

  Widget _songDetail() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              songEntity.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22
              ),
            ),
            const SizedBox(height: 5, ),
              Text(
                songEntity.artist,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14
                ),
              ),
          ],
        ),
          FavoriteButton(
            songEntity: songEntity
          )
      ],
    );
  }

  Widget _songPlayer(BuildContext context) {
    return BlocBuilder<SongPlayerCubit,SongPlayerState>(
      builder: (context, state) {
        if(state is SongPlayerLoading){
          return const CircularProgressIndicator();
        } 
        if(state is SongPlayerLoaded) {
          return Column(
            children: [
              Slider(
                value: context.read<SongPlayerCubit>().songPosition.inSeconds.toDouble(),
                min: 0.0,
                max: context.read<SongPlayerCubit>().songDuration.inSeconds.toDouble() ,
                onChanged: (value){}
             ),
             const SizedBox(height: 20,),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatDuration(
                    context.read<SongPlayerCubit>().songPosition
                  )
                ),

                Text(
                  formatDuration(
                    context.read<SongPlayerCubit>().songDuration
                  )
                )
              ],
             ),
             const SizedBox(height: 20,),

             GestureDetector(
              onTap: (){
                context.read<SongPlayerCubit>().playOrPauseSong();
              },
               child: Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary
                ),
                child: Icon(
                  context.read<SongPlayerCubit>().audioPlayer.playing ? Icons.pause : Icons.play_arrow
                ),
               ),
             )
            ],
          );
        }

        return Container();
      },
    );
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2,'0')}:${seconds.toString().padLeft(2,'0')}';
  }
}