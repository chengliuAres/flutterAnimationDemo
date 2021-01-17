import 'package:flutter/material.dart';

enum PageType{
  PageTypeSlideDemo,
  PageTypeScaleDemo,
  PageTypeRotateDemo,
  PageTypeFadeDemo,
  PageTypeValueChangedDemo,
  PageTypeAnimatedWidgetDemo,
  PageTypeAnimatedBuilderDemo,
}

// ignore: must_be_immutable
class TransitionPage extends StatefulWidget {
  PageType pageType;
  TransitionPage({Key key, this.pageType = PageType.PageTypeSlideDemo})
      : super(key: key);

  @override
  _TransitionPageState createState() => _TransitionPageState();
}

class _TransitionPageState extends State<TransitionPage>
    with TickerProviderStateMixin
{

  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  Animation<double> _doubleAnimation;

  @override
  void initState() {
    super.initState();
    switch(widget.pageType){
      case PageType.PageTypeSlideDemo:
        _controller = AnimationController(vsync: this,
            duration: Duration(seconds: 1)
        );
        CurvedAnimation curvedAnimation = CurvedAnimation(
          parent: _controller,
          curve: Curves.decelerate,
        );
        _offsetAnimation = Tween(
            begin: Offset.zero,
            end: Offset(1.0,2.0)
        ).animate(curvedAnimation);
        break;

      case PageType.PageTypeScaleDemo:
        _controller = AnimationController(vsync: this,
            duration: Duration(seconds: 1)
        );
        break;
      case PageType.PageTypeRotateDemo:
        _controller = AnimationController(duration: Duration(seconds: 2),
          lowerBound: 0.0,
          upperBound: 0.5,
          vsync: this,
        );

        break;
      case PageType.PageTypeFadeDemo:
        _controller = AnimationController(duration: Duration(seconds: 2),
          vsync: this,
        );
        _doubleAnimation = Tween(begin: 0.1, end: 0.8).animate(_controller);

        break;
      case PageType.PageTypeValueChangedDemo:
        _controller = AnimationController(
          duration: Duration(seconds: 2),
          vsync: this,
        );
        _controller.addListener(() {
          //次数需要手动 刷新UI
          setState(() {

          });
        });
        _offsetAnimation = Tween(
            begin: Offset.zero,
            end: Offset(300.0,600.0)
        ).animate(_controller);
        break;
      case PageType.PageTypeAnimatedWidgetDemo:
      case PageType.PageTypeAnimatedBuilderDemo:

        _controller = AnimationController(
          duration: Duration(seconds: 2),
          vsync: this,
        );
        break;
    }

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        _controller.forward();
      }else if(status == AnimationStatus.dismissed){
        _controller.forward();
      }
    });
    _controller.forward();

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('自定义Widget'),
        actions: [
          IconButton(icon: Icon(Icons.stop), onPressed: () {
            if (_controller.isAnimating) {
              _controller.stop();
            }else{
              _controller.forward();
            }
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: getBody(),
      ),
    );
  }

  Widget getBody(){
    Widget child;
    switch(widget.pageType){
      case PageType.PageTypeSlideDemo:

        child = getSlideTransitionDemo(_offsetAnimation);
        break;

      case PageType.PageTypeScaleDemo:
        child = getScaleTransition(_controller);
        break;
      case PageType.PageTypeRotateDemo:
        child = getRotationTransition(_controller);
        break;
      case PageType.PageTypeFadeDemo:
        child = getFadeTransition(_doubleAnimation);
        break;
      case PageType.PageTypeValueChangedDemo:
        child = getValueChangeTransition(_offsetAnimation);
        break;
      case PageType.PageTypeAnimatedWidgetDemo:
        child = AnimateLogo(child: FlutterLogo(), animation: _controller,);
        break;
      case PageType.PageTypeAnimatedBuilderDemo:
        child = MultiTweenAnimation(child: FlutterLogo(),
          controller: _controller,);
        break;
    }
    return Center(
      child: child,
    );
  }

}

Widget getSlideTransitionDemo(Animation<Offset> animation){
  return Container(
    //SlideTransition 用于执行平移动画
    child: SlideTransition(
      position: animation,
      child: Container(
        width: 100,
        height: 100,
        color: Colors.red,
        child: Center(
          child: Text("tap me"),
        ),
      ),
    ),
  );
}

Widget getScaleTransition(Animation<double> animation){
  return Container(
    child: ScaleTransition(
      scale: animation,
      child: Container(
        width: 100,
        height: 100,
        color: Colors.blue,
      ),
    ),
  );
}

Widget getRotationTransition(Animation<double> animation){
  return Container(
    child: RotationTransition(
      turns: animation,
      child: Container(
        width: 100,
        height: 100,
        color: Colors.purple,
      ),
    ),
  );
}

Widget getFadeTransition(Animation<double> animation){
  return Container(
    child: FadeTransition(
      opacity: animation,
      child: Container(
        width: 100,
        height: 100,
        color: Colors.yellow,
      ),
    ),
  );
}

Widget getValueChangeTransition(Animation<Offset> animation){
  return Container(
    height: animation.value.dx,
    width: animation.value.dy,
    child: FlutterLogo(),
  );
}

//=========================   AnimatedWidget动画   =============================
/*
  通过sizeAnimation.value来获取大小，通过opacityAnimation.value来获取不透明度，
  但AnimatedWidget的构造函数只接受一个动画对象。
  为了解决这个问题，该示例创建了自己的Tween对象并显式计算了这些值。
  其build方法.evaluate()在父级的动画对象上调用Tween函数以计算,然后映射到所需的size和opacity值。
*/
class AnimateLogo extends AnimatedWidget {
  static final _opacityTween = Tween<double>(begin: 0.1, end: 1.0);
  static final _sizeTween = Tween<double>(begin: 0.0, end: 300);

  final Widget child;
  AnimateLogo({Key key, Animation<double> animation,@required this.child})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Opacity(
      opacity: _opacityTween.evaluate(animation),
      child: Container(
        height: _sizeTween.evaluate(animation),
        width: _sizeTween.evaluate(animation),
        child: child,
      ),
    );
  }
}

//=========================  AnimatedBuilder动画   =========================================
void a(){

}

class MultiTweenAnimation extends StatelessWidget {

  final AnimationController controller;
  final Animation<double> opacity;
  final Animation<double> width;
  final Animation<double> height;
  final Animation<EdgeInsets> padding;
  final Animation<BorderRadius> borderRadius;
  final Animation<Color> color;
  final Widget child;



  MultiTweenAnimation({Key key, this.controller, this.child})
      : opacity =
  Tween<double>(begin: 0.0, end: 1.0).animate(new CurvedAnimation(
      parent: controller,
      curve: Interval(
        0.0,
        0.1,
        curve: Curves.ease,
      ))),
        width = Tween<double>(begin: 50.0, end: 150.0).animate(CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.1,
              1.0,
              curve: Curves.bounceInOut,
            ))),
        height = Tween<double>(
          begin: 50.0,
          end: 200.0,
        ).animate(CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.1,
              1.0,
              curve: Curves.bounceInOut,
            ))),
        padding = Tween<EdgeInsets>(
          begin: EdgeInsets.all(10.0),
          end: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        ).animate(CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.250,
              0.375,
              curve: Curves.linear,
            ))),
        borderRadius = BorderRadiusTween(
          begin: BorderRadius.circular(10.0),
          end: BorderRadius.circular(75.0),
        ).animate(CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.1,
              1.0,
              curve: Curves.ease,
            ))),
        color = ColorTween(
          begin: Colors.blueGrey,
          end: Colors.deepOrangeAccent,
        ).animate(CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        )),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(animation: controller, builder: _buildAnimation,child: child,);
  }

  Widget _buildAnimation(BuildContext context,Widget child){
    return Container(
      padding: padding.value,
      alignment: Alignment.center,
      child: Opacity(
        opacity: opacity.value,
        child: Container(
          width: width.value,
          height: height.value,
          decoration: BoxDecoration(
            color: color.value,
            border: Border.all(
              color: Colors.black,
              width: 3.0,
            ),
            borderRadius: borderRadius.value,
          ),
          child: child,
        ),
      ),
    );
  }
}


