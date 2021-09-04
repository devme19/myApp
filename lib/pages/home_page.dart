import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/controllers/home_page_controller.dart';

class HomePage extends GetView<HomePageController> {
  @override
  Widget build(BuildContext context) {
    return
      Obx(()=>Scaffold(
          appBar: AppBar(),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.save),
                label: 'ذخیره',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'افزودن عکس',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.business),
                label: 'افزودن متن',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.school),
                label: 'افزودن قاب',
              ),
            ],
            currentIndex: controller.selectedIndex.value,
            selectedItemColor: Colors.amber[800],
            onTap: controller.onMenuTapped,
          ),
          body:
        RepaintBoundary(
          key: controller.globalKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(controller.savedImagePath.value),
              Expanded(
                child: Stack(
                    children: controller.texts),
              ),
            ],
          ),
        ),
      ));
  }
}
