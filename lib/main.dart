import 'package:flutter/material.dart';

import 'common/themes/themes.dart';
import 'ui/pages/home_page.dart';
import 'common/config/dependencies.dart';

void main() {
  seputDependencies();
  runApp(MaterialApp(
    title: 'Student ID card',
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
    theme: myTheme,
  ));
}
