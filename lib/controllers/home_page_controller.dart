import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:dynamic_cached_fonts/dynamic_cached_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/models/font_family_model.dart';
import 'package:myapp/models/palette_hue_picker_page.dart';
import 'package:myapp/models/project_model.dart';
import 'package:myapp/models/resizable_item_model.dart';
import 'package:myapp/models/state_status.dart';
import 'package:myapp/widgets/resizable_widget.dart';
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
  RxBool showSaveContainer = false.obs;
  GetStorage box = GetStorage();
  String projectTitle ="";
  RxString selectedFontFamily="fontFamily1".obs;
  RxInt selectedFontFamilyIndex = 0.obs;
  var saveStatus = StateStatus.INITIAL.obs;

  loadProject(ProjectModel project){
    imageCount = 0;

    projectTitle = project.title;
    for(int i=0;i<project.items.length; i++){
      if(project.items[i].isImage && !project.items[i].isFrame)
        imageCount++;
      keys.add(GlobalKey());
      layout.add(ResizableWidget(
        key: keys[i],
        resizableItemModel: ResizableItemModel(
          width: project.items[i].width,
          height: project.items[i].height,
          isFrame:project.items[i].isFrame,
          isImage: project.items[i].isImage,
          top: project.items[i].top,
          left: project.items[i].left,
          title: project.items[i].title,
          imagePath: project.items[i].imagePath,
          color: project.items[i].color,
          fontFamily: project.items[i].fontFamily,
          colorStr: project.items[i].colorStr,
          child: project.items[i].isImage? Image.file(File(project.items[i].imagePath))
              : Text(
            project.items[i].title,
            style: TextStyle(
              fontFamily: project.items[i].fontFamily,
                color: project.items[i].color!=null?project.items[i].color:Colors.black),
          ),
        ),
      ));
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
  saveProject()async{
    showSaveContainer.value = false;
    TextEditingController textEditingController = TextEditingController();
    textEditingController.text = projectTitle;
    Get.bottomSheet(
      Container(
        height: 100,
        color: Colors.white,
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(child: TextField(
              controller: textEditingController,
            )),
            IconButton(onPressed: () async{
              saveStatus.value = StateStatus.LOADING;
              Get.back();
              String projectCoverImagePath = await saveAsImage(false);
              ProjectModel projectModel = ProjectModel(title: textEditingController.text,layouts: layout,projectCoverImagePath: projectCoverImagePath);
              box.write(projectModel.title,jsonEncode(projectModel));
              saveStatus.value = StateStatus.SUCCESS;
              Get.snackbar('', 'پروژه ذخیره شد');
            }, icon: Icon(Icons.save,color: Colors.purple,))
          ],
        ),
      )
    );
  }
  Future<String> saveAsImage(bool saveImage) async {
    saveStatus.value = StateStatus.LOADING;
    showSaveContainer.value = false;
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
           saveStatus.value = StateStatus.SUCCESS;
           if(saveImage)
             Get.defaultDialog(
               title: 'عکس در مسیر زیر ذخیره شد',
               content: Text(filePath),
               actions: [
                 InkWell(
                   child: Text('باز شود'),
                   onTap: (){
                     Get.back();
                     Get.dialog(
                         PhotoView(
                           imageProvider: FileImage(File(filePath)),
                         )
                     );
                   },
                 )
               ],
             );
           return imgFile.path;

         }catch(e){
         }
    }
  }
  onColorPicked(Color pickedColor){
    currentColor.value = pickedColor;
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
                              style: TextStyle(color: currentColor.value,fontFamily: layout[i].resizableItemModel.fontFamily),
                              controller: textEditingController,
                            ),
                          ),
                          SizedBox(width: 16.0,),
                          InkWell(
                            onTap: ()=>Get.dialog(
                                PaletteHuePickerPage(pickedColor:(pickedColor){
                                  setState(()=>currentColor.value = pickedColor);
                                },currentColor: currentColor.value,)
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
                                          setState(()=> selectedFontFamilyIndex.value = index);
                                          // controller.selectedFontFamilyIndex.value = index;
                                          selectedFontFamily.value = FontFamilyModel().fontFamily[index];
                                        },
                                        child: Container(
                                            color: selectedFontFamilyIndex.value == index?Colors.grey.withOpacity(0.4):Colors.grey.withOpacity(0.1),
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
                                  if(textEditingController.text.isNotEmpty)
                                  {
                                    Get.back();
                                    // keys.add(new GlobalKey());
                                    layout[i] = ResizableWidget(
                                      key: keys[i],
                                      resizableItemModel: ResizableItemModel(
                                          width: layout[i].resizableItemModel.width,
                                          height: layout[i].resizableItemModel.height,
                                          isFrame: false,
                                          isImage: false,
                                          imagePath: layout[i].resizableItemModel.imagePath,
                                          top: layout[i].resizableItemModel.top,
                                          left: layout[i].resizableItemModel.left,
                                          child: Text(
                                            textEditingController.text,
                                            style: TextStyle(color: currentColor.value),
                                          ),
                                          color: currentColor.value,
                                          fontFamily: selectedFontFamily.value,
                                          colorStr: '0x${currentColor.value.value.toRadixString(16)}',
                                          title: textEditingController.text),
                                    );
                                    textEditingController.clear();
                                    layout.add(
                                        new ResizableWidget(
                                          key: keys.last,
                                          resizableItemModel: ResizableItemModel(
                                            isSelected: true,
                                            isImage: false,
                                            fontFamily: selectedFontFamily.value,
                                            child: Text(textEditingController.text,style: TextStyle(color: currentColor.value,fontFamily: selectedFontFamily.value),),
                                            title: textEditingController.text,
                                            color: currentColor.value,
                                            colorStr: '0x${currentColor.value.value.toRadixString(16)}',
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
                              child: Text('ویرایش'),
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
      // Get.bottomSheet(Container(
      //   height: 200,
      //   padding: EdgeInsets.all(16.0),
      //   color: Colors.white,
      //   child: SingleChildScrollView(
      //     child: Column(
      //       children: [
      //         Row(
      //           children: [
      //             Expanded(
      //               child: TextField(
      //                 maxLines: null,
      //                 // textInputAction: TextInputAction.done,
      //                 style: TextStyle(color: currentColor.value),
      //                 controller: textEditingController,
      //               ),
      //             ),
      //             SizedBox(
      //               width: 16.0,
      //             ),
      //             InkWell(
      //               onTap: () => Get.dialog(PaletteHuePickerPage(
      //                 pickedColor: onColorPicked,
      //                 currentColor: currentColor.value,
      //               )),
      //               child: Image.asset(
      //                 'assets/icons/color-picker.png',
      //                 width: 30,
      //                 height: 30,
      //               ),
      //             )
      //           ],
      //         ),
      //         ElevatedButton(
      //             style: ElevatedButton.styleFrom(
      //                 primary: Colors.deepPurple,
      //                 shape: new RoundedRectangleBorder(
      //                   borderRadius: new BorderRadius.circular(10.0),
      //                 )),
      //             onPressed: () {
      //               Get.back();
      //               layout[i] = ResizableWidget(
      //                 key: keys[i],
      //                 resizableItemModel: ResizableItemModel(
      //                     width: layout[i].resizableItemModel.width,
      //                     height: layout[i].resizableItemModel.height,
      //                     isFrame: false,
      //                     isImage: false,
      //                     imagePath: layout[i].resizableItemModel.imagePath,
      //                     top: layout[i].resizableItemModel.top,
      //                     left: layout[i].resizableItemModel.left,
      //                     child: Text(
      //                       textEditingController.text,
      //                       style: TextStyle(color: currentColor.value),
      //                     ),
      //                     color: currentColor.value,
      //                     colorStr: '0x${currentColor.value.value.toRadixString(16)}',
      //                     title: textEditingController.text),
      //               );
      //               textEditingController.clear();
      //             },
      //             child: Padding(
      //               padding: const EdgeInsets.all(8.0),
      //               child: Text('ویرایش'),
      //             ))
      //       ],
      //     ),
      //   ),
      // ));
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
            isFrame: false,
            // width: layout[i].resizableItemModel.width,
            // height: layout[i].resizableItemModel.height,
            // top: layout[i].resizableItemModel.top,
            // left: layout[i].resizableItemModel.left,
            imagePath: image.value.path,
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
             imagePath: layout[i].resizableItemModel.imagePath,
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
              imagePath: frame.value.path,
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
              imagePath: frame.value.path,
              child: Image.file(File(frame.value.path))),
        );
        layout.add(frameWidget);
      }
    }

  }
}