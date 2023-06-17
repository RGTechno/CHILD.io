import 'package:child_io/color.dart';
import 'package:child_io/widgets/header.dart';
import 'package:flutter/material.dart';

class RanksScreen extends StatefulWidget {
  const RanksScreen({Key? key}) : super(key: key);

  @override
  State<RanksScreen> createState() => _RanksScreenState();
}

class _RanksScreenState extends State<RanksScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  List<String> names = [
    "1",
    "2",
    "3",
    "4",
    "1",
    "2",
    "3",
    "4",
    "1",
    "2",
    "3",
    "4",
    "1",
    "2",
    "3",
    "4",
    "1",
    "2",
    "3",
    "4",
    "1",
    "2",
    "3",
    "4",
    "1",
    "2",
    "3",
    "4",
    "1",
    "2",
    "3",
    "4"
  ];
  List<String> litems = [
    "1",
    "2",
    "3",
    "4",
    "1",
    "2",
    "3",
    "4",
    "1",
    "2",
    "3",
    "4",
    "1",
    "2",
    "3",
    "4",
    "1",
    "2",
    "3",
    "4",
    "1",
    "2",
    "3",
    "4",
    "1",
    "2",
    "3",
    "4",
    "1",
    "2",
    "3",
    "4"
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: secondaryColor,
          pinned: true,
          snap: false,
          floating: false,
          automaticallyImplyLeading: false,
          expandedHeight: mediaQuery.height * 0.35,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(4.0),
            child: Container(
              color: primaryColor,
              height: mediaQuery.height * 0.06,
              child: Container(
                child: Row(
                  children: [
                    SizedBox(width: 35),
                    Text(
                      "Postion",
                      style: TextStyle(
                        color: Colors.grey[200],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 52),
                    Text(
                      "Profile",
                      style: TextStyle(
                          color: Colors.grey[200], fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 60),
                    Text(
                      "Name",
                      style: TextStyle(
                          color: Colors.grey[200], fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 60),
                    Text(
                      "Score",
                      style: TextStyle(
                          color: Colors.grey[200], fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    primaryColor,
                    primaryColor,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 8,
                    ),
                    child: Header(
                      300,
                      mediaQuery.height * 0.05,
                      context: context,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Text(
                      "LEADERBOARD",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Icon(
                    Icons.emoji_events_rounded,
                    color: secondaryColor,
                    size: 70,
                  ),
                ],
              ),
            ),
          ),
          elevation: 9.0,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => buildList(context, index),
            childCount: litems.length,
          ),
        ),
      ],
    );
  }

  Widget buildList(BuildContext txt, int index) {
    final pos = litems[index];
    final name = names[index];

    Widget listItem;

    listItem = Card(
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      shadowColor: Colors.grey[200],
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              pos,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            CircleAvatar(
              foregroundColor: Colors.green,
            ),
            Text(
              name,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Text(
              "Score",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );

    return Stack(
      children: [
        Container(
          color: Colors.grey[200],
          child: listItem,
        ),
      ],
    );
  }
}
