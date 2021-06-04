import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _current = 0;
  int _max = 0;

  Future<YamlList> _loadNotes() async {
    var stringNotes =
        await DefaultAssetBundle.of(context).loadString("notes/notesdia1.yaml", cache: true);
    return loadYaml(stringNotes);
  }

  Widget _getCard(String message, {bool selected = false}) {
    return Card(
      color: selected ? Colors.grey[200] : Colors.white,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: FittedBox(
          child: Text(
            message,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: FutureBuilder<YamlList>(
                future: _loadNotes(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var list = snapshot.data as List;

                    scheduleMicrotask(() => setState(() {
                          _max = list.length;
                        }));

                    if (_max == 0) return _getCard('Llista buida');
                    return Column(
                      children: [
                        Expanded(
                          child: _getCard(list[_current]),
                        ),
                        Container(
                          height: 100,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              for (var nota in list)
                                Container(
                                  width: 300,
                                  child: _getCard(nota, selected: nota == list[_current]),
                                )
                            ],
                          ),
                        )
                      ],
                    );
                  }
                  if (snapshot.hasError) return _getCard(snapshot.error.toString());
                  return CircularProgressIndicator();
                },
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_current > 0)
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: FloatingActionButton(
                        onPressed: () {
                          if (_current <= 0) return;
                          setState(() {
                            _current--;
                          });
                        },
                        tooltip: 'Endarrera',
                        child: Icon(Icons.navigate_before),
                      ),
                    ),
                  if (_current + 1 < _max)
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: FloatingActionButton(
                        onPressed: () {
                          if (_current + 1 >= _max) return;
                          setState(() {
                            _current++;
                          });
                        },
                        tooltip: 'Endavant',
                        child: Icon(Icons.navigate_next),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
