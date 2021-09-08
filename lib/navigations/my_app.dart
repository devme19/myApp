import 'package:get/get.dart';
import 'package:myapp/bindings/home_page_binding.dart';
import 'package:myapp/bindings/main_page_binding.dart';
import 'package:myapp/pages/home_page.dart';
import 'package:myapp/pages/main_page.dart';

class MyAppRoutes{
  static final String homePage = "/homePage";
  static final String mainPage = "/mainPage";
}
class MyApp1{
  static final pages=[
    // GetPage(name: MyAppRoutes.homePage, page: ()=>HomePage(),binding: HomePageBinding()),
    GetPage(name: MyAppRoutes.homePage, page: ()=> HomePage(),binding: HomePageBinding()),
    GetPage(name: MyAppRoutes.mainPage, page: ()=> MainPage(),binding: MainPageBinding()),
  ];
}