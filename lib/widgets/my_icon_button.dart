import 'package:flutter/material.dart';


class MyIconButton extends StatefulWidget {
  IconData buttonIcon;
  Color? buttonColor;
  VoidCallback onTap;
  Color? iconColor;
  double? iconSize ;

  MyIconButton(
      {super.key,
        this.buttonColor = Colors.black12,
        this.iconColor = Colors.white,
        required this.buttonIcon,
        this.iconSize = 30 ,
        required this.onTap});

  @override
  State<MyIconButton> createState() => _MyIconButtonState();
}

class _MyIconButtonState extends State<MyIconButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      onPressed: widget.onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      backgroundColor: widget.buttonColor,
      child: Icon(
        widget.buttonIcon,
        size: widget.iconSize,
        color: widget.iconColor,
      ),
    );
  }
}

/// this is my icon button
