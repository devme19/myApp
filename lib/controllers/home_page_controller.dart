import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/models/palette_hue_picker_page.dart';
import 'package:myapp/models/resizable_item_model.dart';
import 'package:myapp/widgets/image_widget.dart';
import 'package:myapp/widgets/resizable_widget.dart';
class HomePageController extends GetxController{
  RxInt selectedIndex = 0.obs;
  var texts = <Widget>[].obs;
  TextEditingController textEditingController = TextEditingController();
  Rx<Color> currentColor = Colors.black.obs;
  RxInt selectedStackIndex = 0.obs;
  ImagePicker _picker = ImagePicker();
  Rx<XFile> image = XFile("").obs;
  onColorPicked(Color pickedColor){
    currentColor.value = pickedColor;
  }
  onMenuTapped(int index){
    switch (index){
      case 0:
        break;
      case 1:
        pickImageFromGallery();
        break;
      case 2:
        Get.bottomSheet(
            Container(
              height: 200,
              padding: EdgeInsets.all(16.0),
              color: Colors.white,
              child:

              SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            maxLines: null,
                            // textInputAction: TextInputAction.done,
                            style: TextStyle(color: currentColor.value),
                            controller: textEditingController,
                          ),
                        ),
                        SizedBox(width: 16.0,),
                        InkWell(
                          onTap: ()=>Get.dialog(
                              PaletteHuePickerPage(pickedColor: onColorPicked,currentColor: currentColor.value,)
                          ),
                          child: Image.asset('assets/icons/color-picker.png',width: 30,height: 30,),
                        )
                      ],
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.deepPurple,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                            )),
                        onPressed: (){
                          Get.back();
                          texts.add(ResizableWidget(
                            resizableItemModel: ResizableItemModel(
                                child: Text(textEditingController.text,style: TextStyle(color: currentColor.value),),
                                title: textEditingController.text,
                                color: currentColor.value,
                                deleteItem: deleteItem,
                                editItem: editItem,
                                bringToFront: bringToFront
                            ),
                          ));
                          textEditingController.clear();
                          // texts.add(
                          //     ResizableWidget(child: Text(textEditingController.text,style: TextStyle(color: currentColor.value.toColor()),),deleteItem: deleteItem,)
                          // );
                        }, child:
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('افزودن'),
                    ))
                  ],
                ),
              ),
            )
        );
    }
    selectedIndex.value = index;
  }
  deleteItem(ResizableWidget widget){
    texts.remove(widget);
  }
  bringToFront(ResizableWidget widget){
    List<Widget> tempList = [];
    tempList.addAll(texts);
    tempList.remove(widget);
    texts.clear();
    texts.add(widget);
    texts.addAll(tempList);
  }
  editItem(ResizableWidget widget){
    textEditingController.text = widget.resizableItemModel.title;
    currentColor.value = widget.resizableItemModel.color;
    Get.bottomSheet(
        Container(
          height: 200,
          padding: EdgeInsets.all(16.0),
          color: Colors.white,
          child:

          SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        maxLines: null,
                        // textInputAction: TextInputAction.done,
                        style: TextStyle(color: currentColor.value),
                        controller: textEditingController,
                      ),
                    ),
                    SizedBox(width: 16.0,),
                    InkWell(
                      onTap: ()=>Get.dialog(
                          PaletteHuePickerPage(pickedColor: onColorPicked,currentColor: currentColor.value,)
                      ),
                      child: Image.asset('assets/icons/color-picker.png',width: 30,height: 30,),
                    )
                  ],
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        )),
                    onPressed: (){
                      Get.back();
                      for(int i=0;i<texts.length;i++)
                        if(texts[i] == widget)
                          {
                            texts[i] = ResizableWidget(
                              resizableItemModel: ResizableItemModel(
                                  child: Text(textEditingController.text,style: TextStyle(color: currentColor.value),),
                                  editItem: editItem,
                                  deleteItem: deleteItem,
                                  color: currentColor.value,
                                  title: textEditingController.text
                              ),
                            );
                            textEditingController.clear();
                            break;
                          }
                    }, child:
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('ویرایش'),
                ))
              ],
            ),
          ),
        )
    );
  }
  pickImageFromGallery() async{
    image.value = await _picker.pickImage(source: ImageSource.gallery);
    texts.add(
        ResizableWidget(resizableItemModel: ResizableItemModel(
          child: Image.file(File(image.value.path),fit: BoxFit.cover),deleteItem: deleteItem,
            bringToFront: bringToFront
        ),)
    );
    // texts.add(
    //   ResizableWidget(resizableItemModel: ResizableItemModel(
    //       child: Image.file(File(image.value.path),fit: BoxFit.contain))
    //   ),);
  }

}