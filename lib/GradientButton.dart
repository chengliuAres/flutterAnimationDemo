///
/// author : danielmini
/// date : 12/29/20 3:21 PM
/// description : my_flutter_app/CustomWidget
/// Good Good Study, Day Day Up!
///
///

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  GradientButton(
  {this.colors, this.width, this.height, this.child,
      this.borderRadius, this.onPressed});

  final List<Color> colors;
  final double width;
  final double height;
  final Widget child;
  final BorderRadius borderRadius;
  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {


    return DecoratedBox(
        decoration:BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: borderRadius
        ) ,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            splashColor: colors.last,
            highlightColor: Colors.transparent,
            borderRadius: borderRadius,
            onTap: onPressed,
            child: ConstrainedBox(
              constraints: BoxConstraints.tightFor(height: height, width: width),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DefaultTextStyle(
                    style: TextStyle(fontWeight: FontWeight.bold),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ),
    );
  }
}
