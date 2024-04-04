import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../constants.dart';
import './custom_text.dart';
import '../providers/auth.dart';
import '../models/common_functions.dart';

class UserImagePicker extends StatefulWidget {
  final String? image;

  const UserImagePicker({Key? key, this.image}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _image;
  final picker = ImagePicker();
  var _isLoading = false;

  void _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  Future<void> _submitImage() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false).userImageUpload(_image!);
      CommonFunctions.showSuccessToast('Image uploaded Successfully');
    } on HttpException {
      var errorMsg = 'Upload failed.';

      CommonFunctions.showErrorDialog(errorMsg, context);
    } catch (error) {
      const errorMsg = 'Upload failed.';
      CommonFunctions.showErrorDialog(errorMsg, context);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // const Padding(
        //   padding: EdgeInsets.all(10.0),
        //   child: Align(
        //     alignment: Alignment.centerLeft,
        //     child: Customtext(
        //       text: 'Update Display Picture',
        //       colors: kTextColor,
        //       fontSize: 18,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
        const SizedBox(height: 20),
        CircleAvatar(
          radius: 50,
          backgroundImage: _image != null
              ? FileImage(_image!)
              : NetworkImage(widget.image.toString()) as ImageProvider,
          child: Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: _pickImage,
                child: const CircleAvatar(
                    maxRadius: 13,
                    backgroundColor: Color(0xff038652),
                    child: Icon(
                      Icons.add,
                      size: 16,
                    )),
              )),
        ),
        // ElevatedButton.icon(
        //   onPressed: _pickImage,
        //   style: ElevatedButton.styleFrom(
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(7.0),
        //     ),
        //     backgroundColor: kGreenColor,
        //   ),
        //   icon: const Icon(
        //     Icons.camera_alt,
        //     color: Colors.grey,
        //   ),
        //   label: const Customtext(
        //     text: 'Choose Image',
        //     fontSize: 14,
        //     colors: Colors.white,
        //   ),
        // ),
        if (_image != null)
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: _submitImage,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      backgroundColor: Color(0xff038652),
                    ),
                    icon: const Icon(
                      Icons.file_upload,
                      color: Colors.white,
                    ),
                    label: const Customtext(
                      text: 'Upload Image',
                      fontSize: 14,
                      colors: Colors.white,
                    ),
                  ),
                )
      ],
    );
  }
}
