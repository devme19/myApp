import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myapp/bindings/home_page_binding.dart';
import 'package:myapp/navigations/my_app.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async{
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'fontFamily1',
      ),
      initialRoute: MyAppRoutes.mainPage,
      locale: Locale('fa','IR'),
      // initialBinding: HomePageBinding(),
      getPages: MyApp1.pages,
    );
  }
}