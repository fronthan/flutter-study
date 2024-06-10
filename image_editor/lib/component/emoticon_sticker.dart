import 'package:flutter/material.dart';

/** 스티커를 그리는 위젯 */
class EmoticonSticker extends StatefulWidget {
  final VoidCallback onTransform;
  final String imgPath; //이미지 경로
  final bool isSelected;

  const EmoticonSticker({
    required this.onTransform,
    required this.imgPath,
    required this.isSelected,
    Key? key
  }) : super(key: key);

  @override
  State<EmoticonSticker> createState() => _EmoticonSticker();
}

class _EmoticonSticker extends State<EmoticonSticker> {
  double scale = 1; //확대 축소 비율
  double hTransform = 0; //가로 움직임
  double vTransform = 0; //세로 움직임
  double actualScale = 1; //위젯의 초기 크기 기준 확대,축소 배율

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..translate(hTransform, vTransform) //상,하 움직임 정의
        ..scale(scale, scale), //확대, 축소 정의

      child: Container(
        decoration: widget.isSelected ? BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            color: Colors.blue, width: 1.0,
          ),
        ) : BoxDecoration(
          border: Border.all(
            width: 1.0, color: Colors.transparent
          ),
        ),

        child: GestureDetector(
          onTap: () {//스티커 상태가 변경될 때마다 실행
            widget.onTransform();
          },
          onScaleUpdate: (ScaleUpdateDetails details) {//스티커 확대 비율이 변경됐을 때 실행
            widget.onTransform();
            setState(() {
              scale = details.scale * actualScale; //최근 확대 비율 기반으로 실제 확대 비율 계산
              vTransform += details.focalPointDelta.dy; //세로 이동 거리 계산
              hTransform += details.focalPointDelta.dx; //가로 이동 거리 계산
            });
          },
          onScaleEnd: (ScaleEndDetails details) {//
            actualScale = scale;//확대 비율 저장
          },
          
          child: Image.asset(
            widget.imgPath
          ),
        ),
      ),
    );
  }
}