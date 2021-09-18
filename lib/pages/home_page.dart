import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/controllers/home_page_controller.dart';
import 'package:myapp/models/font_family_model.dart';
import 'package:myapp/models/palette_hue_picker_page.dart';
import 'package:myapp/models/resizable_item_model.dart';
import 'package:myapp/widgets/resizable_widget.dart';
import 'package:shape_of_view/shape_of_view.dart';
class HomePage extends GetView<HomePageController> {
  HomePage(){
    if(Get.arguments != null){
      controller.loadProject(Get.arguments);
    }
  }
  @override
  Widget build(BuildContext context) {
    return
      Obx(()=>Scaffold(
        drawer: Drawer(
          child: ReorderableListView(
            header: Container(
              color: Colors.deepOrangeAccent,
              height: Get.height/6,
            ),
            children: [
              for(int i=0;i<controller.layout.length;i++)
                Card(
                    // color:controller.keys[0].?Colors.grey:Colors.white ,
                    key: ValueKey(controller.layout[i]),
                    child: ListTile(
                      onTap: () {
                         controller.onListTileTap(i);
                        Get.back();
                      },
                      trailing:
                      Container(
                        // color: Colors.grey,
                        width: 80,
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                  onTap: () {
                                    Get.back();
                                    controller.onEditListTile(i);

                                  },
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.green,
                                  )
                              ),
                            ),
                            SizedBox(width: 30,),
                            Expanded(
                              child: InkWell(
                                  onTap: () {
                                    controller.onDeleteListTile(i);
                                    Get.back();
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      title: Text(

                        controller.layout[i].resizableItemModel.title ,overflow: TextOverflow.ellipsis,),
                    ))
            ],
            onReorder: reorderData,
          ),
        ),
          appBar: AppBar(),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items:
            const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.save),
                // Icon(Icons.save),
                label: 'ذخیره',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('assets/icons/image.png')),
                label: 'افزودن عکس',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('assets/icons/text.png')),
                label: 'افزودن متن',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('assets/icons/frame.png')),
                label: 'افزودن قاب',
              ),
            ],
            currentIndex: controller.selectedIndex.value,
            selectedItemColor: Colors.amber[800],
            onTap: onMenuTapped,
          ),
          body:

          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: ()=>controller.showSaveContainer.value = false,
            child: Stack(
            children: [


              RepaintBoundary(
                key: controller.globalKey,
                child: Stack(
                    children: controller.layout),
              ),
              controller.showSaveContainer.value?
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 150,
                  child: Column(children: [

                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: ()=> controller.saveAsImage(true),
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          child: Text('ذخیره به صورت عکس'),
                        ),
                      ),
                    ),
                    Container(
                      width: 100,
                      child: Divider(

                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: ()=> controller.saveProject(),
                        child: Container(
                          // decoration: BoxDecoration(
                          //   color: Colors.white,
                          //     // boxShadow: [
                          //     //   BoxShadow(
                          //     //     color: Colors.grey.withOpacity(0.9),
                          //     //     spreadRadius: 1,
                          //     //     blurRadius: 5,
                          //     //     offset: Offset(0, 3), // changes position of shadow
                          //     //   ),
                          //     // ],
                          //   borderRadius: BorderRadius.circular(10)
                          // ),
                          padding: EdgeInsets.all(16.0),
                          child: Text('ذخیره پروژه'),
                        ),
                      ),
                    ),
                    // Expanded(
                    //   child: ShapeOfView(
                    //     height: 30,
                    //     width: 30,
                    //     elevation: 1,
                    //     shape: TriangleShape(
                    //         percentBottom: 0.5,
                    //         percentLeft: 0.6,
                    //         percentRight: 0.6
                    //     ),
                    //   ),
                    // )
                  ],),
                ),
              ):Container(),
            ],
        ),
          ),
      ));
  }
  void reorderData(int oldIndex, int newIndex){
    if(newIndex>oldIndex){
      newIndex-=1;
    }
    final item =controller.keys.removeAt(oldIndex);
    final widget = controller.layout.removeAt(oldIndex);
    controller.layout.insert(newIndex, widget);
    controller.keys.insert(newIndex, item);
    // if(controller.selectedItemIndex.value != -1)
    //   controller.selectedItemIndex.value = newIndex;
  }
  onMenuTapped(int index){
    String fontFamilyName;
    switch (index){
      case 0:
        controller.showSaveContainer.value = true;
        break;
      case 1:
        controller.showSaveContainer.value = false;
        controller.pickImageFromGallery(false,-1);
        break;
      case 2:
        controller.showSaveContainer.value = false;

        showModalBottomSheet(
            context: Get.context, builder: (context){
          return StatefulBuilder(builder: (context,StateSetter setState){
            return
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                height: Get.height/3,
                padding: EdgeInsets.all(16.0),
                color: Colors.white,
                child:

                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              maxLines: null,
                              // textInputAction: TextInputAction.done,
                              style: TextStyle(color: controller.currentColor.value,fontFamily: controller.selectedFontFamily.value),
                              controller: controller.textEditingController,
                            ),
                          ),
                          SizedBox(width: 16.0,),
                          InkWell(
                            onTap: ()=>Get.dialog(
                                PaletteHuePickerPage(pickedColor:(pickedColor){
                                  setState(()=>controller.currentColor.value = pickedColor);
                                },currentColor: controller.currentColor.value,)
                            ),
                            child: Image.asset('assets/icons/color-picker.png',width: 30,height: 30,),
                          ),
                          SizedBox(width: 16.0,),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0,),

                    Expanded(
                      flex: 3,
                      child: Container(
                        // padding: EdgeInsets.all(8.0),
                        child:
                        Column(
                          children: [

                            Row(
                              children: [
                                Text('انتخاب فونت'),
                              ],
                            ),
                            SizedBox(height: 8.0,),
                            Expanded(
                              child: GridView.builder(
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 5,
                                      crossAxisSpacing: 5,
                                      mainAxisExtent: 50
                                  ),
                                  itemCount: FontFamilyModel().fontFamily.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return
                                      InkWell(
                                        onTap: (){
                                          setState(()=> controller.selectedFontFamilyIndex.value = index);
                                          // controller.selectedFontFamilyIndex.value = index;
                                          controller.selectedFontFamily.value = FontFamilyModel().fontFamily[index];
                                        },
                                        child: Container(
                                            color: controller.selectedFontFamilyIndex.value == index?Colors.grey.withOpacity(0.4):Colors.grey.withOpacity(0.1),
                                            child: Center(child: Text('سلام',style: TextStyle(fontFamily: FontFamilyModel().fontFamily[index]),))),
                                      );
                                  }
                                // ListView.builder(
                                //   scrollDirection: Axis.horizontal,
                                //   itemCount: FontFamilyModel().fontFamily.length,
                                //     itemBuilder: (context,index){
                                //     return
                                //
                                //       InkWell(
                                //         onTap: (){
                                //
                                //         },
                                //           child: Container(
                                //             margin: EdgeInsets.all(3.0),
                                //             color: Colors.grey.withOpacity(0.2),
                                //             width: 80,
                                //               child:
                                //               Center(child: Text('سلام',style: TextStyle(fontFamily: FontFamilyModel().fontFamily[index]),))));
                                //     }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.deepPurple,
                                    shape: new RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(10.0),
                                    )),
                                onPressed: (){
                                  if(controller.textEditingController.text.isNotEmpty)
                                  {
                                    Get.back();
                                    controller.keys.add(new GlobalKey());
                                    controller.layout.add(
                                        new ResizableWidget(
                                          key: controller.keys.last,
                                          resizableItemModel: ResizableItemModel(
                                            isSelected: true,
                                            isImage: false,
                                            fontFamily: controller.selectedFontFamily.value,
                                            child: Text(controller.textEditingController.text,style: TextStyle(color: controller.currentColor.value,fontFamily: controller.selectedFontFamily.value),),
                                            title: controller.textEditingController.text,
                                            color: controller.currentColor.value,
                                            colorStr: '0x${controller.currentColor.value.value.toRadixString(16)}',
                                          ),
                                        ));
                                    controller.textEditingController.clear();
                                  }
                                  // texts.add(
                                  //     ResizableWidget(child: Text(textEditingController.text,style: TextStyle(color: currentColor.value.toColor()),),deleteItem: deleteItem,)
                                  // );
                                }, child:
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('افزودن'),
                            )),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
            ),
              );
          });
        });
        break;
      case 3:
        controller.showSaveContainer.value = false;
        int index = -1;
        for(int i=0;i<controller.layout.length;i++)
          if(controller.layout[i].resizableItemModel.isFrame)
          {
            index = i;
            break;
          }
        controller.pickFrame(index);
        break;
    }
    controller.selectedIndex.value = index;
  }

}
