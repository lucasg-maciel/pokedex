import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/services/database_service.dart';


final favoritePokemonsProvider = StateNotifierProvider<FavoritePokemonsProvider, List<String>>((ref) {
  return FavoritePokemonsProvider([]);
});

class FavoritePokemonsProvider extends StateNotifier<List<String>> {

  final DatabaseService _databaseService = GetIt.instance.get<DatabaseService>();

  final String FAVORITE_POKEMONS_KEY = 'FAVORITE_POKEMONS_KEY';

  FavoritePokemonsProvider(
    super.state,
  ){
    _setup();
  }

  Future<void> _setup() async {
    List<String>? favoritePokemons = await _databaseService.getList(FAVORITE_POKEMONS_KEY);
    state = favoritePokemons ?? [];
  } 

  void addFavoritePokemon(String url) {
    state = [...state, url];
    _databaseService.saveList(FAVORITE_POKEMONS_KEY, state);
  }

  void removeFavoritePokemon(String url) {
    state = state.where((e) => e != url).toList();
    _databaseService.saveList(FAVORITE_POKEMONS_KEY, state);
  }
}
