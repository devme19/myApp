import 'package:flutter/material.dart';
class ImageWidget extends StatefulWidget {
  ImageWidget({Key key, this.image,this.deleteImage}) : super(key: key);
  final Image image;
  final ValueChanged<ImageWidget> deleteImage;
  @override
  _ImageWidgetState createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  bool deleteIcon = true;
  @override
  Widget build(BuildContext context) {
    return
      Stack(
      children: [
        Align(
          alignment: Alignment.center,
            child: widget.image),
        deleteIcon?
        Align(
          child:
          InkWell(
            onTap: (){
              widget.deleteImage(widget);
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.withOpacity(0.5),
              ),
              child: Icon(Icons.delete,color: Colors.red,),
            ),
          ),
          alignment: Alignment.center,
        ):Container()
      ],
    );
  }
}
