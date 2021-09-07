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
import 'package:photo_view/photo_view.dart';
import 'package:get_storage/get_storage.dart';
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
  List<GlobalKey<ResizableWidgetState>> keys=[];
  String savedImagePath = "";
  ResizableWidget frameWidget;
  RxInt selectedItemIndex = (-1).obs;
  int imageCount=0;

  @override
  void onInit() {
    super.onInit();
    GetStorage box = GetStorage();
    int layoutLength = box.read('layoutLength');
    if(layoutLength != null)
    for(int i=0;i<layoutLength; i++){
      String layoutStr = box.read('layout$i');
      ResizableItemModel item = ResizableItemModel.fromJson(json.decode(layoutStr));
    }
  }

  onDeleteListTile(int i){
    if(layout[i].resizableItemModel is Image)
     imageCount--;
    // controller.reorderList.remove(controller.layout[i]);
    deleteItem(layout[i]);
  }
  onEditListTile(int i){
    editItem(i);
  }
  onListTileTap(int i){
    if(selectedItemIndex.value != -1)
      keys[selectedItemIndex.value].currentState.unSelect();
    selectedItemIndex.value = i;
    keys[selectedItemIndex.value].currentState.isSelect();
  }
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
    return "";

  }
  saveAsImage() async {
    savedImagePath = await createFolder();
    GetStorage box = GetStorage();
    box.write('layoutLength',layout.length);
    for(int i=0; i<layout.length;i++)
      {
        String s = jsonEncode(layout[i].resizableItemModel);
        box.write('layout$i',s );
      }
    //  if(savedImagePath != "" && savedImagePath != null)
    //    {
    //      try{
    //        var filePath =
    //            '$savedImagePath/${DateTime.now().millisecondsSinceEpoch}.png';
    //        RenderRepaintBoundary boundary =
    //        globalKey.currentContext.findRenderObject();
    //        ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    //        ByteData byteData =
    //        await image.toByteData(format: ui.ImageByteFormat.png);
    //        var pngBytes = byteData.buffer.asUint8List();
    //        var bs64 = base64Encode(pngBytes);
    //        print(pngBytes);
    //        print(bs64);
    //        File imgFile = new File(filePath);
    //        imgFile.writeAsBytes(pngBytes);
    //        print(imgFile.path);
    //        Get.defaultDialog(
    //          title: 'عکس در مسیر زیر ذخیره شد',
    //          content: Text(filePath),
    //          actions: [
    //            InkWell(
    //              child: Text('باز شود'),
    //              onTap: (){
    //                Get.dialog(
    //                    PhotoView(
    //                      imageProvider: FileImage(File(filePath)),
    //                    )
    //                );
    //              },
    //            )
    //          ],
    //        );
    //      }catch(e){
    //      }
    // }
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
        pickImageFromGallery(false,-1);
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
                          if(textEditingController.text.isNotEmpty)
                            {
                              Get.back();
                              keys.add(new GlobalKey());
                              layout.add(
                                  new ResizableWidget(
                                    key: keys.last,
                                    resizableItemModel: ResizableItemModel(
                                      isSelected: true,
                                      isImage: false,
                                      child: Text(textEditingController.text,style: TextStyle(color: currentColor.value),),
                                      title: textEditingController.text,
                                      color: currentColor.value,
                                    ),
                                  ));
                              textEditingController.clear();
                            }
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
        pickFrame(-1);
        break;
    }
    selectedIndex.value = index;
  }
  deleteItem(ResizableWidget widget){
    for(int i = 0; i<layout.length;i++)
      if(layout[i].resizableItemModel.isFrame)
      {
        keys.removeAt(i);
      }
    layout.remove(widget);
  }

  editItem(int i){
    if(layout[i].resizableItemModel.child is Image) {
      if(layout[i].resizableItemModel.isFrame)
        pickFrame(i);
      else
        pickImageFromGallery(true,i);
    }
    else {
      textEditingController.text = layout[i].resizableItemModel.title;
      currentColor.value = layout[i].resizableItemModel.color;
      Get.bottomSheet(Container(
        height: 200,
        padding: EdgeInsets.all(16.0),
        color: Colors.white,
        child: SingleChildScrollView(
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
                  SizedBox(
                    width: 16.0,
                  ),
                  InkWell(
                    onTap: () => Get.dialog(PaletteHuePickerPage(
                      pickedColor: onColorPicked,
                      currentColor: currentColor.value,
                    )),
                    child: Image.asset(
                      'assets/icons/color-picker.png',
                      width: 30,
                      height: 30,
                    ),
                  )
                ],
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      )),
                  onPressed: () {
                    Get.back();
                    layout[i] = ResizableWidget(
                      key: keys[i],
                      resizableItemModel: ResizableItemModel(
                          width: layout[i].resizableItemModel.width,
                          height: layout[i].resizableItemModel.height,
                          isFrame: false,
                          isImage: true,
                          top: layout[i].resizableItemModel.top,
                          left: layout[i].resizableItemModel.left,
                          child: Text(
                            textEditingController.text,
                            style: TextStyle(color: currentColor.value),
                          ),
                          color: currentColor.value,
                          title: textEditingController.text),
                    );
                    textEditingController.clear();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('ویرایش'),
                  ))
            ],
          ),
        ),
      ));
    }
  }
  pickImageFromGallery(bool isEdit,int i) async{
    image.value = await _picker.pickImage(source: ImageSource.gallery);
   if(image.value != null){
     if(!isEdit) {
        imageCount++;
        keys.add(GlobalKey());
        layout.add(ResizableWidget(
          key: keys.last,
          resizableItemModel: ResizableItemModel(
            isSelected: true,
            isImage: true,
            title: 'تصویر $imageCount',
            child: Image.file(File(image.value.path)),
          ),
        ));
      }
     else {
       layout[i] = ResizableWidget(
         key: keys[i],
         resizableItemModel: ResizableItemModel(
             width: layout[i].resizableItemModel.width,
             height: layout[i].resizableItemModel.height,
             isFrame: false,
             isImage: true,
             top: layout[i].resizableItemModel.top,
             left: layout[i].resizableItemModel.left,
             title: 'تصویر $imageCount',
             child: Image.file(File(image.value.path)),
             ),
       );
     }

    }
    // texts.add(
    //   ResizableWidget(resizableItemModel: ResizableItemModel(
    //       child: Image.file(File(image.value.path),fit: BoxFit.contain))
    //   ),);
  }
  pickFrame(int i) async {
    frame.value = await _picker.pickImage(source: ImageSource.gallery);

    if(frame.value != null) {
      if(frameWidget != null) {
        // deleteItem(frameWidget);
        layout[i] = ResizableWidget(
          key: keys[i],
          resizableItemModel: ResizableItemModel(
              isSelected: false,
              isFrame: true,
              isImage: true,
              title: 'قاب',
              child:Image.file(File(frame.value.path))
          ),);
      }
      else {
        keys.add(new GlobalKey());
        frameWidget = new ResizableWidget(
          key: keys.last,
          resizableItemModel: ResizableItemModel(
              isSelected: false,
              isImage: true,
              isFrame: true,
              title: 'قاب',
              child: Image.file(File(frame.value.path))),
        );
        layout.add(frameWidget);
      }
    }

  }
}