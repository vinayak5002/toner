import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toner/constants/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool on = false;
  final bool _mode = false;
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    final bound = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: darkMode ? Colors.grey[900] : lightTheme.scaffoldColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          "Toner",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color:
                darkMode == true ? darkTheme.titleColor : lightTheme.titleColor,
          ),
        ),
        backgroundColor: darkMode ? Colors.grey[900] : lightTheme.scaffoldColor,
        actions: [
          IconButton(
            icon: Icon(
              !darkMode ? Icons.brightness_3 : Icons.brightness_7,
              color: darkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              setState(() {
                darkMode = !darkMode;
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: darkMode == true
                      ? darkTheme.ringerOffImage
                      : lightTheme.ringerOffImage),
            ),
            Expanded(
              flex: 3,
              child: InkWell(
                borderRadius: BorderRadius.circular(bound.height * 0.5),
                onTap: (() {
                  setState(() {
                    on = !on;
                  });
                }),
                child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    height: bound.height * 0.3,
                    width: bound.height * 0.3,
                    decoration: const BoxDecoration(
                      color: Colors.yellow,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 10,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      CupertinoIcons.power,
                      size: bound.height * 0.1,
                      color: on ? Colors.red : Colors.grey,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
