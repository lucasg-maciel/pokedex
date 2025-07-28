import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/services/http_service.dart';

final capturedPokemonProvider = FutureProvider<List<String>?>((ref) async {
  HttpService httpService = GetIt.instance.get<HttpService>();

  Response? response = await httpService.get('https://pokedex-api-i5r9.onrender.com/api/v1/poke/1b99dda1-757f-4d4f-838b-f160dd00104d');
    print('GET status code: ${response?.statusCode}');
    print('GET response data: ${response?.data}');
    print('GET response type: ${response?.data.runtimeType}');

    if (response?.data != null) {
      if (response!.data is Map) {
        print('GET response is Map with keys: ${response.data.keys.toList()}');

        if (response.data.containsKey('pokemonID')) {
          print('Found pokemonID: ${response.data['pokemonID']}');
        }
        if (response.data.containsKey('pokemonIds')) {
          print('Found pokemonIds: ${response.data['pokemonIds']}');
        }
        if (response.data.containsKey('pokemons')) {
          print('Found pokemons: ${response.data['pokemons']}');
        }
        if (response.data.containsKey('status')) {
          print('Found status: ${response.data['status']}');
        }
      } else if (response.data is List) {
        print('GET response is List: ${response.data}');
      } else {
        print('GET response is: ${response.data}');
      }
    } else {
      print('GET response data is null');
    }
    
    print('===============================');
  if (response != null && response.data != null) {
    List<String> capturedPokemons = List<String>.from(response.data['pokemonID'] ?? []);
    return capturedPokemons;
  }

  return null;
});