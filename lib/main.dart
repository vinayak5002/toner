import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_mute/flutter_mute.dart';

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
  // RingerMode _mode = RingerMode.Silent;

  // Future<void> getRingerMode() async {
  //   RingerMode? mode = await FlutterMute.getRingerMode();

  //   if (!mounted) return;

  //   setState(() {
  //     _mode = mode;
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   getRingerMode();
  // }

  bool _mode = false;

  Widget kRingerOnImage = const Image(
    image: AssetImage('assets/images/bell.png'),
    width: 100,
    height: 100,
  );

  Widget kRingerOffImage = const Image(
    image: AssetImage('assets/images/belloff.png'),
    width: 100,
    height: 100,
  );

  @override
  Widget build(BuildContext context) {
    final bound = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Center(
            child: Text(
          "Toner",
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
        )),
        backgroundColor: const Color.fromARGB(31, 255, 255, 255),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                  // child: const Icon(Icons.do_not_disturb_on,
                  //     size: 80, color: Colors.black)),
                  child: _mode == false ? kRingerOffImage : kRingerOnImage),
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
