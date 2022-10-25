// ignore_for_file: use_build_context_synchronously

import 'package:api_app/api.dart';
import 'package:api_app/user.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:internet_connection_checker/internet_connection_checker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List user = [];
  int pagenumber = 0;
  final ScrollController scrollcontroller = ScrollController();
  Api a = Api();
  TextEditingController name = TextEditingController();
  TextEditingController job = TextEditingController();

  // @override
  // void setState(VoidCallback fn) {
  //   // TODO: implement setState
  //   scrollcontroller.addListener(() {
  //     if (scrollcontroller.position.maxScrollExtent ==
  //         scrollcontroller.offset) {
  //       a.getData(pagenumber: pagenumber++);
  //       debugPrint("vdf");
  //     }
  //   });
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // asyncmethod();
    asyncmethod();
    scrollcontroller.addListener(() {
      if (scrollcontroller.position.maxScrollExtent ==
          scrollcontroller.offset) {
        fetch();
      }
    });
  }

  Future fetch() async {
    List user1 = await a.getData(
      pagenumber: ++pagenumber,
    );
    setState(() {
      user.addAll(user1);
    });
  }

  asyncmethod() async {
    // Future<List> user1 = a.getData(pagenumber: pagenumber, user: user);
    List user1 = await a.getData(
      pagenumber: pagenumber,
    );
    setState(() {
      user.addAll(user1);
    });
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: user.isEmpty
            ? const Center(
                child: SizedBox(
                    height: 40, width: 40, child: CircularProgressIndicator()),
              )
            : ListView.builder(
                controller: scrollcontroller,
                itemCount: user.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index >= user.length) {
                    if (pagenumber >= 3) {
                      return Center(
                        child: Text(
                          "No More Data",
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    } else {
                      return const Center(
                        child: SizedBox(
                            height: 40,
                            width: 40,
                            child: CircularProgressIndicator()),
                      );
                    }
                  } else {
                    return Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: ListTile(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  width: 1,
                                  color: Colors.greenAccent,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              leading: Container(
                                height: 50,
                                width: 50,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(80)),
                                ),
                                child: Image.network(
                                  user[index]['avatar'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(user[index]['email']),
                              trailing: IconButton(
                                onPressed: () async {
                                  bool result =
                                      await InternetConnectionChecker()
                                          .hasConnection;
                                  if (result == true) {
                                    Future<String?> data = a.deleteUser(
                                        user[index]['id'].toString());
                                    if (data == null) {
                                      return showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                backgroundColor: Colors.black45,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                                elevation: 12,
                                                content: Center(
                                                  widthFactor: 2,
                                                  heightFactor: 3,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      "Item not Deleted",
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 23),
                                                    ),
                                                  ),
                                                ),
                                              ));
                                    } else {
                                      return showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                backgroundColor: Colors.black45,
                                                contentPadding:
                                                    const EdgeInsets.all(0),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                                elevation: 12,
                                                content: Center(
                                                  widthFactor: 0.1,
                                                  heightFactor: 1,
                                                  child: SizedBox(
                                                    height: 75,
                                                    child: Column(
                                                      children: [
                                                        const Text(
                                                          'Item deleted',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green,
                                                              fontSize: 23),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                            "Done",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 23),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ));
                                    }
                                  } else {
                                    final snackbar = SnackBar(
                                        backgroundColor: Colors.black,
                                        action: SnackBarAction(
                                            label: 'close', onPressed: () {}),
                                        content:
                                            const Text('No Internet Connection',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                )));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackbar);
                                  }
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              )),
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    );
                  }
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () async {
          bool result = await InternetConnectionChecker().hasConnection;
          if (result == true) {
            showDialog(
              builder: (BuildContext context) => Dialog(
                // backgroundColor: Color.fromARGB(95, 10, 78, 223),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                elevation: 12,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  height: 250,
                  child: ListView(children: [
                    TextField(
                      controller: name,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                        ),
                        hintText: 'Enter a Your Name',
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: job,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                        ),
                        hintText: 'Enter a Job Title',
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    // height: 100.0,
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 36, 189, 115),
                          // shadowColor: Colors.greenAccent,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                          minimumSize: const Size(20, 40), //////// HERE
                        ),
                        onPressed: () async {
                          if (name.text.isEmpty) {
                            final snackbar = SnackBar(
                                backgroundColor: Colors.black,
                                action: SnackBarAction(
                                    label: 'close', onPressed: () {}),
                                content: const Text('Name Box is Empty',
                                    style: TextStyle(
                                      color: Colors.white,
                                    )));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbar);
                          } else if (job.text.isEmpty) {
                            final snackbar = SnackBar(
                                backgroundColor: Colors.black,
                                action: SnackBarAction(
                                    label: 'close', onPressed: () {}),
                                content: const Text('Job Box is Empty',
                                    style: TextStyle(
                                      color: Colors.white,
                                    )));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbar);
                          } else {
                            try {
                              await a.createUser(name.text, job.text, context);
                              name.clear();
                              job.clear();
                              Navigator.pop(context);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext contexta) =>
                                      AlertDialog(
                                        contentPadding: EdgeInsets.all(0),
                                        backgroundColor: Colors.black45,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        elevation: 12,
                                        content: Center(
                                          widthFactor: 1,
                                          heightFactor: 2,
                                          child: SizedBox(
                                            height: 75,
                                            child: Column(
                                              children: [
                                                const Text(
                                                  'Item Added',
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 23),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(contexta);
                                                  },
                                                  child: const Text(
                                                    "Okay",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 23),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ));
                            } catch (e) {
                              final snackbar = SnackBar(
                                  backgroundColor: Colors.black,
                                  action: SnackBarAction(
                                      label: 'close', onPressed: () {}),
                                  content:
                                      const Text('Internet Connection Is Lost',
                                          style: TextStyle(
                                            color: Colors.white,
                                          )));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackbar);
                            }
                          }
                        },
                        child: const Text('Submit'))
                  ]),
                ),
              ),
              context: context,
            );
          } else {
            final snackbar = SnackBar(
                backgroundColor: Colors.black,
                action: SnackBarAction(label: 'close', onPressed: () {}),
                content: const Text('No Internet Connection',
                    style: TextStyle(
                      color: Colors.white,
                    )));
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  scrollview() {
    debugPrint(scrollcontroller.position.pixels.toString());
  }
}
