import 'package:flutter/material.dart';

class CategorySelectedWidget extends StatefulWidget {
  final Map<String, IconData> categories;
  final Function(String) onChangedValue;

  const CategorySelectedWidget(
      {Key? key, required this.categories, required this.onChangedValue})
      : super(key: key);

  @override
  _CategorySelectedWidgetState createState() => _CategorySelectedWidgetState();
}

class CategoryWidget extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool selected;

  const CategoryWidget(
      {Key? key,
      required this.name,
      required this.icon,
      required this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 5.0),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  border: Border.all(
                    color: selected ? Colors.blueAccent : Colors.grey,
                    width: selected ? 3.0 : 1.0,
                  )),
              child: Icon(icon,
                  color: selected ? Colors.blueAccent : Colors.blueGrey),
            ),
            Text(
              name,
              style: TextStyle(
                color: selected ? Colors.blueAccent : Colors.blueGrey,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ));
  }
}

class _CategorySelectedWidgetState extends State<CategorySelectedWidget> {
  String currentItem = '';
  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];

    widget.categories.forEach((name, icon) {
      widgets.add(GestureDetector(
          onTap: () {
            setState(() {
              currentItem = name;
            });
            widget.onChangedValue(name);
          },
          child: CategoryWidget(
            name: name,
            icon: icon,
            selected: name == currentItem,
          )));
    });
    return ListView(
      scrollDirection: Axis.horizontal,
      children: widgets,
    );
  }
}
