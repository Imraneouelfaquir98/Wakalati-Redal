import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This size provide as the total width and height of our screen
    Size size = MediaQuery.of(context).size;
    return Container(
        color: Colors.white,
        width: size.width,
        height: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            /*
             Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                "assets/images/main_top.png",
                width: 0.3 * size.width,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset(
                "assets/images/main_bottom.png",
                width: 0.2 * size.width,
              ),
            ),
            * */
            child,
          ],
        ));
  }
}
