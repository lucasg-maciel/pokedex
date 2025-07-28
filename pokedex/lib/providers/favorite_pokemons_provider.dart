import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/providers/captured_pokemons_provider.dart';
import 'package:pokedex/services/database_service.dart';
import 'package:pokedex/services/http_service.dart';


final favoritePokemonsProvider = StateNotifierProvider<FavoritePokemonsProvider, List<String>>((ref) {
  return FavoritePokemonsProvider([], ref);
});

class FavoritePokemonsProvider extends StateNotifier<List<String>> {

  final DatabaseService _databaseService = GetIt.instance.get<DatabaseService>();
  final HttpService _httpService = GetIt.instance.get<HttpService>();
  final Ref _ref;

  final String FAVORITE_POKEMONS_KEY = 'FAVORITE_POKEMONS_KEY';

  FavoritePokemonsProvider(
    super.state,
    this._ref,
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

Future<void> postCapturedPokemon(String id) async {
  try {
    
    final requestData = {
      'userID': '1b99dda1-757f-4d4f-838b-f160dd00104d',
      'pokemonID': id
    };

    
    final response = await _httpService.post('https://pokedex-api-i5r9.onrender.com/api/v1/pokedex', 
      data: requestData
    );

    _ref.invalidate(capturedPokemonProvider);

  } catch (e) {
    print('Error capturing pokemon: $e');
  }
}

  void removeFavoritePokemon(String url) {
    state = state.where((e) => e != url).toList();
    _databaseService.saveList(FAVORITE_POKEMONS_KEY, state);
  }
}
