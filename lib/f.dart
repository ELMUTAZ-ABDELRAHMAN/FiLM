import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(const InfiniteScrollPagination());
}

class InfiniteScrollPagination extends StatefulWidget {
  const InfiniteScrollPagination({super.key});

  // const InfiniteScrollPagination({super.key});

  @override
  _InfiniteScrollPaginationState createState() =>
      _InfiniteScrollPaginationState();
}

class _InfiniteScrollPaginationState extends State<InfiniteScrollPagination> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: MaterialApp(
        home: Scaffold(
          body: DefaultTabController(
            length: 1,
            child: NestedScrollView(
              headerSliverBuilder: (context, value) {
                return [
                  const SliverAppBar(
                    pinned: true,
                    toolbarHeight: 0,
                    bottom: TabBar(
                      tabs: [
                        Tab(icon: Icon(Icons.call), text: "1"),
                      ],
                    ),
                  ),
                ];
              },
              body: const TabBarView(
                children: [MyListWidget(), Text('2'), Text('data')],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyListWidget extends StatefulWidget {
  // const MyListWidget({Key? key}) : super(key: key);
  const MyListWidget({super.key});

  @override
  State<MyListWidget> createState() => _MyListWidgetState();
}

class _MyListWidgetState extends State<MyListWidget> {
  int count = 15;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          // here you update your data or load your data from network
          setState(() {
            count += 10;
          });
        }
        return true;
      },
      // if you used network it would good to use the stream or future builder
      child: Container(
        child: getDataList(count),
      ),
    );
  }
}

getDataList(listOfData) {
  return ListView.separated(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text("index $index"),
        );
      },
      separatorBuilder: (context, index) => const Divider(
            thickness: 2,
            color: Colors.grey,
          ),
      itemCount: listOfData);
}
