import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class Xkcd {
  String month;
  int num;
  String link;
  String year;
  String news;
  String safeTitle; // safe_title
  String transcript;
  String alt;
  String img;
  String title;
  String day;

  Xkcd(item) {
    this.month = item['month'];
    this.num = item['num'];
    this.link = item['link'];
    this.year = item['year'];
    this.news = item['news'];
    this.safeTitle = item['safe_title'];
    this.alt = item['alt'];
    this.img = item['img'];
    this.title = item['title'];
    this.day = item['day'];
    this.transcript = item['transcript'];
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter xkcd',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter xkcd'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String url = 'http://xkcd.com/info.0.json';
  Xkcd latestItem;
  Xkcd item;
  bool isLoading = true;
  String title = '';

  @override
  void initState() {
    super.initState();
    _requestItem();
  }

  void _requestItem() {
    setState(() {
      this.isLoading = true;
    });

    http.get(url).then((response) {
      Map decoded = jsonDecode(response.body);
      setState(() {
        this.latestItem = Xkcd(decoded);
        this.item = this.latestItem;
        this.title = item.title;
        this.isLoading = false;
      });
    });
  }

  void _getRandom() {
    Random random = Random();
    final int randomIndex = random.nextInt(this.latestItem.num);
    _getComic(randomIndex.toString());
  }

  void _getPrev() {
    if (this.item.num == 0) {
      return;
    }
    _getComic((this.item.num - 1).toString());
  }

  void _getNext() {
    if (this.item.num >= this.latestItem.num) {
      return;
    }

    _getComic((this.item.num + 1).toString());
  }

  void _getComic(String number) {
    String url = 'http://xkcd.com/$number/info.0.json';
    setState(() {
      this.isLoading = true;
    });

    http.get(url).then((response) {
      Map decoded = jsonDecode(response.body);
      setState(() {
        this.item = Xkcd(decoded);
        this.title = item.title;
        this.isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
          child: Stack(
        children: <Widget>[
          isLoading
              ? Center(
                  child: Text(
                    "Loading...",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 30,
                    ),
                  ),
                )
              : PhotoView(
                  backgroundColor: Colors.white,
                  imageProvider: NetworkImage(item.img),
                ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                child: isLoading
                    ? null
                    : Column(
                        children: <Widget>[
                          Text(
                            '${this.item.num} - ${this.item.title}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${item.day}/${item.month}/${item.year}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Prev'),
                      onPressed: _getPrev,
                    ),
                    RaisedButton(
                      child: Text(
                        'Latest',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: _requestItem,
                      color: Colors.blueAccent,
                    ),
                    RaisedButton(
                      child: Text('Random'),
                      onPressed: _getRandom,
                    ),
                    RaisedButton(
                      child: Text('Next'),
                      onPressed: _getNext,
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      )),
    );
  }
}
