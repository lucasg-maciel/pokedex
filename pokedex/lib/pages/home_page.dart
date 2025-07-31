import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex/controllers/home_page_controller.dart';
import 'package:pokedex/models/home_page_data.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/pages/capture_pokemons.dart';
import 'package:pokedex/pages/captured_pokemons.dart';
import 'package:pokedex/providers/favorite_pokemons_provider.dart';
import 'package:pokedex/widgets/pokemon_card.dart';
import 'package:pokedex/widgets/pokemon_list_tile.dart';

final homePageControllerProvider = StateNotifierProvider<HomePageController, HomePageData>(
  (ref) {
    return HomePageController(HomePageData.initial());
  },
);

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {

  final ScrollController _pokemonListScrollController = ScrollController();

  late HomePageController _homePageController;
  late HomePageData _homePageData;

  late List<String> _favoritePokemons;

    @override
    void initState() {
    super.initState();
    _pokemonListScrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _pokemonListScrollController.removeListener(_scrollListener);
    _pokemonListScrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_pokemonListScrollController.offset >= _pokemonListScrollController.position.maxScrollExtent && !_pokemonListScrollController.position.outOfRange) {
      _homePageController.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {

    _homePageController = ref.watch(homePageControllerProvider.notifier);
    _homePageData = ref.watch(homePageControllerProvider);
    _favoritePokemons = ref.watch(favoritePokemonsProvider);

    return Scaffold(
      body: _buildUI(
        context,
      ),
    );
  }

  Widget _buildUI(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.02,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _favoritePokemonsList(context),
              SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CapturePokemonPage(
                      pokemonURL: _favoritePokemons[Random().nextInt(_favoritePokemons.length)],
                    ),
                  ));
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text('Capture Favorite Pokemon', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              TextButton(onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CapturedPokemonsPage()
                ));
              }, 
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text('Captured Pokemon', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
                            SizedBox(
                height: 20,
              ),
              _allpokemonList(context),
            ],
          ),
        ),
      ));
  }

  Widget _favoritePokemonsList(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Favorite Pokemons',
            style: TextStyle(fontSize: 28),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_favoritePokemons.isNotEmpty)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.48,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: _favoritePokemons.length,
                      itemBuilder: (context, index) {
                        String pokemonURL = _favoritePokemons[index];
                        return PokemonCard(pokemonURL: pokemonURL);
                      },
                    ),
                  ),
                if (_favoritePokemons.isEmpty)
                  Text('No favorite pokemons yet!'),
              ],
            )
          )
        ],
      ),
    );
    
  }

  Widget _allpokemonList(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('All Pokemons',
            style: TextStyle(fontSize: 28),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView.builder(
              controller: _pokemonListScrollController,
              itemCount: _homePageData.data?.results?.length ?? 0,
              itemBuilder: (context, index) {
                PokemonListResult pokemon = _homePageData.data!.results![index];
                return PokemonListTile(
                  pokemonURL: pokemon.url!,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}