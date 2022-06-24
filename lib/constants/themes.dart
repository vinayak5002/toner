import 'package:flutter/material.dart';

class DarkTheme {
  const DarkTheme();

  final Widget ringerOnImage = const Image(
    image: AssetImage('assets/images/Dbell.png'),
    width: 100,
    height: 100,
  );

  final Widget ringerOffImage = const Image(
    image: AssetImage('assets/images/Dbelloff.png'),
    width: 100,
    height: 100,
  );

  final Color titleColor = Colors.white;

  final Color scaffoldColor = Colors.grey;
}

class LightTheme {
  const LightTheme();

  final Widget ringerOnImage = const Image(
    image: AssetImage('assets/images/bell.png'),
    width: 100,
    height: 100,
  );

  final Widget ringerOffImage = const Image(
    image: AssetImage('assets/images/belloff.png'),
    width: 100,
    height: 100,
  );

  final Color titleColor = Colors.black;

  final Color scaffoldColor = Colors.white;
}

const darkTheme = DarkTheme();
const lightTheme = LightTheme();
