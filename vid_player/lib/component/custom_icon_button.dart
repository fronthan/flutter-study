import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData iconData; //아이콘
  final GestureTapCallback onPressed; //아이콘을 눌렀을 때 실행할 함수

  const CustomIconButton({
    required this.onPressed,
    required this.iconData,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      iconSize: 30.0,
      color: Colors.white,//아이콘 색상
      icon: Icon(
        iconData
      ),
    );
  }
  
}