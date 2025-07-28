import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/providers/captured_pokemons_provider.dart';

class CapturedPokemonsPage extends ConsumerWidget {
  const CapturedPokemonsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final capturedPokemons = ref.watch(capturedPokemonProvider);

    return capturedPokemons.when(
      data: (data) {
        if (data == null || data.isEmpty) {
          return Scaffold(body: const Center(child: Text('No captured pokemons yet!')));
        }
        return Scaffold(
          body: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final pokemon = data[index];
              return ListTile(
                title: Text(pokemon),
                subtitle: Text('ID: $pokemon'),
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
