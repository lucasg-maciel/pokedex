import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/providers/captured_pokemons_provider.dart';
import 'package:pokedex/providers/favorite_pokemons_provider.dart';
import 'package:pokedex/providers/pokemon_data_provider.dart';

class CapturedPokemonsPage extends ConsumerWidget {
  const CapturedPokemonsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final capturedPokemons = ref.watch(capturedPokemonProvider);
    return capturedPokemons.when(
      data: (data) {
        if (data == null || data.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Captured Pokemons')),
            body: const Center(child: Text('No captured pokemons yet!')),
          );
        }
        return Scaffold(
          appBar: AppBar(title: const Text('Captured Pokemons')),
          body: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              String pokemon = data[index];
              final pokemonData = ref.watch(pokemonDataProvider(pokemon));
              return pokemonData.when(
                data: (pokemon) {
                  print('Pokemon Data: ${pokemon?.name}');
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    elevation: 5,
                    color: Colors.grey[300],
                    child: ListTile(
                      title: Text(pokemon?.name?.toUpperCase() ?? 'Unknown Pokemon', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                      leading: CircleAvatar(
                        backgroundImage: pokemon?.sprites?.frontDefault != null ? NetworkImage(pokemon!.sprites!.frontDefault!) : null,
                        radius: 35,
                      ),
                      trailing: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Release', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                        onPressed: () {
                         ref.read(favoritePokemonsProvider.notifier).deleteCapturedPokemon(pokemon?.id ?? 0);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${pokemon?.name} released!'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                      
                    ),
                  );
                },
                error: (error, stack) {
                  return ListTile(title: Text('Error loading pokemon data'));
                },
                loading: () {
                  return const ListTile(title: Text('Loading...'));
                },
              );
            },
          ),
        );
      },
      error: (error, stack) {
        return  Scaffold(body: Center(child: Text('Error: $error')));
      },
      loading: () {
        return Scaffold(body: Center(child: const CircularProgressIndicator()));
      },
    );
  }
}
