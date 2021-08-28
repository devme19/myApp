
import 'package:flutter/material.dart';
import 'package:myapp/models/resizable_item_model.dart';
class ResizableWidget extends StatefulWidget {

  ResizableWidget({this.resizableItemModel});
  final ResizableItemModel resizableItemModel;
  @override
  _ResizableWidgetState createState() => _ResizableWidgetState();
}

const ballDiameter = 30.0;

class _ResizableWidgetState extends State<ResizableWidget> {
  double height = 50;
  double width = 100;

  double top = 0;
  double left = 0;
  bool editable = true;
  void onDrag(double dx, double dy) {
    var newHeight = height + dy;
    var newWidth = width + dx;

    setState(() {
      height = newHeight > 0 ? newHeight : 0;
      width = newWidth > 0 ? newWidth : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      Stack(
      children: <Widget>[

        editable?
        Positioned(
          top: top-50,
          left: left,
          child: Container(
            width: width,
            // color: Colors.purple.withOpacity(0.3),
            child: Row(
              children: [
                Expanded(
                  child: IconButton(onPressed: (){
                    widget.resizableItemModel.deleteItem(widget);
                  }, icon: Icon(Icons.delete,color: Colors.red,)),
                ),
                
                Expanded(
                  child: IconButton(onPressed: (){
                    widget.resizableItemModel.editItem(widget);
                  }, icon: Icon(Icons.edit,color: Colors.green,)),
                )
              ],
            ),
          ),
        ):Container(),
        Positioned(
          top: top,
          left: left,
          child:
          InkWell(
            onTap: (){
              setState(() {
                editable = !editable;
              });
            },
            child: Container(
              height: height,
              width: width,
              color: editable? Colors.grey.withOpacity(0.3):Colors.transparent,
              child: FittedBox(child: widget.resizableItemModel.child,),
            ),
          ),
        ),
        // top left
        editable?Positioned(
          top: top - ballDiameter / 2,
          left: left - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var mid = (dx + dy) / 2;
              var newHeight = height - 2 * mid;
              var newWidth = width - 2 * mid;

              setState(() {
                height = newHeight > 0 ? newHeight : 0;
                width = newWidth > 0 ? newWidth : 0;
                top = top + mid;
                left = left + mid;
              });
            },
          ),
        ):Container(),
        // top middle
        editable?Positioned(
          top: top - ballDiameter / 2,
          left: left + width / 2 - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var newHeight = height - dy;

              setState(() {
                height = newHeight > 0 ? newHeight : 0;
                top = top + dy;
              });
            },
          ),
        ):Container(),
        // top right
        editable?Positioned(
          top: top - ballDiameter / 2,
          left: left + width - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var mid = (dx + (dy * -1)) / 2;

              var newHeight = height + 2 * mid;
              var newWidth = width + 2 * mid;

              setState(() {
                height = newHeight > 0 ? newHeight : 0;
                width = newWidth > 0 ? newWidth : 0;
                top = top - mid;
                left = left - mid;
              });
            },
          ),
        ):Container(),
        // center right
        editable?Positioned(
          top: top + height / 2 - ballDiameter / 2,
          left: left + width - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var newWidth = width + dx;

              setState(() {
                width = newWidth > 0 ? newWidth : 0;
              });
            },
          ),
        ):Container(),
        // bottom right
        editable?Positioned(
          top: top + height - ballDiameter / 2,
          left: left + width - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var mid = (dx + dy) / 2;

              var newHeight = height + 2 * mid;
              var newWidth = width + 2 * mid;

              setState(() {
                height = newHeight > 0 ? newHeight : 0;
                width = newWidth > 0 ? newWidth : 0;
                top = top - mid;
                left = left - mid;
              });
            },
          ),
        ):Container(),
        // bottom center
        editable?Positioned(
          top: top + height - ballDiameter / 2,
          left: left + width / 2 - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var newHeight = height + dy;

              setState(() {
                height = newHeight > 0 ? newHeight : 0;
              });
            },
          ),
        ):Container(),
        // bottom left
        editable?Positioned(
          top: top + height - ballDiameter / 2,
          left: left - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var mid = ((dx * -1) + dy) / 2;

              var newHeight = height + 2 * mid;
              var newWidth = width + 2 * mid;

              setState(() {
                height = newHeight > 0 ? newHeight : 0;
                width = newWidth > 0 ? newWidth : 0;
                top = top - mid;
                left = left - mid;
              });
            },
          ),
        ):Container(),
        //left center
        editable?Positioned(
          top: top + height / 2 - ballDiameter / 2,
          left: left - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var newWidth = width - dx;

              setState(() {
                width = newWidth > 0 ? newWidth : 0;
                left = left + dx;
              });
            },
          ),
        ):Container(),
        // center center
        editable?Positioned(
          top: top + height / 2 - ballDiameter / 2,
          left: left + width / 2 - ballDiameter / 2,
          child: ManipulatingBall(
            isMove: true,
            onDrag: (dx, dy) {
              setState(() {
                top = top + dy;
                left = left + dx;
              });
            },
          ),
        ):Container(),
      ],
    );
  }
}

class ManipulatingBall extends StatefulWidget {
  ManipulatingBall({Key key, this.onDrag,this.isMove=false});
  bool isMove;
  final Function onDrag;

  @override
  _ManipulatingBallState createState() => _ManipulatingBallState();
}

class _ManipulatingBallState extends State<ManipulatingBall> {
  double initX;
  double initY;

  _handleDrag(details) {
    setState(() {
      initX = details.globalPosition.dx;
      initY = details.globalPosition.dy;
    });
  }

  _handleUpdate(details) {

    var dx = details.globalPosition.dx - initX;
    var dy = details.globalPosition.dy - initY;
    initX = details.globalPosition.dx;
    initY = details.globalPosition.dy;
    widget.onDrag(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _handleDrag,
      onPanUpdate: _handleUpdate,
      child:
      Container(
        width: ballDiameter,
        height: ballDiameter,
        child: widget.isMove?
        Opacity(
          opacity: 0.7,
            child: Image.asset('assets/icons/move.png',color: Colors.amber,)):Container(),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}