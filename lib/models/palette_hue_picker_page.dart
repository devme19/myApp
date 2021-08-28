import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';

class PaletteHuePickerPage extends StatefulWidget {
  PaletteHuePickerPage({Key key,this.pickedColor,this.currentColor}) : super(key: key);
  ValueChanged<HSVColor> pickedColor;
  HSVColor currentColor ;
  @override
  _PaletteHuePickerPageState createState() => _PaletteHuePickerPageState();
}

class _PaletteHuePickerPageState extends State<PaletteHuePickerPage> {

  void onChanged(HSVColor value) {
    widget.currentColor = value;
    widget.pickedColor(value);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 260,
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(0.0),
            ),
          ),
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: widget.currentColor.toColor(),
                ),
                const Divider(),

                ///---------------------------------
                PaletteHuePicker(
                  color: widget.currentColor,
                  onChanged: (value) => super.setState(
                    () => onChanged(value),
                  ),
                )

                ///---------------------------------
              ],
            ),
          ),
        ),
      ),
    );
  }

}
