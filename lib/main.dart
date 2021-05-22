import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'temp.dart';
import 'temp2.dart';
import 'pressao.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

// For background service
void callbackDispatcher() async {
  Workmanager().executeTask((taskName, inputData) {
    switch (taskName) {
      case "getFireBase":
        DatabaseReference db = FirebaseDatabase.instance.reference();
        db.once().then((DataSnapshot snapshot){
            var values = snapshot.value;
            print(values["Temp1"]);
        });
        break;
    }

    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Workmanager().initialize(callbackDispatcher);
  Workmanager().registerPeriodicTask("1", "getFireBase", frequency: Duration(minutes: 15), initialDelay: Duration(seconds: 10));
  runApp(MaterialApp(
    title: "Read Temperature",
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Monitoramento"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        height: 100,
                        width: double.maxFinite,
                        child: Card(
                          elevation: 5,
                          child: InkWell(
                            onTap:() {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Temp()));
                            },
                            child: Align(
                              alignment: Alignment.center,
                              child: Text("Câmara 1"),
                            )
                          )
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        height: 100,
                        width: double.maxFinite,
                        child: Card(
                            elevation: 5,
                            child: InkWell(
                                onTap:() {
//                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Temp2()));
                                },
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("Câmara 2"),
                                )
                            )
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        height: 100,
                        width: double.maxFinite,
                        child: Card(
                            elevation: 5,
                            child: InkWell(
                                onTap:() {
                                },
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("Câmara 3"),
                                )
                            )
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        height: 100,
                        width: double.maxFinite,
                        child: Card(
                            elevation: 5,
                            child: InkWell(
                                onTap:() {
                                },
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("Câmara 4"),
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
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Pres()));
                                  },
                                  child: Text('Pressões'),
                                ),
                              ]
                          )
                      )
                    ]
                )
            ),
    );
  }
}