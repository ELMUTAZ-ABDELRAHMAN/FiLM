import 'Trending.dart';
import 'Discover.dart';
import 'detailview.dart';
import 'http_requests.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//infinte scrolling

class Stats with ChangeNotifier {
  int _status = 0;
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

void main(List<String> args) {
  runApp(MultiProvider(
    providers: [
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
  Future<Trending>? futureTrendin;
  Future<Discover>? futureDiscover;
  int i = 20;
  int page = 1;

  @override
  void initState() {
    super.initState();
    futureTrendin = gettrendingmovies();
    futureDiscover = getDiscover(page);
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
                color: const Color.fromARGB(255, 16, 16, 20),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: context.watch<Stats>().status == 0
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
                      i += 20;
                    });
                  }
                  return true;
                },
                child:
                    future(futureDiscover, context.read<Stats>().status, i))),
      ),
    );
  }
}

Widget future(Future<Discover>? futureTrendin, int status, int i) {
  return FutureBuilder(
    future: futureTrendin,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        if (status == 0) {
          return ListView.builder(
            itemCount: i,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailPage(ind: index, future: futureTrendin),
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(6.0, 20.0, 6.0, 13.0),
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://image.tmdb.org/t/p/original${snapshot.data!.results![index].posterPath}',
                    placeholder: (context, url) =>
                        const LinearProgressIndicator(),
                  ),
                ),
              );
            },
          );
        } else {
          return GridView.builder(
            itemCount: 20,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: .7, mainAxisSpacing: 20, crossAxisCount: 2),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailPage(ind: index, future: futureTrendin),
                      ));
                },
                child: CachedNetworkImage(
                  imageUrl:
                      'https://image.tmdb.org/t/p/original${snapshot.data!.results![index].posterPath}',
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
