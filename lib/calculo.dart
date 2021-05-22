import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: "Read Temperature",
    home: Calc(),
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

class Calc extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Calc> {

  String values;
  double p1, p2, t1, t2;
  double finalTempA, finalTempR;
  bool sub, sup;
  CounterStorage storage = new CounterStorage();
  @override
  void initState() {
    super.initState();
    DatabaseReference db = FirebaseDatabase.instance.reference();
    db.once().then((DataSnapshot snapshot){
      setState(() {
        var v = snapshot.value;
        t1 = v["Temp1"];
      });
    });
    storage.readCounter().then((String value) {
      setState(() {
        values = value;
        print(values);
        var parts = values.split('/');
        p1 = double.parse(parts[0]);
        p2 = double.parse(parts[1]);
        calculateSubSup();
      });
    });
  }

  void calculateSubSup() {
    var conversion = List.generate(2, (i) => List<double>(98), growable: false);
    conversion[0][0] = -50;
    conversion[1][0] = 5.5;
    conversion[0][1] = -48;
    conversion[1][1] = 3;
    conversion[0][2] = -46;
    conversion[1][2] = 0.2;
    conversion[0][3] = -44;
    conversion[1][3] = 1.3;
    conversion[0][4] = -42;
    conversion[1][4] = 2.9;
    conversion[0][5] = -40;
    conversion[1][5] = 4.6;
    conversion[0][6] = -38;
    conversion[1][6] = 6.4;
    conversion[0][7] = -36;
    conversion[1][7] = 8.3;
    conversion[0][8] = -34;
    conversion[1][8] = 10.4;
    conversion[0][9] = -32;
    conversion[1][9] = 12.6;
    conversion[0][10] = -30;
    conversion[1][10] = 15;
    conversion[0][11] = -28;
    conversion[1][11] = 17.5;
    conversion[0][12] = -26;
    conversion[1][12] = 20.1;
    conversion[0][13] = -24;
    conversion[1][13] = 23;
    conversion[0][14] = -22;
    conversion[1][14] = 26;
    conversion[0][15] = -20;
    conversion[1][15] = 29.2;
    conversion[0][16] = -19;
    conversion[1][16] = 30.9;
    conversion[0][17] = -18;
    conversion[1][17] = 32.6;
    conversion[0][18] = -17;
    conversion[1][18] = 34.3;
    conversion[0][19] = -16;
    conversion[1][19] = 36.2;
    conversion[0][20] = -15;
    conversion[1][20] = 38;
    conversion[0][21] = -14;
    conversion[1][21] = 39.9;
    conversion[0][22] = -13;
    conversion[1][22] = 41.9;
    conversion[0][23] = -12;
    conversion[1][23] = 43.9;
    conversion[0][24] = -11;
    conversion[1][24] = 46;
    conversion[0][25] = -10;
    conversion[1][25] = 48.1;
    conversion[0][26] = -9;
    conversion[1][26] = 50.3;
    conversion[0][27] = -8;
    conversion[1][27] = 52.6;
    conversion[0][28] = -7;
    conversion[1][28] = 54.9;
    conversion[0][29] = -6;
    conversion[1][29] = 57.3;
    conversion[0][30] = -5;
    conversion[1][30] = 59.7;
    conversion[0][31] = -4;
    conversion[1][31] = 62.2;
    conversion[0][32] = -3;
    conversion[1][32] = 64.7;
    conversion[0][33] = -2;
    conversion[1][33] = 67.3;
    conversion[0][34] = -1;
    conversion[1][34] = 70;
    conversion[0][35] = 0;
    conversion[1][35] = 72.7;
    conversion[0][36] = 1;
    conversion[1][36] = 75.5;
    conversion[0][37] = 2;
    conversion[1][37] = 78.4;
    conversion[0][38] = 3;
    conversion[1][38] = 81.4;
    conversion[0][39] = 4;
    conversion[1][39] = 88.4;
    conversion[0][40] = 5;
    conversion[1][40] = 87.4;
    conversion[0][41] = 6;
    conversion[1][41] = 90.6;
    conversion[0][42] = 7;
    conversion[1][42] = 93.8;
    conversion[0][43] = 8;
    conversion[1][43] = 97.1;
    conversion[0][44] = 9;
    conversion[1][44] = 100.5;
    conversion[0][45] = 10;
    conversion[1][45] = 105.5;
    conversion[0][46] = 11;
    conversion[1][46] = 109.1;
    conversion[0][47] = 12;
    conversion[1][47] = 112.7;
    conversion[0][48] = 13;
    conversion[1][48] = 16.4;
    conversion[0][49] = 14;
    conversion[1][49] = 120.2;
    conversion[0][50] = 15;
    conversion[1][50] = 124.1;
    conversion[0][51] = 16;
    conversion[1][51] = 128;
    conversion[0][52] = 17;
    conversion[1][52] = 132.1;
    conversion[0][53] = 18;
    conversion[1][53] = 136.2;
    conversion[0][54] = 19;
    conversion[1][54] = 140.4;
    conversion[0][55] = 20;
    conversion[1][55] = 144.7;
    conversion[0][56] = 21;
    conversion[1][56] = 149.1;
    conversion[0][57] = 22;
    conversion[1][57] = 153.5;
    conversion[0][58] = 23;
    conversion[1][58] = 158.1;
    conversion[0][59] = 24;
    conversion[1][59] = 162.8;
    conversion[0][60] = 25;
    conversion[1][60] = 167.5;
    conversion[0][61] = 26;
    conversion[1][61] = 172.3;
    conversion[0][62] = 27;
    conversion[1][62] = 177.3;
    conversion[0][63] = 28;
    conversion[1][63] = 182.3;
    conversion[0][64] = 29;
    conversion[1][64] = 187.4;
    conversion[0][65] = 30;
    conversion[1][65] = 192.7;
    conversion[0][66] = 31;
    conversion[1][66] = 198;
    conversion[0][67] = 32;
    conversion[1][67] = 203.4;
    conversion[0][68] = 33;
    conversion[1][68] = 209;
    conversion[0][69] = 34;
    conversion[1][69] = 214.6;
    conversion[0][70] = 35;
    conversion[1][70] = 220.4;
    conversion[0][71] = 36;
    conversion[1][71] = 226.2;
    conversion[0][72] = 37;
    conversion[1][72] = 232.2;
    conversion[0][73] = 38;
    conversion[1][73] = 238.3;
    conversion[0][74] = 39;
    conversion[1][74] = 244.4;
    conversion[0][75] = 40;
    conversion[1][75] = 250.7;
    conversion[0][76] = 41;
    conversion[1][76] = 257.2;
    conversion[0][77] = 42;
    conversion[1][77] = 263.7;
    conversion[0][78] = 43;
    conversion[1][78] = 270.3;
    conversion[0][79] = 44;
    conversion[1][79] = 277.1;
    conversion[0][80] = 45;
    conversion[1][80] = 284;
    conversion[0][81] = 46;
    conversion[1][81] = 291;
    conversion[0][82] = 47;
    conversion[1][82] = 298.1;
    conversion[0][83] = 48;
    conversion[1][83] = 305.3;
    conversion[0][84] = 49;
    conversion[1][84] = 312.7;
    conversion[0][85] = 50;
    conversion[1][85] = 320.2;
    conversion[0][86] = 52;
    conversion[1][86] = 335.6;
    conversion[0][87] = 54;
    conversion[1][87] = 351.5;
    conversion[0][88] = 56;
    conversion[1][88] = 368;
    conversion[0][89] = 58;
    conversion[1][89] = 385;
    conversion[0][90] = 60;
    conversion[1][90] = 402.6;
    conversion[0][91] = 62;
    conversion[1][91] = 420.8;
    conversion[0][92] = 64;
    conversion[1][92] = 439.5;
    conversion[0][93] = 66;
    conversion[1][93] = 458.9;
    conversion[0][94] = 68;
    conversion[1][94] = 479.4;
    conversion[0][95] = 70;
    conversion[1][95] = 500.8;
    conversion[0][96] = 72;
    conversion[1][96] = 523.2;
    conversion[0][97] = 74;
    conversion[1][97] = 320.2;

    double tempToPSIG;
    int i;

    // CALCULO DE SUPERAQUECIMENTO
    for(i = 0; i < 97; i++) {
      // Converte pressao para temperatura (404A)
      if(conversion[1][i] >= p1) {
        tempToPSIG = conversion[0][i];
        break;
      }
    }

    setState(() {
      finalTempA = t1 - tempToPSIG;

      if (finalTempA >= 4.0 && finalTempA <= 20.0)
        sup = true;
      else
        sup = false;
    });

//    // CALCULO DE SUBRESFRIAMENTO
//    for(i = 0; i < 97; i++) {
//      // Converte pressao para temperatura (404A)
//      if(conversion[1][i] >= p2) {
//        tempToPSIG = conversion[0][i];
//        break;
//      }
//    }
//
//    finalTempR = tempToPSIG - t2;
//
//    if(finalTempR >= 2.0 && finalTempR <= 8.0) sub = true;
//    else sup = false;

  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.95),
        appBar: AppBar(
          title: Text("Cálculos"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
              children: <Widget> [
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  height: 100,
                  width: double.maxFinite,
                  child: Card(
                      elevation: 5,
                      child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Superaquecimento: $finalTempA',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: sup == true? Colors.green : Colors.red),
                            ),
                      )
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  height: 100,
                  width: double.maxFinite,
                  child: Card(
                      elevation: 5,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Subresfriamento: $finalTempR',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: sub == true? Colors.green : Colors.red),
                        ),
                      )
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        child: Text('Voltar'),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()));
                        },

                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            textStyle: TextStyle(
                              fontSize: 20,
                            )),
                      ),
                    ]
                )
              ]
          ),
        )
    );
  }
}