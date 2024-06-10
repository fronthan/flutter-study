import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatelessWidget {
  //집의 위치
  static final LatLng homeLatLng = LatLng(
    37.45754377875688,//위도
    127.16924173103783//경도
  );

  //집의 위치 마커
  static final Marker marker = Marker(
    markerId: MarkerId('MinHouse'),//이 마커아이디는 유일해야 하며, 중복되는 값은 표시되지 않는다.
    position: homeLatLng
  );

  //반경 표시
  static final Circle circle = Circle(
    circleId: CircleId('houseCircle'), //이 값도 유일해야 한다.
    center: homeLatLng,//원의 중심이 되는 위치
    fillColor: Colors.blue.withOpacity(0.5), //원의 색상
    radius: 100, //원의 반지름 (미터 단위)
    strokeColor: Colors.blue, //원의 테두리 색상
    strokeWidth: 1,//원의 테두리 두께
  );

  const HomeScreen({Key? key}) : super(key: key);

  /** 메인 위젯 */
  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(),
      body: FutureBuilder<String>(
        future: checkPermision(),
        builder: (context, snapshot) {
          //로딩 상태
          if (!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          //권한 허가 상태
          if (snapshot.data == '위치 권한이 허가되었습니다.') {
            return Column(
              children: [
                Expanded(
                  flex: 2,// 2/3 공간 차지
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: homeLatLng,
                      zoom: 16 // 높을 수록 크게 보임
                    ),
                    myLocationEnabled: true,//내 위치 지도에 보여주기
                    markers: Set.from([marker]),
                    circles: Set.from([circle]),
                  ),
                ),
                Expanded( // 1/3 공간 차지
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(//시계 아이콘
                        Icons.timelapse_outlined,
                        color: Colors.blue, size: 50.0
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        child: Text('출근하기!'),
                        onPressed: () async {
                          final curPosition = await Geolocator.getCurrentPosition(); //현재 위치

                          final distance = Geolocator.distanceBetween(
                            curPosition.latitude,//현재 위치 위도
                            curPosition.longitude,//현재 위치 경도
                            homeLatLng.latitude,//집 위치 위도
                            homeLatLng.longitude//집 위치 경도
                          );

                          bool canCheck = distance < 100; //100 미터 이내에 있으면 출근 가능

                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: Text('출근하기'),

                                content: Text(
                                  canCheck ? '출근을 할까요?' : '출근할 수 없는 위치입니다.',
                                ),
                                actions: [
                                  TextButton(//취소 버튼 누르면 false 반환
                                    child: Text('취소'),
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                  ),
                                  
                                  if (canCheck) //출근 가능한 상태일 때만 버튼 제공
                                    TextButton(
                                      child: Text('출근하기'),
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                    ),
                                ],
                              );
                            }
                          );
                        },
                      )
                    ]
                  )
                ),
              ]
            );
          }

          //권한 없는 상태
          return Center(
            child: Text(snapshot.data.toString()),
          );
        }
      )
    );
  }

  /** 앱 바 */
  AppBar renderAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      title: Text(
        '오늘도 출첵',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  /** 퓨처 - 권한 확인 */
  Future<String> checkPermision() async {
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();//위치 서비스 활성화 여부 확인

    if (!isLocationEnabled) {//위치 서비스 활성화 안됨
      return '위치 서비스를 활성화해주세요.';
    }

    LocationPermission checkedPermission = await Geolocator.checkPermission(); //위치 권한 확인

    if (checkedPermission == LocationPermission.denied) {//위치 권한 거절됨
      checkedPermission = await Geolocator.requestPermission();//위치 권한 요청

      if (checkedPermission == LocationPermission.denied) {//위치 권한 또 거절
        return '위치 권한을 허가해주세요.';
      }
    }

    if (checkedPermission == LocationPermission.deniedForever) {//위치 권한 영구 거절 (앱에서 재요청 불가)
      return '앱의 위치 권한을 설정 앱에서 허가해주세요.';
    }

    //위의 모든 조건이 통과되면
    return '위치 권한이 허가되었습니다.';
  }
}