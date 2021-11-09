import 'package:demo/month_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late PageController _controller;
  int currentPage = 9;
  Stream<QuerySnapshot> _query = FirebaseFirestore.instance
      .collection('expenses')
      .where('month', isEqualTo: 10)
      .snapshots();

  @override
  void initState() {
    super.initState();

    /* _query = FirebaseFirestore.instance
        .collection('expenses')
        .where('month', isEqualTo: currentPage + 1)
        .snapshots(); */

    _controller = PageController(
      initialPage: currentPage,
      viewportFraction: 0.33,
    );
  }

  Widget _bottomAction(IconData icon) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon),
      ),
      onTap: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        notchMargin: 8.0,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _bottomAction(FontAwesomeIcons.history),
            _bottomAction(FontAwesomeIcons.chartPie),
            SizedBox(width: 40.0),
            _bottomAction(FontAwesomeIcons.wallet),
            _bottomAction(FontAwesomeIcons.cog),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('/add');
        },
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return SafeArea(
        child: Column(
      children: <Widget>[
        _selector(),
        StreamBuilder<QuerySnapshot>(
            stream: _query,
            builder: (BuildContext context, AsyncSnapshot data) {
              if (data.hasData) {
                return MonthWidget(
                  documents: data.data.docs,
                );
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            })
      ],
    ));
  }

  Widget _pageItem(String name, int position) {
    var _alignment;
    final selected = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.blueGrey,
    );
    final unselected = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.normal,
      color: Colors.blueGrey.withOpacity(0.4),
    );

    if (position == currentPage) {
      _alignment = Alignment.center;
    } else if (position > currentPage) {
      _alignment = Alignment.centerRight;
    } else {
      _alignment = Alignment.centerLeft;
    }

    return Align(
      alignment: _alignment,
      child: Text(
        name,
        style: position == currentPage ? selected : unselected,
      ),
    );
  }

  Widget _selector() {
    return SizedBox.fromSize(
        size: Size.fromHeight(70.0),
        child: PageView(
          onPageChanged: (newPage) {
            setState(() {
              currentPage = newPage;

              _query = FirebaseFirestore.instance
                  .collection('expenses')
                  .where('month', isEqualTo: currentPage + 1)
                  .snapshots();
            });
          },
          controller: _controller,
          children: <Widget>[
            _pageItem('Enero', 0),
            _pageItem('Febrero', 1),
            _pageItem('Marzo', 2),
            _pageItem('Abril', 3),
            _pageItem('Mayo', 4),
            _pageItem('Junio', 5),
            _pageItem('Julio', 6),
            _pageItem('Agosto', 7),
            _pageItem('Septiembre', 8),
            _pageItem('Octubre', 9),
            _pageItem('Noviembre', 10),
            _pageItem('Diciembre', 11),
          ],
        ));
  }
}
