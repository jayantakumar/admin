import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ADMIN',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: TextTheme(body1: TextStyle(color: Colors.white))),
      home: AdminPage(),
    );
  }
}

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ADMIN")),
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Center(
                    child: FlatButton(
                  onPressed: () => showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            title: Text("ALERT!!"),
                            content: Text(
                              "ARE YOU SURE YOU WANT TO DO THIS YOUR ACTIONS CANNOT BE RESETED",
                              style: TextStyle(color: Colors.redAccent),
                            ),
                            actions: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.done),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    access();
                                  })
                            ],
                          )),
                  child: Text(
                    "Update Monthly info",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.redAccent,
                )),
                SizedBox(
                  height: 30,
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => RealTimePage()));
                  },
                  child: Text(
                    "Request real time data",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.pinkAccent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void access() async {
  Firestore.instance.collection("/data").getDocuments().then((q) {
    for (int i = 0; i <= q.documents.length; i++) {
      int data = int.parse(q.documents[i].data["interval"].toString());
      print(data);
      if (data == 3) data = 0;
      if (data == 2 || data == 1) data++;

      Firestore.instance
          .collection("/data")
          .document(q.documents[i].documentID)
          .updateData(
        {"interval": data},
      );
    }
  });
}

class RealTimePage extends StatefulWidget {
  @override
  _RealTimePageState createState() => _RealTimePageState();
}

class _RealTimePageState extends State<RealTimePage> {
  List<DocumentSnapshot> docs = [];

  serve() async {
    await Firestore.instance.collection("/requests").getDocuments().then((q) {
      setState(() {
        docs = q.documents;
      });
    });
  }

  @override
  void initState() {
    serve();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: docs.length,
            itemBuilder: (_, int i) {
              return ListTile(
                leading: Icon(
                  Icons.opacity,
                  color: Colors.red,
                ),
                isThreeLine: true,
                onTap: () => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          title: Text("Info"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                  "UID: ${docs[i]["RECIVER UID"] == null ? "NOT AVAILABLE" : docs[i]["RECIVER UID"]}"),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                  "EMAIL: ${docs[i]["RECIVER EMAIL"] == null ? "NOT AVAILABLE" : docs[i]["RECIVER EMAIL"]}"),
                            ],
                          ),
                        )),
                subtitle: Text(
                  "DONOR : ${docs[i]["DONOR No"]}-->RECIVER : ${docs[i]["RECIVER No"]}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            }));
  }
}
