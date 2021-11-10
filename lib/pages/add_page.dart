import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/category_selected_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  String category = '';
  int value = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Category',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                FontAwesomeIcons.times,
                color: Colors.grey,
              )),
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      children: <Widget>[
        _categorySelected(),
        _currentValue(),
        _numpad(),
        _submit(),
      ],
    );
  }

  Widget _categorySelected() {
    return Container(
      height: 80.0,
      child: CategorySelectedWidget(
        categories: {
          'Shopping': FontAwesomeIcons.shoppingCart,
          'Alcohol': FontAwesomeIcons.wineBottle,
          'Fast food': FontAwesomeIcons.hamburger,
          'Food': FontAwesomeIcons.utensils,
          'Bills': FontAwesomeIcons.wallet,
        },
        onChangedValue: (newCategory) => category = newCategory,
      ),
    );
  }

  Widget _currentValue() {
    var realValue = value / 100.0;
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 32.0),
        child: Text('\$${realValue.toStringAsFixed(2)}',
            style: TextStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.w500,
                color: Colors.blueAccent)));
  }

  Widget _num(String text, height) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            if (text == '.') {
              /* value = value * 100; */
              value = value;
            } else {
              value = value * 10 + int.parse(text);
            }
          });
        },
        child: Container(
          child: Center(
              child: Text(text,
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 40.0))),
          height: height,
        ));
  }

  Widget _numpad() {
    return Expanded(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        var height = constraints.biggest.height / 4;
        return Table(
          /* border: TableBorder.all(
            color: Colors.grey,
            width: 1.0,
          ), */
          children: [
            TableRow(children: [
              _num('1', height),
              _num('2', height),
              _num('3', height),
            ]),
            TableRow(children: [
              _num('4', height),
              _num('5', height),
              _num('6', height),
            ]),
            TableRow(children: [
              _num('7', height),
              _num('8', height),
              _num('9', height),
            ]),
            TableRow(children: [
              _num('.', height),
              _num('0', height),
              GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      value = value ~/ 10;
                    });
                  },
                  child: Container(
                    child: Center(
                        child: Icon(
                      FontAwesomeIcons.backspace,
                      color: Colors.grey,
                      size: 40.0,
                    )),
                    height: height,
                  )),
            ]),
          ],
        );
      }),
    );
  }

  Widget _submit() {
    return Hero(
        tag: 'add_button',
        child: Container(
            child: Container(
          height: 50.0,
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.purpleAccent),
          child: MaterialButton(
            child: Text(
              'Add expenses',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
            onPressed: () {
              if (value > 0 && category != '') {
                _create();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Select value and category'),
                  duration: const Duration(seconds: 2),
                ));
              }
            },
          ),
        )));
  }

  void _create() {
    FirebaseFirestore.instance.collection('expenses').doc().set({
      'category': category,
      'value': value,
      'month': DateTime.now().month,
      'day': DateTime.now().day,
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Expense saved succesfully'),
      duration: const Duration(seconds: 2),
    ));
    Navigator.of(context).pop();
  }
}
