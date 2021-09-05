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
import 'package:myapp/widgets/resizable_widgett.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
class HomePageController extends GetxController{
  RxInt selectedIndex = 0.obs;
  var layout = <ResizableWidget>[].obs;
  var reorderList=<Widget>[].obs;
  TextEditingController textEditingController = TextEditingController();
  Rx<Color> currentColor = Colors.black.obs;
  RxInt selectedStackIndex = 0.obs;
  ImagePicker _picker = ImagePicker();
  Rx<XFile> image = XFile("").obs;
  Rx<XFile> frame = XFile("").obs;
  GlobalKey globalKey = new GlobalKey();
  String savedImagePath = "";
  ResizableWidget frameWidget;

  Future<String> createFolder() async {
    Directory myDirectory;
    if (await Permission.storage.request().isGranted) {
      myDirectory =  Directory('/storage/emulated/0/MyApp');

      if(await myDirectory.exists()){ //if folder already exists return path
        return myDirectory.path;
      }else{//if folder not exists create folder and then return its path
        myDirectory=await myDirectory.create(recursive: true);
        return myDirectory.path;
      }
    }

  }
  List<Widget> reorderableList(){
    reorderList.clear();
    for(int i=0;i < layout.length; i++)
      reorderList.add(
          Card(
              key: ValueKey(layout[i]),
              child: ListTile(
                onTap: (){
                  layout[i].isSelected();
                },
                leading: InkWell(
                    onTap: (){
                      reorderList.remove(layout[i]);
                      layout.remove(layout[i]);
                    },
                    child: Icon(Icons.delete,color: Colors.red,)),
                title: Text(layout[i].toString()),)));

    return reorderList;
  }
  void reorderData(int oldIndex, int newIndex){
    if(newIndex>oldIndex){
      newIndex-=1;
    }
    final items =reorderList.removeAt(oldIndex);
    final widget = layout.removeAt(oldIndex);
    layout.insert(newIndex, widget);
    reorderList.insert(newIndex, items);
  }
  saveAsImage() async {
    savedImagePath = await createFolder();
     if(savedImagePath != "" && savedImagePath != null)
       {
         try{
           var filePath =
               '$savedImagePath/${DateTime.now().millisecondsSinceEpoch}.png';
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
           print(imgFile.path);
         }catch(e){
         }
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
                          layout.add(
                              new ResizableWidget(
                            resizableItemModel: ResizableItemModel(
                              isSelected: true,
                                child: Text(textEditingController.text,style: TextStyle(color: currentColor.value),),
                                title: textEditingController.text,
                                color: currentColor.value,
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
    layout.remove(widget);
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
                      for(int i=0;i<layout.length;i++)
                        if(layout[i] == widget)
                          {
                            layout[i] = ResizableWidget(
                              resizableItemModel: ResizableItemModel(
                                isSelected: false,
                                  child: Text(textEditingController.text,style: TextStyle(color: currentColor.value),),
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
    layout.add(
        new ResizableWidget(resizableItemModel: ResizableItemModel(
          isSelected: true,
          child: Image.file(File(image.value.path)),
        ),)
    );
    // texts.add(
    //   ResizableWidget(resizableItemModel: ResizableItemModel(
    //       child: Image.file(File(image.value.path),fit: BoxFit.contain))
    //   ),);
  }
  pickFrame() async {
    frame.value = await _picker.pickImage(source: ImageSource.gallery);
    if(frame.value != null) {
      if(frameWidget != null)
        deleteItem(frameWidget);
      frameWidget = new ResizableWidget(
        resizableItemModel: ResizableItemModel(
          isSelected: false,
          isFrame: true,
          child:Image.file(File(frame.value.path))
      ),);
      layout.add(frameWidget);
    }

  }
}