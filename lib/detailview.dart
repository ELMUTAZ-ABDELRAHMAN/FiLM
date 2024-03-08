import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  Future<dynamic>? future;
  int ind;
  DetailPage({super.key, this.future, required this.ind});
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
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

  bool b = false;
  int i = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.future,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              forceMaterialTransparency: true,
            ),
            backgroundColor: Colors.deepPurple,
            body: Stack(alignment: AlignmentDirectional.topCenter, children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaY: 50, sigmaX: 50),
                enabled: true,
                child: CachedNetworkImage(
                    imageUrl: ''
                        'https://image.tmdb.org/t/p/original${snapshot.data.results[widget.ind].posterPath}'),
              ),
              ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: Container(
                      decoration: ShapeDecoration(
                          color: const Color.fromARGB(106, 130, 129, 143),
                          shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(4))),
                      height: 180,
                      child: Row(
                        children: [
                          CachedNetworkImage(
                              imageUrl: ''
                                  'https://image.tmdb.org/t/p/original${snapshot.data.results[widget.ind].posterPath}'),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(30, 0, 10, 0),
                              child:
                                  Text(snapshot.data.results[widget.ind].title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      )),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: Container(
                      decoration: ShapeDecoration(
                          color: const Color.fromARGB(106, 130, 129, 143),
                          shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(4))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              onPressed: () {
                                if (b == true) {
                                  b = false;
                                } else if (b == false) {
                                  b = true;
                                }
                                setState(() {});
                              },
                              icon: favo()),
                          IconButton(
                              onPressed: () => i = 1,
                              icon: const Icon(
                                color: Colors.black,
                                Icons.local_play_sharp,
                                size: 30.0,
                              )),
                          IconButton(
                              onPressed: () => i = 1,
                              icon: const Icon(
                                color: Colors.black,
                                Icons.wallpaper_rounded,
                                size: 30.0,
                              ))
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: Container(
                      decoration: ShapeDecoration(
                          color: const Color.fromARGB(106, 130, 129, 143),
                          shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(4))),
                      child: Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Text(
                          snapshot.data.results[widget.ind].overview,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ]),
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
