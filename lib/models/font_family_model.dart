// class FontFamilyModel{
//   List<String> fontFamily=[
//     'assets/fonts/IRANYekanMobileLight.ttf',
//     'assets/fonts/IRANYekanMobileRegular.ttf',
//   ];
//   FontFamilyModel({this.fontFamily});
//   FontFamilyModel.fromJson(Map<String, dynamic> json){
//     fontFamily = json['fontFamily']!= null ?json['fontFamily'].cast<String>():null;
//   }
//   Map<String, dynamic> toJson(){
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['fontFamily'] = this.fontFamily;
//     return data;
//   }
// }

class FontFamilyModel{

  static final FontFamilyModel _fontFamilyModel = FontFamilyModel._internal();

  factory FontFamilyModel() {
    return _fontFamilyModel;
  }
  List<String> fontFamily=[
    'fontFamily1',
    'fontFamily2',
    'fontFamily3',
    'fontFamily4',
    'fontFamily5',
    'fontFamily6',
  ];
  FontFamilyModel._internal();

}