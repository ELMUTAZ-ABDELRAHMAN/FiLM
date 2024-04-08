import 'dart:async';
import 'dart:convert';
import 'package:flutter_application_1/discover.dart';
import 'package:http/http.dart' as http;
import 'detailview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'genres.dart';

class Stats with ChangeNotifier {
  int _status = 1;
  int get status => _status;

  void increment() {
    _status++;
    notifyListeners();
  }

  void decrement() {
    _status--;
    notifyListeners();
  }
}

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  Future<SharedPreferences> pref = SharedPreferences.getInstance();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => fav()),
      ChangeNotifierProvider(
        create: (_) => Stats(),
      )
    ],
    child: const Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int page = 1;
  List<Results>? li;

  Future<List<Results>?> getDiscover() async {
    if (page == 1) {
      final response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/discover/movie?api_key=5b34660f1d2904d20899ac520dc99d07&include_adult=false&include_video=false&language=en-US&page=1&sort_by=popularity.desc'));
      if (response.statusCode == 200) {
        li = Discover.fromJson(jsonDecode(response.body)).results;

        return li;
      } else {
        throw Exception('Failed to load Discover');
      }
    } else {
      final response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/discover/movie?api_key=5b34660f1d2904d20899ac520dc99d07&include_adult=false&include_video=false&language=en-US&page=$page&sort_by=popularity.desc'));
      if (response.statusCode == 200) {
        li?.addAll(Discover.fromJson(jsonDecode(response.body)).results
            as Iterable<Results>);
        return li;
      } else {
        throw Exception('Failed to load Discover');
      }
    }
  }

  Future<Map> getg() async {
    Map m;
    List<Genres>? genrelist;
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/genre/movie/list?api_key=5b34660f1d2904d20899ac520dc99d07'));
    if (response.statusCode == 200) {
      genrelist = gen.fromJson(jsonDecode(response.body)).genres;
      m = {for (var item in genrelist!) item.id: item.name};
      return m;
    } else {
      throw Exception('Failed to load Discover');
    }
  }

  Future<SharedPreferences> pref = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    getg();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: MaterialApp(
        home: Scaffold(
            extendBody: true,
            bottomNavigationBar: Container(
              height: 56,
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: 20,
                      color: const Color.fromARGB(255, 18, 30, 83)
                          .withOpacity(0.3),
                      offset: const Offset(0, 20)),
                ],
                color: const Color.fromARGB(255, 0, 0, 0),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FavoView(
                                  getmap: getg(),
                                ),
                              ));
                        },
                        icon: const Icon(Icons.favorite_border_rounded),
                      );
                    },
                  ),
                  IconButton(
                    icon: context.watch<Stats>().status == 1
                        ? const Icon(
                            color: Colors.white,
                            Icons.list_alt_rounded,
                            size: 30,
                          )
                        : const Icon(color: Colors.white, Icons.grid_3x3),
                    onPressed: () => setState(() {
                      if (context.read<Stats>().status == 0) {
                        context.read<Stats>().increment();
                      } else {
                        context.read<Stats>().decrement();
                      }
                    }),
                  )
                ],
              ),
            ),
            body: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification.metrics.pixels ==
                      notification.metrics.maxScrollExtent) {
                    setState(() {
                      page++;
                      getDiscover();
                    });
                  }
                  return true;
                },
                child: future(getDiscover(), context.read<Stats>().status, page,
                    getg()))),
      ),
    );
  }
}

Widget future(
    Future<List<Results>?> future, int status, int page, Future<Map> getg) {
  return FutureBuilder(
    future: future,
    builder: (context, snapshot) {
      //

      if (snapshot.hasData) {
        if (status == 0) {
          return ListView.builder(
            addAutomaticKeepAlives: true,
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(
                          ind: index,
                          future: future,
                          getg: getg,
                        ),
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(6.0, 20.0, 6.0, 13.0),
                  child: CachedNetworkImage(
                    imageUrl: ''
                        'https://image.tmdb.org/t/p/original${snapshot.data?[index].posterPath}',
                    placeholder: (context, url) =>
                        const LinearProgressIndicator(),
                  ),
                ),
              );
            },
          );
        } else {
          return GridView.builder(
            addAutomaticKeepAlives: true,
            itemCount: snapshot.data?.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: .7, mainAxisSpacing: 20, crossAxisCount: 2),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(
                          ind: index,
                          future: future,
                          getg: getg,
                        ),
                      ));
                },
                child: CachedNetworkImage(
                  imageUrl: ''
                      'https://image.tmdb.org/t/p/original${snapshot.data?[index].posterPath}',
                  placeholder: (context, url) => const LinearProgressIndicator(
                      color: Color.fromARGB(106, 184, 19, 134)),
                ),
              );
            },
          );
        }
      } else if (snapshot.hasError) {
        return Text('${snapshot.error}');
      }
      return const LinearProgressIndicator(
        minHeight: 6.0,
        color: Colors.blueGrey,
      );
    },
  );
}

class FavoView extends StatelessWidget {
  FavoView({super.key, required this.getmap});
  Future getmap;

  @override
  Widget build(BuildContext context) {
    List? favolist = context.read<fav>().favolist;
    return Scaffold(
      appBar: AppBar(),
      body: Sha(
        getmap: getmap,
        favolist: favolist,
      ),
    );
  }
}

class Sha extends StatefulWidget {
  Sha({super.key, required this.getmap, required this.favolist});
  Future getmap;
  List? favolist;

  @override
  State<Sha> createState() => _ShaState();
}

class _ShaState extends State<Sha> {
  Future<SharedPreferences> pref = SharedPreferences.getInstance();
  late int len = 0;

  checkfavlength() async {
    SharedPreferences preferences = await pref;
    if (preferences.getStringList('key')?.length == null) {
      return len = 0;
    } else {
      len = preferences.getStringList('key')!.length;
      return len;
    }
  }

  Future checkfav() async {
    SharedPreferences preferences = await pref;
    len = preferences.getStringList('key')!.length;

    return preferences.getStringList('key');
  }

  @override
  void initState() {
    super.initState();
    // checkfavlength();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkfav(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return ListView.builder(
          itemCount: len,
          itemBuilder: (context, index) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const CircularProgressIndicator();
              case ConnectionState.done:
                Results fff =
                    Results.fromJson(jsonDecode(snapshot.data[index]));
                return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Scaffold(
                              appBar: AppBar(
                                forceMaterialTransparency: true,
                              ),
                              body: Builder(builder: (context) {
                                return stackk(fff, widget.getmap);
                              }));
                        },
                      ));
                    },
                    child: head(fff));
              default:
            }
            //
            // Results re = context.watch<fav>().favolist![index];
            // String ff = jsonEncode(re.toJson());
            // Results dd = Results.fromJson(jsonDecode(ff));
            //
          },
        );
      },
    );
  }
}
