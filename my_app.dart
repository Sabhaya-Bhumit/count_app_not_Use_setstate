import 'package:flutter/material.dart';
import 'package:random_people_api/texteditingclean.dart';

// import 'package:time_mer/texteditingclean.dart';

import 'counter_bloc.dart';
import 'history_list.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyCounter(),
    );
  }
}

class MyCounter extends StatefulWidget {
  const MyCounter({Key? key}) : super(key: key);

  @override
  State<MyCounter> createState() => _MyCounterState();
}

class _MyCounterState extends State<MyCounter> {
  // TextEditingController valueController = TextEditingController();
  int i = 0;
  List time = [];
  // int clean_list = 0;
  final ScrollController _scrollController = ScrollController();
  final counterBloc = CounterBloc();
  final historyBloc = HistoryBloc();
  final texteCleanBloc = TexteCleanBloc();
  @override
  void dispose() {
    counterBloc.dispose();
    historyBloc.dispose();
    texteCleanBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Simple Counter"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              StreamBuilder(
                  initialData: counterBloc.count,
                  stream: counterBloc.counterStream,
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    if (snapshot.data! >= 1) {
                      if (i == 0) {
                        historyBloc.incrementHistory(i);
                        counterBloc.decrementCounter();
                        i++;
                        String str = DateTime.now()
                            .toString()
                            .split(" ")[1]
                            .split(".")[0];
                        time.add(str);
                      } else {
                        print('object =>/ $i');
                        Future.delayed(Duration(seconds: 1), () {
                          print('object => $i');
                          historyBloc.incrementHistory(i);
                          counterBloc.decrementCounter();
                          String str = DateTime.now()
                              .toString()
                              .split(" ")[1]
                              .split(".")[0];
                          time.add(str);
                          i++;
                          _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: Duration(milliseconds: 200),
                              curve: Curves.easeInOut);
                        });
                      }
                      return CircularProgressIndicator();
                    } else {
                      return Text("Enter Your Secode");
                    }
                  }),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                      child: StreamBuilder(
                    initialData: texteCleanBloc.textEditingController,
                    stream: texteCleanBloc.TexteditingclearStream,
                    builder: (context, snapshot) {
                      return TextFormField(
                        maxLength: 5,
                        controller: snapshot.data,
                        keyboardType: TextInputType.number,
                      );
                    },
                  )
                      //
                      ),
                  Expanded(
                      child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          i = 0;
                          if (int.parse(
                                  texteCleanBloc.textEditingController.text) >
                              0) {
                            counterBloc.Count(int.parse(
                                texteCleanBloc.textEditingController.text));
                          }
                          historyBloc.clearList();
                          time = [];
                        },
                        child: Text("Start"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          i = 0;
                          counterBloc.count = 0;
                          Future.delayed(Duration(seconds: 1), () {
                            texteCleanBloc.TextClean();
                            historyBloc.clearList();
                            time = [];
                          });
                        },
                        child: Text("Stop"),
                      )
                    ],
                  )),
                ],
              ),
              SizedBox(height: 20),
              Text("History"),
              Container(
                  height: 440,
                  // alignment: Alignment.center,
                  child: StreamBuilder(
                    // initialData: HistoryBloc.h,
                    initialData: historyBloc.History,
                    stream: historyBloc.HistoryStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Error is ${snapshot.hasError}"),
                        );
                      } else if (snapshot.hasData) {
                        List? res = snapshot.data;

                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: res!.length,
                          itemBuilder: (context, i) {
                            return Text(
                              "${res[i]}  =>${time[i]}",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            );
                          },
                        );

                        //
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  )),

              //
            ],
          ),
        ),
      ),
    );
  }
}
