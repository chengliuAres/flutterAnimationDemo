import 'package:flutter/material.dart';
import 'package:flutter_app/GradientButton.dart';
import 'package:flutter_app/transition_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Colors.black,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: getColumn(),
        ),
      ),
    );
  }

  List<Widget> getColumn() {
    return [
      Container(
        child: Text("动画"),
      ),
      createButton('滑动动画(SlideTransition)', onTap: () {
        navigateTo(TransitionPage(pageType: PageType.PageTypeSlideDemo,));
      }),
      createButton('缩放动画(ScaleTransition)', onTap: () {
        navigateTo(TransitionPage(pageType: PageType.PageTypeScaleDemo,));
      }),
      createButton('旋转动画(RotationTransition)', onTap: () {
        navigateTo(TransitionPage(pageType: PageType.PageTypeRotateDemo,));
      }),
      createButton('渐变动画(FadeTransition)', onTap: () {
        navigateTo(TransitionPage(pageType: PageType.PageTypeFadeDemo,));
      }),
      createButton('改变value的动画', onTap: () {
        navigateTo(TransitionPage(pageType: PageType.PageTypeValueChangedDemo,));
      }),
      createButton('AnimatedWidget的动画', onTap: () {
        navigateTo(TransitionPage(pageType: PageType.PageTypeAnimatedWidgetDemo,));
      }),
      createButton('AnimatedBuilder的动画', onTap: () {
        navigateTo(TransitionPage(pageType: PageType.PageTypeAnimatedBuilderDemo,));
      }),
    ];
  }

  Widget createButton(String text, {VoidCallback onTap}) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 10),
          child: GradientButton(
            colors: [Colors.redAccent, Colors.blueGrey, Colors.black26],
            child: Text(text),
            onPressed: onTap,
          ),
        )
      ],
    );
  }

  void navigateTo(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return page;
    }));
  }
}
