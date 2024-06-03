import 'package:flutter/material.dart';
import 'package:random_dice/const/colors.dart';

class SettingsScreen extends StatelessWidget {
  final double threshold; //Slider 현재값
  final ValueChanged<double> onThresholdChange;

  const SettingsScreen({
    Key? key,
    //threshold 와 onThresholdChange 는 SettingsScreen 에서 입력
    required this.threshold,
    required this.onThresholdChange
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(children: [
            Text('민감도', style: TextStyle(color: secondaryColor, fontSize: 20.0, fontWeight: FontWeight.w700))
          ])
        ),
        Slider(
          min: 0.1, max: 10.0,
          divisions: 101,//최솟값과 최댓값 사이 구간 갯수. 이동할 때마다 0.1씩 변경
          value: threshold,
          onChanged: onThresholdChange,
          label: threshold.toStringAsFixed(1), //표시값. 소수점 1자리까지 표현
        )
      ],
    ); 
  }
}