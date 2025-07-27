import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/providers/favorite_pokemons_provider.dart';
import 'package:pokedex/providers/pokemon_data_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemonCard extends ConsumerWidget {
  final String pokemonURL;

  late FavoritePokemonsProvider _favoritePokemonsProvider;

  PokemonCard({super.key, required this.pokemonURL});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _favoritePokemonsProvider = ref.watch(favoritePokemonsProvider.notifier);
    final pokemon = ref.watch(pokemonDataProvider(pokemonURL));
    return pokemon.when(
      data: (data) {
        return _card(context, false, data);
      },
      error: (error, stackTrace) {
        return  Text('Error: $error');
      },
      loading: () {
        return _card(context, true, null);
      },
    );
  }

  Widget _card(BuildContext context, bool isLoading, Pokemon? pokemon) {
    return Skeletonizer(
      enabled: isLoading,
      ignoreContainers: true,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 2.0,
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pokemon?.name?.toUpperCase() ?? 'Pokemon',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text("#${pokemon?.id.toString()}",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
            Expanded(
              child: CircleAvatar(
                backgroundImage: pokemon != null ? NetworkImage(pokemon.sprites!.frontDefault!) : null,
                radius: 50,
              )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('${pokemon?.moves?.length ?? 0} moves',
                  style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    _favoritePokemonsProvider.removeFavoritePokemon(pokemonURL);
                  },
                  child: const Icon(Icons.favorite, color: Colors.red, size: 20),
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
  
}


