import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/providers/favorite_pokemons_provider.dart';
import 'package:pokedex/providers/pokemon_data_provider.dart';
import 'package:pokedex/services/http_service.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CapturePokemonPage extends ConsumerStatefulWidget {
  const CapturePokemonPage({super.key, required this.pokemonURL});

  final String pokemonURL;

  @override
  ConsumerState<CapturePokemonPage> createState() => _CapturePokemonPageState();
}

class _CapturePokemonPageState extends ConsumerState<CapturePokemonPage> {
    final http = HttpService();

  int countBalls = 3;
  int rng = 0;

  @override
  Widget build(BuildContext context) {
    final pokemon = ref.watch(pokemonDataProvider(widget.pokemonURL));
    return Scaffold(
      appBar: AppBar(
        title: Text('Capture Favorite Pokemon', style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: pokemon.when(
        data: (data) {
          return _captureCard(context, false, data);
        },
        error: (error, stackTrace) {
          return Text('Error: $error');
        },
        loading: () {
          return _captureCard(context, true, null);
        },
      ),
    );
  }
  

  Widget _captureCard(BuildContext context, bool isLoading, Pokemon? pokemon) {
    return Skeletonizer(
      enabled: isLoading,
      ignoreContainers: true,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            CircleAvatar(
              backgroundImage: pokemon != null ? NetworkImage(pokemon.sprites!.frontDefault!) : null,
              radius: 100,
            ),
            SizedBox(height: 20),
            Text(
              pokemon != null ? pokemon.name!.toUpperCase() : 'Loading...',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Drawn number: ${rng.toString()}',
              style: TextStyle(fontSize: 20),
            ),
            if(rng != 0)
            if (rng == 2 || rng == 5 || rng == 8)
              Text(
                'Pokémon captured successfully!',
                style: TextStyle(fontSize: 20, color: Colors.green),
              )
            else
              Text(
                'Try again! Pokémon not captured.',
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
            Spacer(),
            IconButton.filled(
              iconSize: 70,
              style: IconButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: countBalls > 0 ? () async{
                setState(() {
                  countBalls--;
                  rng = Random().nextInt(9) + 1;
                });
                if(rng == 2 || rng == 5 || rng == 8) {
                  await ref.read(favoritePokemonsProvider.notifier).postCapturedPokemon(pokemon!.id.toString());
                  ref.read(favoritePokemonsProvider.notifier).removeFavoritePokemon(widget.pokemonURL);
                  Navigator.of(context).pop();
                }
              } : null,
              icon: Icon(Icons.catching_pokemon, size: 70),
            ),
            SizedBox(height: 15),

            Text(
              'You have $countBalls Pokeballs',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 150),
          ],
        ),
      ),
    );
  }
}