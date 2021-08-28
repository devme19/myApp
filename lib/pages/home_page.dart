import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:get/get.dart';
import 'package:myapp/models/palette_hue_picker_page.dart';
import 'package:myapp/controllers/home_page_controller.dart';
import 'package:myapp/widgets/resizable_widget.dart';

class HomePage extends GetView<HomePageController> {
  @override
  Widget build(BuildContext context) {
    return
      Obx(()=>Scaffold(
          appBar: AppBar(),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
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
                label: 'افزودن تمپلیت',
              ),
            ],
            currentIndex: controller.selectedIndex.value,
            selectedItemColor: Colors.amber[800],
            onTap: controller.onMenuTapped,
          ),
          body:
        Container(
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: IndexedStack(
                      index: controller.selectedStackIndex.value,
                      children: [
                        Container(
                          width: Get.width,
                          height: Get.height,
                          // color: Colors.yellow.withOpacity(0.3),
                          child: Stack(children: controller.texts,),
                        ),
                        Container(
                          width: 200,
                          height: 200,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  // IconButton(icon: Icon(Icons.add), onPressed: (){
                  //   if(controller.selectedStackIndex.value == 0)
                  //     controller.selectedStackIndex.value = 1;
                  //   else
                  //     controller.selectedStackIndex.value = 0;
                  // }),
                ],
              ),
            ],
          ),
        ),
      ));
  }
}
