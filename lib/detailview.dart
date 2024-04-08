import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/discover.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class fav extends ChangeNotifier {
  List<Results>? favolist = List.empty(growable: true);
  savefavo(Results r) {
    if (favolist!.contains(r)) {
    } else {
      favolist?.add(r);
    }
  }
}

class DetailPage extends StatefulWidget {
  Future<List<Results>?> future;
  int ind;
  Future<Map> getg;
  DetailPage({
    super.key,
    required this.future,
    required this.ind,
    required this.getg,
  });
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<Map> getmap;

  @override
  void initState() {
    super.initState();
    getmap = widget.getg;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.future,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          Results re = snapshot.data[widget.ind];
          return Scaffold(
            appBar: AppBar(
              forceMaterialTransparency: true,
            ),
            backgroundColor: const Color.fromARGB(48, 104, 58, 183),
            body: stackk(re, getmap),
          );
        } else {
          return const Center(
            child: Text('no data'),
          );
        }
      },
    );
  }
}

Widget stackk(Results re, Future getmap) {
  return Stack(
    alignment: AlignmentDirectional.center,
    children: [
      ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaY: 50, sigmaX: 50),
        enabled: true,
        child: CachedNetworkImage(
            imageUrl: ''
                'https://image.tmdb.org/t/p/original${re.posterPath}'),
      ),
      ListView(
        children: [
          head(re),
          But(re: re),
          ge(re, getmap),
          overview(re),
        ],
      )
    ],
  );
}

Widget head(Results re) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
    child: Container(
      decoration: ShapeDecoration(
          color: const Color.fromARGB(106, 130, 129, 143),
          shape:
              BeveledRectangleBorder(borderRadius: BorderRadius.circular(4))),
      height: 180,
      child: Row(
        children: [
          CachedNetworkImage(
              imageUrl: ''
                  'https://image.tmdb.org/t/p/original${re.posterPath}'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 10, 0),
              child: Text('${re.title}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  )),
            ),
          )
        ],
      ),
    ),
  );
}

Widget overview(Results re) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
    child: Container(
      decoration: ShapeDecoration(
          color: const Color.fromARGB(106, 130, 129, 143),
          shape:
              BeveledRectangleBorder(borderRadius: BorderRadius.circular(4))),
      child: Padding(
        padding: const EdgeInsets.all(9.0),
        child: Text(
          '${re.overview}',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    ),
  );
}

Widget ge(Results re, Future getmap) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
    child: FutureBuilder(
      future: getmap,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot2) {
        List? d = re.genreIds;
        Map<dynamic, dynamic>? g = snapshot2.data;
        List na = List.empty(growable: true);
        for (var element in d!) {
          g?.forEach((key, value) {
            if (key == element) {
              na.add(value);
            }
          });
        }
        return SizedBox(
          height: 35,
          child: ListView.builder(
            itemCount: na.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 7),
                child: Container(
                  decoration: ShapeDecoration(
                    color: const Color.fromARGB(106, 130, 129, 143),
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Center(
                      child: Text(
                        na[index],
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    ),
  );
}

class But extends StatefulWidget {
  But({super.key, required this.re});
  Results re;

  @override
  State<But> createState() => _ButState();
}

class _ButState extends State<But> {
  Future<SharedPreferences> pref = SharedPreferences.getInstance();

  Future incrementfav(Results r) async {
    SharedPreferences preferences = await pref;
    List<String> g = preferences.getStringList('key') ?? [];
    g.add(jsonEncode(r.toJson()));

    preferences.setStringList('key', g);
  }

  bool b = false;
  favo() {
    if (b == true) {
      return const Icon(
        color: Colors.black,
        Icons.favorite,
        size: 30.0,
      );
    } else if (b == false) {
      return const Icon(
        color: Colors.black,
        Icons.favorite_border_rounded,
        size: 30.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
      child: Container(
        decoration: ShapeDecoration(
            color: const Color.fromARGB(106, 130, 129, 143),
            shape:
                BeveledRectangleBorder(borderRadius: BorderRadius.circular(4))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {
                  if (b == true) {
                    b = false;
                  } else if (b == false) {
                    b = true;
                    context.read<fav>().savefavo(widget.re);
                    incrementfav(widget.re);
                    // context.read<fav>().incrementfav();
                  }
                  setState(() {});
                },
                icon: favo()),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  color: Colors.black,
                  Icons.local_play_sharp,
                  size: 30.0,
                )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  color: Colors.black,
                  Icons.wallpaper_rounded,
                  size: 30.0,
                ))
          ],
        ),
      ),
    );
  }
}
