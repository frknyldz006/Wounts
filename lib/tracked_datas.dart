import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:wounts/constants.dart';

class TrackedDatas extends StatefulWidget {
  const TrackedDatas({Key? key}) : super(key: key);

  @override
  State<TrackedDatas> createState() => _TrackedDatasState();
}

class _TrackedDatasState extends State<TrackedDatas> {
  List<Map<String, dynamic>> _items = [];
  final tracklist = Hive.box('tracklist');
  @override
  void initState() {
    super.initState();

    _refreshItems(); // Load data when app starts
  }

  void _refreshItems() {
    final data = tracklist.keys.map((key) {
      final value = tracklist.get(key);
      return {"amount": value["amount"], "date": value['date']};
    }).toList();

    setState(() {
      _items = data.reversed.toList();
      // we use "reversed" to sort items in order from the latest to the oldest
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: darkBlue,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_sharp),
          ),
          title: Text("Tracked Water Amounts"),
        ),
        body: FutureBuilder(
            future: Hive.openBox('tracklist'),
            builder: (context, snapshot) {
              print(_items);
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    var _values = [];
                    _items[index].forEach((key, value) {
                      var _value = value;

                      _values.add(_value);
                    });
                    return ListTile(
                      leading: Icon(
                        Icons.water_drop_outlined,
                        color: blue,
                      ),
                      title: Text("${_values[0]}"),
                      trailing: Text("${_values[1]}"),
                    );
                  },
                );
              }
              return Center(
                child: CircularProgressIndicator(
                  color: darkBlue,
                ),
              );
            }));
  }
}
