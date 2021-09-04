
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
  bool editable = true;
  void onDrag(double dx, double dy) {
    var newHeight = widget.resizableItemModel.height + dy;
    var newWidth = widget.resizableItemModel.width + dx;

    setState(() {
      widget.resizableItemModel.height = newHeight > 0 ? newHeight : 0;
      widget.resizableItemModel.width = newWidth > 0 ? newWidth : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      Stack(
      children: <Widget>[

        editable?
        Positioned(
          top: widget.resizableItemModel.top-50,
          left: widget.resizableItemModel.left,
          child: Container(
            width: widget.resizableItemModel.width,
            // color: Colors.purple.withOpacity(0.3),
            child:
            Row(
              children: [
                Expanded(
                  child: IconButton(onPressed: (){
                    widget.resizableItemModel.deleteItem(widget);
                  }, icon: Icon(Icons.delete,color: Colors.red,)),
                ),
                Expanded(child: InkWell(
                  onTap: ()=>widget.resizableItemModel.bringToFront(widget),
                  child: Image.asset('assets/icons/bring-to-front.png',height: 20,width: 20,),
                )),
                Expanded(
                  child: widget.resizableItemModel.editItem != null?
                  IconButton(onPressed: (){
                    widget.resizableItemModel.editItem(widget);
                  }, icon: Icon(Icons.edit,color: Colors.green,)):Container(),
                )
              ],
            ),
          ),
        ):Container(),
        Positioned(
          top: widget.resizableItemModel.top,
          left: widget.resizableItemModel.left,
          child:
          InkWell(
            onTap: (){
              setState(() {
                editable = !editable;
              });
            },
            child: Container(
              height: widget.resizableItemModel.height,
              width: widget.resizableItemModel.width,
              color: editable? Colors.grey.withOpacity(0.3):Colors.transparent,
              child: FittedBox(child: widget.resizableItemModel.child,fit: BoxFit.contain,),
            ),
          ),
        ),
        // top left
        editable?Positioned(
          top: widget.resizableItemModel.top - ballDiameter / 2,
          left: widget.resizableItemModel.left - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var mid = (dx + dy) / 2;
              var newHeight = widget.resizableItemModel.height - 2 * mid;
              var newWidth = widget.resizableItemModel.width - 2 * mid;

              setState(() {
                widget.resizableItemModel.height = newHeight > 0 ? newHeight : 0;
                widget.resizableItemModel.width = newWidth > 0 ? newWidth : 0;
                widget.resizableItemModel.top = widget.resizableItemModel.top + mid;
                widget.resizableItemModel.left = widget.resizableItemModel.left + mid;
              });
            },
          ),
        ):Container(),
        // top middle
        editable?Positioned(
          top: widget.resizableItemModel.top - ballDiameter / 2,
          left: widget.resizableItemModel.left + widget.resizableItemModel.width / 2 - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var newHeight = widget.resizableItemModel.height - dy;

              setState(() {
                widget.resizableItemModel.height = newHeight > 0 ? newHeight : 0;
                widget.resizableItemModel.top = widget.resizableItemModel.top + dy;
              });
            },
          ),
        ):Container(),
        // top right
        editable?Positioned(
          top: widget.resizableItemModel.top - ballDiameter / 2,
          left: widget.resizableItemModel.left + widget.resizableItemModel.width - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var mid = (dx + (dy * -1)) / 2;

              var newHeight = widget.resizableItemModel.height + 2 * mid;
              var newWidth = widget.resizableItemModel.width + 2 * mid;

              setState(() {
                widget.resizableItemModel.height = newHeight > 0 ? newHeight : 0;
                widget.resizableItemModel.width = newWidth > 0 ? newWidth : 0;
                widget.resizableItemModel.top = widget.resizableItemModel.top - mid;
                widget.resizableItemModel.left = widget.resizableItemModel.left - mid;
              });
            },
          ),
        ):Container(),
        // center right
        editable?Positioned(
          top: widget.resizableItemModel.top + widget.resizableItemModel.height / 2 - ballDiameter / 2,
          left: widget.resizableItemModel.left + widget.resizableItemModel.width - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var newWidth = widget.resizableItemModel.width + dx;

              setState(() {
                widget.resizableItemModel.width = newWidth > 0 ? newWidth : 0;
              });
            },
          ),
        ):Container(),
        // bottom right
        editable?Positioned(
          top: widget.resizableItemModel.top + widget.resizableItemModel.height - ballDiameter / 2,
          left: widget.resizableItemModel.left + widget.resizableItemModel.width - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var mid = (dx + dy) / 2;

              var newHeight = widget.resizableItemModel.height + 2 * mid;
              var newWidth = widget.resizableItemModel.width + 2 * mid;

              setState(() {
                widget.resizableItemModel.height = newHeight > 0 ? newHeight : 0;
                widget.resizableItemModel.width = newWidth > 0 ? newWidth : 0;
                widget.resizableItemModel.top = widget.resizableItemModel.top - mid;
                widget.resizableItemModel.left = widget.resizableItemModel.left - mid;
              });
            },
          ),
        ):Container(),
        // bottom center
        editable?Positioned(
          top: widget.resizableItemModel.top + widget.resizableItemModel.height - ballDiameter / 2,
          left: widget.resizableItemModel.left + widget.resizableItemModel.width / 2 - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var newHeight = widget.resizableItemModel.height + dy;

              setState(() {
                widget.resizableItemModel.height = newHeight > 0 ? newHeight : 0;
              });
            },
          ),
        ):Container(),
        // bottom left
        editable?Positioned(
          top: widget.resizableItemModel.top + widget.resizableItemModel.height - ballDiameter / 2,
          left: widget.resizableItemModel.left - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var mid = ((dx * -1) + dy) / 2;

              var newHeight = widget.resizableItemModel.height + 2 * mid;
              var newWidth = widget.resizableItemModel.width + 2 * mid;

              setState(() {
                widget.resizableItemModel.height = newHeight > 0 ? newHeight : 0;
                widget.resizableItemModel.width = newWidth > 0 ? newWidth : 0;
                widget.resizableItemModel.top = widget.resizableItemModel.top - mid;
                widget.resizableItemModel.left = widget.resizableItemModel.left - mid;
              });
            },
          ),
        ):Container(),
        //left center
        editable?Positioned(
          top: widget.resizableItemModel.top + widget.resizableItemModel.height / 2 - ballDiameter / 2,
          left: widget.resizableItemModel.left - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var newWidth = widget.resizableItemModel.width - dx;

              setState(() {
                widget.resizableItemModel.width = newWidth > 0 ? newWidth : 0;
                widget.resizableItemModel.left = widget.resizableItemModel.left + dx;
              });
            },
          ),
        ):Container(),
        // center center
        editable?Positioned(
          top: widget.resizableItemModel.top + widget.resizableItemModel.height / 2 - ballDiameter / 2,
          left: widget.resizableItemModel.left + widget.resizableItemModel.width / 2 - ballDiameter / 2,
          child: ManipulatingBall(
            isMove: true,
            onDrag: (dx, dy) {
              setState(() {
                widget.resizableItemModel.top = widget.resizableItemModel.top + dy;
                widget.resizableItemModel.left = widget.resizableItemModel.left + dx;
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