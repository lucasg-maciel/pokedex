import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/services/http_service.dart';

final capturedPokemonProvider = FutureProvider<List<String>?>((ref) async {
  HttpService httpService = GetIt.instance.get<HttpService>();

  Response? response = await httpService.get('https://pokedex-api-lmk9.onrender.com/api/v1/pokedex/1b99dda1-757f-4d4f-838b-f160dd00104d');
  if (response != null && response.data != null) {
    if(response.data['status'] != 'success') {
      return null;
    }
    Map<String, dynamic> capturedPokemons = response.data['data'];
    if (response.data['data'] == null || capturedPokemons.isEmpty) {
      return null;
    }
    if (capturedPokemons['pokemon'] != null) {
      List<String> pokemons = List<String>.from(capturedPokemons['pokemon'].map((pokemon) => "https://pokeapi.co/api/v2/pokemon/${pokemon['pokemonID']}/"));
      return pokemons;
    } else {
      return null; 
    }
  }

  return null;
});