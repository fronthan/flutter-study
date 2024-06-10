import 'package:image_editor/component/emoticon_sticker.dart';
import 'package:image_editor/component/main_app_bar.dart';
import 'package:image_editor/component/footer.dart';
import 'package:image_editor/model/sticker_model.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}): super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? image; //선택한 이미지 저장할 변수
  Set<StickerModel> stickers = {}; //화면에 추가된 스티커를 저장할 변수
  String? selectedId; //현재 선택된 스티커 ID
  GlobalKey imgKey = GlobalKey(); //이미지로 전환할 위젯에 입력할 키값

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          renderBody(),
          Positioned(//앱바
            top: 0, left: 0, right: 0,
            child: MainAppBar(
              onPickImage: onPickImage,
              onSaveImage: onSaveImage,
              onDeleteItem: onDeleteItem
            ),
          ),

          //이미지가 선택되면 푸터 위치
          if (image != null)
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Footer(
                onEmoticonTap: onEmoticonTap,
              ),
            ),
        ],
      )
    );
  }

  /** 바디부분 렌더링 */
  Widget renderBody() {
    if (image != null) {
      //Stack 크기의 최대만큼 차지하기
      return RepaintBoundary(//위젯을 이미지로 저장하는 위젯
        key: imgKey,
        child: Positioned.fill(
          child: InteractiveViewer(//위젯 확대, 좌우 이동이 가능한 위젯
            child: Stack(
              fit: StackFit.expand, //최대로 크기 늘이기
              children: [
                Image.file(
                  File(image!.path),
                  fit: BoxFit.cover,//이미지가 부모 최대 크기만큼 차지
                ),
                ...stickers.map(
                  (sticker) => Center(
                    child: EmoticonSticker(
                      key: ObjectKey(sticker.id),
                      onTransform: () {
                        onTransform(sticker.id);
                      },
                      imgPath: sticker.imgPath,
                      isSelected: selectedId == sticker.id,
                    ),
                  ),
                ),
              ],
            )
          ),
        ),
      );
    } else {
      return Center(
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey,
          ),
          onPressed: onPickImage,
          child: Text('이미지 선택하기'),
        ),
      );
    }
  }

  /** 이미지 선택 버튼 함수 */
  void onPickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);//갤러리에서 이미지 선택

    setState(() {
      this.image = image;//선택한 이미지 XFile image에 저장하기
    });
  }

  /** 이모티콘을 선택하면 */
  void onEmoticonTap(int index) async {
    setState(() {
      stickers = {
        ...stickers,
        StickerModel(
          id: Uuid().v4(), //스티커의 고유 ID
          imgPath: 'asset/img/emoticon_$index.png',
        ),
      };
    });
  }

  /** 스티커를 선택하면 선택한 스티커로 지정 */
  void onTransform(String id) {
    setState(() {
      selectedId = id;
    });
  }  

  /** 휴지통 버튼 기능 */
  void onDeleteItem() async {
    setState(() {
      stickers = stickers.where((sticker) => sticker.id != selectedId).toSet();//선택돼있는 스티커 삭제 후 Set로 반환
    });
  }

  /** 저장 버튼 기능 */
  void onSaveImage() async {
    RenderRepaintBoundary boundary = imgKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(); //바운더리를 이미지로 변경
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);//바이트 데이터로 형태 변경

    Uint8List pngBytes = byteData!.buffer.asUint8List();//U int 8 List 형태로 변경

    await ImageGallerySaver.saveImage(pngBytes, quality: 100);//이미지 저장하기

    ScaffoldMessenger.of(context).showSnackBar(//저장 후 스낵바 보기
      const SnackBar(content: Text('저장되었습니다!')),
    );
  } 
}