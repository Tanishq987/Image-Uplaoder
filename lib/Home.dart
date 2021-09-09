import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:dio/dio.dart';
// import 'package:video_player/video_player.dart';
// import 'package:chewie/chewie.dart';
import 'package:get/get.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  File _image;
  final picker = ImagePicker();
  Offset position = Offset(330, 780);
  String uploadUrl = "https://codelime.in/api/remind-app-token";
  String result = '';

  Future<String> uploadImage(filepath, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(http.MultipartFile('image',
        File(filepath).readAsBytes().asStream(), File(filepath).lengthSync(),
        filename: filepath.split("/").last));
    var res = await request.send();
    print('$res res here');
    return res.reasonPhrase;
  }

  @override
  void initState() {
    super.initState();
    Offset position = Offset(w(330, pw), h(780, ph));
  }

  _pickimage() async {
    var res = await picker.getImage(source: ImageSource.gallery);
    if (res != null) {
      _image = File(res.path);
      setState(() {
        result = '';
      });
    }
  }

  funsnack(t1, t2, c1, i1) {
    var pw = Get.size.width;
    return Get.snackbar(
      '',
      "",
      titleText: Text(t1,
          style: TextStyle(
              fontFamily: 'cv',
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: w(19, pw))),
      messageText: Text(t2,
          style: TextStyle(
              fontFamily: "cv", fontSize: w(16, pw), color: Colors.white)),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0, top: 20.0),
      icon: Icon(
        i1,
        color: Colors.white,
        size: w(30, pw),
      ),
      backgroundColor: c1,
      shouldIconPulse: false,
      duration: const Duration(milliseconds: 1800),
    );
  }

  w(v1, pw) {
    return (pw * (v1 / 392));
  }

  h(v1, ph) {
    return (ph * (v1 / 850));
  }

  double pw = Get.size.width;
  double ph = Get.size.height;

  onWillPop() {
    funsnack(
        "Thank you ", "Have a great day ahead", Colors.orange, Icons.thumb_up);
    Future.delayed(Duration(seconds: 2), () {
      SystemNavigator.pop();
    });
  }

  bool upload = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return onWillPop();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () async {
                setState(() {
                  upload = true;
                });
                result =
                    await uploadImage(_image.path, uploadUrl).whenComplete(() {
                  setState(() {
                    upload = false;
                  });
                });
                print(result);
                if (result == 'OK') {
                  funsnack(
                      "Upload Successful",
                      "Image successfully uploaded to server",
                      Colors.orange,
                      Icons.thumb_up);
                } else {
                  funsnack(
                      "Error Occured",
                      "Please try again something went wrong",
                      Colors.red,
                      Icons.info_outline);
                }
              },
              child: Padding(
                padding: EdgeInsets.only(right: 20.0, top: 3),
                child: Icon(
                  Icons.upload_file,
                  color: Colors.white,
                  size: w(35, pw),
                ),
              ),
            )
          ],
          title: Text(
            "Image Uploader",
            style: TextStyle(
                fontSize: w(24, pw),
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: _image != null
            ? Stack(
                children: [
                  Center(child: Image.file(_image)),
                  upload
                      ? Center(
                          child: Container(
                          height: 90,
                          width: 90,
                          child: SpinKitCircle(
                            color: Colors.white,
                            size: 70,
                          ),
                          color: Colors.white.withOpacity(0.4),
                          margin: EdgeInsets.all(10),
                        ))
                      : Container(),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await _pickimage();
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(4, 3),
                                  blurRadius: 3)
                            ],
                            shape: BoxShape.circle,
                            color: Colors.orange,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(w(10.0, pw)),
                            child: Icon(Icons.image,
                                color: Colors.white, size: w(32, pw)),
                          )),
                    ),
                    SizedBox(
                      height: h(20, ph),
                    ),
                    Text(
                      "Tap to select image",
                      style: TextStyle(fontSize: w(20, pw), shadows: [
                        Shadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            offset: Offset(3, 3))
                      ]),
                    ),
                    Text(
                      "from gallery",
                      style: TextStyle(fontSize: w(18, pw), shadows: [
                        Shadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            offset: Offset(3, 3))
                      ]),
                    ),
                  ],
                ),
              ),
        floatingActionButton: SafeArea(
          child: Stack(
            children: [
              Positioned(
                left: position.dx,
                top: position.dy,
                child: Draggable(
                  childWhenDragging: Container(),
                  onDragEnd: (details) {
                    setState(() {
                      position = details.offset;
                      if (w(details.offset.dx, pw) < w(20.0, pw)) {
                        position = Offset(w(40, pw), h(details.offset.dy, ph));
                      } else if (w(details.offset.dx, pw) > w(362, pw)) {
                        position = Offset(w(330, pw), h(details.offset.dy, ph));
                      }
                      if (h(details.offset.dy, ph) < h(20.0, ph)) {
                        position = Offset(w(details.offset.dx, pw), h(40, ph));
                      } else if (h(details.offset.dy, ph) > h(800, ph)) {
                        position = Offset(w(details.offset.dx, pw), h(780, ph));
                      }
                    });
                  },
                  child: FloatingActionButton(
                    elevation: _image != null ? 5 : 0,
                    backgroundColor:
                        _image != null ? Colors.orange : Colors.transparent,
                    onPressed: () async {
                      if (_image != null) {
                        await _pickimage();
                      }
                    },
                    child: _image != null
                        ? Icon(
                            Icons.image,
                            color: Colors.white,
                            size: w(32, pw),
                          )
                        : Container(),
                  ),
                  feedback: FloatingActionButton(
                    elevation: _image != null ? 5 : 0,
                    backgroundColor:
                        _image != null ? Colors.orange : Colors.transparent,
                    onPressed: () async {
                      if (_image != null) {
                        await _pickimage();
                      }
                    },
                    child: _image != null
                        ? Icon(
                            Icons.image,
                            color: Colors.white,
                            size: w(32, pw),
                          )
                        : Container(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
