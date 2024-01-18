import 'package:flutter/material.dart';
import 'package:oem_huining_anhui/screen/login_screen.dart';
import 'package:oem_huining_anhui/screen/main_screen/main_page.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

void sss() async {
  if (await Permission.manageExternalStorage.status !=
      PermissionStatus.granted) {
    // 请求权限
    Map<Permission, PermissionStatus> statuses = await [
      Permission.manageExternalStorage,
      Permission.storage,
    ].request();
    print(statuses[Permission.manageExternalStorage]); // 打印请求的权限状态
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    // Map<String, Widget> pageMap = {
    //   '/': MainPage(),
    //   '/login': Login(),
    // };
    // return GetMaterialApp.router(
    //   key: UniqueKey(),
    //   builder: Tro.init,
    //   debugShowCheckedModeBanner: false,
    //   title: 'Iot云监测平台',
    //   enableLog: false,
    //   routerDelegate: MainRouterDelegate(pageMap: pageMap),
    //   routeInformationParser: TroRouteInformationParser(),
    // );
    return MaterialApp(
      title: '安徽徽宁',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const MyHomePage(title: '安徽徽宁振动分析软件'),
      home: Login(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MainPage();
  }
}
