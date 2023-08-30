
import 'package:calculator/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class DesignedContainer extends StatelessWidget {
  final bool darkMode;
  final Widget child;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onPressed;

  DesignedContainer({
    required this.darkMode,
    required this.child,
    required this.borderRadius,
    required this.padding,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    bool _isPressed = false;

    void _onPointerDown(PointerDownEvent event) {
      _isPressed = true;
    }

    void _onPointerUp(PointerUpEvent event) {
      _isPressed = false;
    }

    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: darkMode ? colorDark : colorLight,
            borderRadius: borderRadius,
            boxShadow: _isPressed
                ? null
                : [
              BoxShadow(
                color: darkMode ? Colors.black54 : Colors.blueGrey.shade200,
                offset: Offset(0, 0),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              ),
              BoxShadow(
                color: darkMode ? Colors.blueGrey.shade700 : Colors.white,
                offset: Offset(0, 0),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

void showCustomToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Color.fromRGBO(106, 106, 108, 1),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

