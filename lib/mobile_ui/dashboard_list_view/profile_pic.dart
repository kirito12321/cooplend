import 'dart:io';

import 'package:ascoop/services/database/data_service.dart';
import 'package:ascoop/style.dart';
import 'package:ascoop/utilities/show_alert_dialog.dart';
import 'package:ascoop/utilities/show_confirmation_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicSet extends StatefulWidget {
  const ProfilePicSet({super.key});

  @override
  State<ProfilePicSet> createState() => _ProfilePicSetState();
}

class _ProfilePicSetState extends State<ProfilePicSet> {
  XFile? _pickedFile;
  CroppedFile? _croppedFile;
  UploadTask? uploadTask;
  String? path;
  String? imageUrl;
  _saveImage(String userId) async {
    if (_croppedFile == null) {
      return;
    }

    final path = '/users/$userId/subscriptions/${_pickedFile!.name}';
    final file = File(_croppedFile!.path);

    final ref = FirebaseStorage.instance.ref().child(path);

    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {
      setState(() {
        uploadTask = null;
      });
    });

    imageUrl = await snapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.black,
          ),
          title: const Text(
            'Profile Picture',
            style: dashboardMemberTextStyle,
          ),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Image(
                  image: AssetImage('assets/images/cooplendlogo.png')),
              padding: const EdgeInsets.all(2.0),
              iconSize: screenWidth * 0.4,
              onPressed: () {},
            )
          ],
        ),
        body: SizedBox(
          height: screenHeight,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: screenHeight * 0.1,
              ),
              SizedBox(
                height: 200,
                width: 200,
                child: CircleAvatar(
                  backgroundColor: Colors.white30,
                  backgroundImage: _croppedFile != null
                      ? FileImage(File(_croppedFile!.path))
                      : null,
                  child: _croppedFile != null
                      ? null
                      : const Icon(Icons.add_a_photo_outlined),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildUploadProgress(),
              ),
              SizedBox(
                height: screenHeight * 0.1,
              ),
              _pickedFile != null || _croppedFile != null
                  ? _saveBtn(arguments['userId'])
                  : _uploadBtn()
            ],
          ),
        ));
  }

  void _cropImage() async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        cropStyle: CropStyle.circle,
        aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3),
        uiSettings: [
          AndroidUiSettings(
              cropFrameColor: Colors.transparent,
              toolbarTitle: 'Cropper',
              toolbarColor: const Color.fromARGB(255, 32, 207, 208),
              toolbarWidgetColor: Colors.white,
              showCropGrid: false,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 520,
              height: 520,
            ),
            viewPort:
                const CroppieViewPort(width: 480, height: 480, type: 'circle'),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
          ),
        ],
      ).onError((error, stackTrace) => null);
      if (croppedFile != null) {
        setState(() {
          _croppedFile = croppedFile;
        });
      }
    }
  }

  void _uploadImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
      _cropImage();
    }
  }

  Widget _uploadBtn() {
    return SizedBox(
      height: 60,
      width: 350,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.image_outlined),
        label: const Text('Browse Image'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 32, 207, 208),
          shape: const StadiumBorder(),
        ),
        onPressed: _uploadImage,
      ),
    );
  }

  Widget _saveBtn(String userId) {
    return SizedBox(
      height: 60,
      width: 350,
      child: ElevatedButton.icon(
          icon: const Icon(Icons.save_outlined),
          label: const Text('Save'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 32, 207, 208),
            shape: const StadiumBorder(),
          ),
          onPressed: () async {
            ShowConfirmationDialog(
                    context: context,
                    title: 'Save Changes',
                    body: 'Are you sure you want to save it.',
                    fBtnName: 'Yes',
                    sBtnName: 'No')
                .showConfirmationDialog()
                .then((value) {
              if (value == true) {
                _saveImage(userId).then((value) => DataService.database()
                    .changeProfilePic(path: imageUrl!)
                    .then((value) => ShowAlertDialog(
                                context: context,
                                title: 'Saved',
                                body: '',
                                btnName: 'ok')
                            .showAlertDialog()
                            .then((result) {
                          if (result == true) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/dashboard/', (route) => false);
                          }
                        })));
              }
            });
          }),
    );
  }

  Widget buildUploadProgress() => StreamBuilder<TaskSnapshot>(
        stream: uploadTask?.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            double progress = data.bytesTransferred / data.totalBytes;

            return progressIndicator(progress);
          } else {
            return const SizedBox(
              height: 10,
            );
          }
        },
      );

  Widget progressIndicator(double progress) {
    if (progress * 100 >= 100) {
      return const SizedBox(
        height: 10,
      );
    } else {
      return SizedBox(
        height: 20,
        child: Stack(
          fit: StackFit.expand,
          children: [
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey,
              color: Colors.green,
            ),
            Center(
              child: Text(
                '${(100 * progress).roundToDouble()}%',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }
  }
}
