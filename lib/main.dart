// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sound_mode/permission_handler.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:toner/constants/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

bool darkMode = false;
bool button = false;
bool bell = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool? isGranted = await PermissionHandler.permissionsGranted;

  if (!isGranted!) {
    // Opens the Do Not Disturb Access settings to grant the access
    await PermissionHandler.openDoNotDisturbSetting();
  }
  await initializeService();
  runApp(const MyApp());
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
  service.startService();
}

bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');

  return true;
}

void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");
  preferences.reload();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // bring to foreground
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    String ringerStatus = (await SoundMode.ringerModeStatus).toString();

    bool? fetchButtonBit = preferences.getBool("button");
    print(fetchButtonBit);

    fetchButtonBit ??= false;

    var curTime = DateTime.now();

    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "My App Service",
        content: "${fetchButtonBit} and ${curTime}",
      );
    }

    /// you can see this log in logcat
    // print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

    if (fetchButtonBit) {
      if (curTime.hour >= 17) {
        print("time to change");
        try {
          await SoundMode.setSoundMode(RingerModeStatus.silent);
        } on PlatformException {
          print('Please enable permissions required');
        }
      }
    }

    // test using external plugin

    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
        // "device": device,
      },
    );
  });
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
  @override
  initState() {
    super.initState();
    loadBits();
    listenBell();
    Timer mytimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      listenBell();
    });
  }

  listenBell() async {
    while (true) {
      String ringerStatus = (await SoundMode.ringerModeStatus).toString();
      if (ringerStatus == RingerModeStatus.silent.toString()) {
        updateBell(false);
      } else {
        updateBell(true);
      }
    }
  }

  updateBell(bool newSet) async {
    setState(() {
      bell = newSet;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("button", button);
  }

  loadBits() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool? fetchModeBit = pref.getBool("darkMode");
    bool? fetchButtonBit = pref.getBool("button");

    fetchModeBit ??= false;
    fetchButtonBit ??= false;

    setState(() {
      darkMode = fetchModeBit!;
    });
    setState(() {
      button = fetchButtonBit!;
    });
  }

  toggleTheme() async {
    setState(() {
      darkMode = !darkMode;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("darkMode", darkMode);
  }

  toggleButton() async {
    setState(() {
      button = !button;
    });
    print("Main code button : ${button}");
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("button", button);
  }

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
              toggleTheme();
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
              // Ringer Icon
              child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: darkMode == true
                      ? bell
                          ? darkTheme.ringerOnImage
                          : darkTheme.ringerOffImage
                      : bell
                          ? lightTheme.ringerOnImage
                          : lightTheme.ringerOffImage),
            ),
            Expanded(
              flex: 3,
              // Main Button
              child: InkWell(
                borderRadius: BorderRadius.circular(bound.height * 0.5),
                onTap: (() {
                  toggleButton();
                }),
                child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    height: bound.height * 0.3,
                    width: bound.height * 0.3,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(20, 61, 217, 1),
                      shape: BoxShape.circle,
                      boxShadow: [
                        darkMode
                            ? const BoxShadow(
                                color: Colors.black,
                                blurRadius: 10,
                                offset: Offset(0, 10),
                              )
                            : const BoxShadow(
                                color: Colors.grey,
                                blurRadius: 10,
                                offset: Offset(0, 10),
                              ),
                      ],
                    ),
                    child: Icon(
                      CupertinoIcons.power,
                      size: bound.height * 0.1,
                      color: button ? Colors.red : Colors.grey,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
