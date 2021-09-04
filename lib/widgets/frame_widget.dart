import 'package:flutter/material.dart';

class FrameWidget extends StatefulWidget {
  final ValueChanged<FrameWidget> deleteFrame;
  final ValueChanged<FrameWidget> bringToFront;
  final Image image;
  FrameWidget({Key key, this.deleteFrame, this.bringToFront, this.image}) : super(key: key);

  @override
  _FrameWidgetState createState() => _FrameWidgetState();
}

class _FrameWidgetState extends State<FrameWidget> {
  bool editable = true;
  @override
  Widget build(BuildContext context) {
    return
      Align(
        alignment: Alignment.center,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              editable?
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: IconButton(onPressed: (){
                        widget.deleteFrame(widget);
                      }, icon: Icon(Icons.delete,color: Colors.red,)),
                    ),
                    Expanded(child: InkWell(
                      onTap: ()=>widget.bringToFront(widget),
                      child: Image.asset('assets/icons/bring-to-front.png',height: 20,width: 20,),
                    )),
                  ],
                ),
              ):Container(
                height: 70,
              ),
              Expanded(
                child: InkWell(
                  onTap: ()=>setState(() {
                    editable = !editable;
                  }),
                    child:
                    widget.image),
              )
            ],
          ),
        ),
      );
  }
}
