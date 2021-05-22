import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'calculo.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

BuildContext scaffoldContext;

displaySnackBar(BuildContext context, String msg) {
  final snackBar = SnackBar(
    content: Text(msg),
    action: SnackBarAction(
      label: 'Ok',
      onPressed: () {},
    ),
  );
  Scaffold.of(scaffoldContext).showSnackBar(snackBar);
}

void main() {
  runApp(MaterialApp(
    title: "Read Temperature",
    debugShowCheckedModeBanner: false,
    home: Temp2(),
  ));
}

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<File> writeCounter(String counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(counter);
  }

  Future<String> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return null;
    }
  }
}


class Temp2 extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Temp2> {

  String values;
  CounterStorage storage = new CounterStorage();
  @override
  void initState() {
    super.initState();
    getInitLedState(); // Getting initial state of LED, which is by default on
    storage.readCounter().then((String value) {
      setState(() {
        values = value;
      });
    });
  }
  String _status = '';
  String temps = '';
  String url =
      'http://192.168.1.200:80/'; //IP Address which is configured in NodeMCU Sketch
  var response;
  double t1 = 0.0, t2 = 0.0, t3 = 0.0, t4 = 0.0;

  getInitLedState() async {
    try {
      response = await http.get(Uri.parse(url), headers: {"Accept": "plain/text"});
      setState(() {
        _status = 'Connected';
      });
    } catch (e) {
      // If NodeMCU is not connected, it will throw error
      print('Error:');
      print(e);
      if (this.mounted) {
        setState(() {
          _status = 'Not Connected';
        });
      }
    }
  }

  readTemp() async {
    try {
      response = await http.get(Uri.parse(url+'temperature'), headers: {"Accept": "plain/text"});
      setState(() {
        temps = response.body;
        var parts = temps.split('/');
        t1 = double.parse(parts[0]);
        t2 = double.parse(parts[1]);
        t3 = double.parse(parts[2]);
        t4 = double.parse(parts[3]);
        print(response.body);
      });
    } catch (e) {
      // If NodeMCU is not connected, it will throw error
      print(e);
      displaySnackBar(context, 'Module Not Connected');
    }
  }

  BuildContext scaffoldContext;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.95),
      key: _scaffoldKey,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState.openDrawer(),
        ),
        title: Text("Temperaturas"),
        centerTitle: true,
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.fromLTRB(10, 60, 0, 0),
              child: Text('Operações', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black
                      ),
                      text: "Cálculos    ",
                    ),
                    WidgetSpan(
                      child: Icon(Icons.trending_up, size: 20),
                    ),
                  ],
                ),
              ),
              onTap: () {
                storage.writeCounter(values+'/'+temps);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Calc()));
              },
            ),
            ListTile(
              title: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Gráfico    ",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black
                      ),
                    ),
                    WidgetSpan(
                      child: Icon(Icons.calculate, size: 20),
                    ),
                  ],
                ),
              ),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      body: Builder(builder: (BuildContext context) {
        scaffoldContext = context;
        return ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 50, 10, 10),
              height: 150,
              width: double.maxFinite,
              child: Card(
                  elevation: 5,
                  child: InkWell(
                      onTap: readTemp,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Temperatura: $t2"),
                      )
                  )
              ),
            ),
            Container(
                padding: const EdgeInsets.all(25.0),
                child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()));
                        },
                        child: Text('Voltar'),
                      ),
                    ]
                )
            )
          ],
        );
      }),
    );
  }
}