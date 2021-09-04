import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/models/palette_hue_picker_page.dart';
import 'package:myapp/models/resizable_item_model.dart';
import 'package:myapp/widgets/frame_widget.dart';
import 'package:myapp/widgets/resizable_widget.dart';
import 'package:path_provider/path_provider.dart';
class HomePageController extends GetxController{
  RxInt selectedIndex = 0.obs;
  var texts = <Widget>[].obs;
  TextEditingController textEditingController = TextEditingController();
  Rx<Color> currentColor = Colors.black.obs;
  RxInt selectedStackIndex = 0.obs;
  ImagePicker _picker = ImagePicker();
  Rx<XFile> image = XFile("").obs;
  Rx<XFile> frame = XFile("").obs;
  GlobalKey globalKey = new GlobalKey();
  RxString savedImagePath = "".obs;

  Future<Uint8List> saveAsImage() async {
    try {
      Directory appDocDir = await getExternalStorageDirectory();
      var filePath =
          '${appDocDir.path}/${DateTime.now().millisecondsSinceEpoch}.png';
      RenderRepaintBoundary boundary =
      globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      print(pngBytes);
      print(bs64);
      File imgFile = new File(filePath);
      imgFile.writeAsBytes(pngBytes);
      savedImagePath.value = imgFile.path;
      print(imgFile.path);
      return pngBytes;
    } catch (e) {
      print(e);
    }
  }
  onColorPicked(Color pickedColor){
    currentColor.value = pickedColor;
  }
  onMenuTapped(int index){
    switch (index){
      case 0:
        saveAsImage();
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
        break;
      case 3:
        pickFrame();
        break;
    }
    selectedIndex.value = index;
  }
  deleteItem(Widget widget){
    texts.remove(widget);
  }
  bringToFront(Widget widget){
    List<Widget> tempList = [];
    tempList.addAll(texts);
    tempList.remove(widget);

    if(texts[0] != widget) {
      texts.clear();
      texts.add(widget);
      texts.addAll(tempList);
    }
    else
      {
        texts.clear();
        texts.addAll(tempList);
        texts.add(widget);
      }
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
  pickFrame() async {
    frame.value = await _picker.pickImage(source: ImageSource.gallery);
    texts.add(FrameWidget(image: Image.file(File(frame.value.path),fit: BoxFit.cover,),
    deleteFrame: deleteItem,
      bringToFront: bringToFront,
    ));
  }
}