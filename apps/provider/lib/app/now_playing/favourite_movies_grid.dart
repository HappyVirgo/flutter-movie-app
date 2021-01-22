import 'package:core/models/app_models/profiles_data.dart';
import 'package:core/models/tmdb/tmdb_movie_basic.dart';
import 'package:core/persistence/data_store.dart';
import 'package:core/ui/movies_grid.dart';
import 'package:core/ui/favourite_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavouritesMovieGrid extends StatelessWidget {
  const FavouritesMovieGrid(
      {Key key, @required this.movies, @required this.controller})
      : super(key: key);
  final List<TMDBMovieBasic> movies;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final dataStore = Provider.of<DataStore>(context);
    final profilesData = Provider.of<ProfilesData>(context);
    return MoviesGrid(
      movies: movies,
      controller: controller,
      favouriteBuilder: (context, movie) {
        final favouriteMovie = dataStore.favouriteMovie(
            profileId: profilesData.selectedId, movie: movie);
        return StreamBuilder<bool>(
          stream: favouriteMovie,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                final isFavourite = snapshot.data;
                return FavouriteButton(
                  isFavourite: isFavourite,
                  onFavouriteChanged: (isFavourite) {
                    if (profilesData?.selectedId != null) {
                      dataStore.setFavouriteMovie(
                        profileId: profilesData.selectedId,
                        movie: movie,
                        isFavourite: isFavourite,
                      );
                    }
                  },
                );
              }
            }
            return Container();
          },
        );
      },
    );
  }
}
