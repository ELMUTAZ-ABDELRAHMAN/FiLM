import 'dart:convert';
import 'package:http/http.dart' as http;
import 'trending.dart';

Future<Trending> gettrendingmovies() async {
  final response = await http.get(Uri.parse(
      'https://api.themoviedb.org/3/trending/movie/day?api_key=5b34660f1d2904d20899ac520dc99d07'));
  if (response.statusCode == 200) {
    return Trending.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load trending');
  }
}
