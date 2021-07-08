import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inside/Config/colors.dart';
import 'package:inside/Config/validationMessages.dart';
import 'package:inside/Widget/Forms/FloatingTextField.dart';
import 'package:inside/Widget/ImagePickerHandler.dart';
import 'package:network_to_file_image/network_to_file_image.dart';

class StepTwo extends StatefulWidget {
  final formKey;
  final TextEditingController descriptionController;
  final bool pictureError;
  final Function setPicture;
  final File picture;
  final bool isImageFromFile;
  final String url;

  StepTwo(
      {@required this.formKey,
      @required this.descriptionController,
      @required this.pictureError,
      @required this.picture,
      @required this.setPicture,
      this.isImageFromFile = false,
      this.url});

  @override
  _StepTwoState createState() => _StepTwoState();
}

class _StepTwoState extends State<StepTwo>
    with TickerProviderStateMixin, ImagePickerListener {
  File _image;
  AnimationController _animationController;
  ImagePickerHandler imagePicker;

  @override
  void initState() {
    super.initState();
    _image = widget.picture;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    imagePicker = ImagePickerHandler(this, _animationController);
    imagePicker.init();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _PictureTaker(
                  image: _image,
                  imagePicker: imagePicker,
                  isImageFromFile: widget.isImageFromFile,
                  url: widget.url),
              Container(
                margin: EdgeInsets.only(left: 16, top: 10),
                child: widget.pictureError
                    ? Text(
                        ValidationMessage.mandatoryField,
                        style: TextStyle(
                          color: Colors.red[600],
                          fontSize: 11.5,
                        ),
                      )
                    : SizedBox(),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: FloatingTextField(
                  label: 'description',
                  validation: (String val) => _validateDescription(val),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: widget.descriptionController,
                ),
              ),
            ],
          )),
    );
  }

  @override
  userImage(File _image) {
    setState(() {
      this._image = _image;
    });
    widget.setPicture(_image);
  }

  _validateDescription(String val) {
    if (val.length == 0) {
      return ValidationMessage.mandatoryField;
    } else if (val.length < 2) {
      return ValidationMessage.minimumOneCharacter;
    }

    return null;
  }
}

class _PictureTaker extends StatelessWidget {
  final File image;
  final ImagePickerHandler imagePicker;
  final String url;
  bool isImageFromFile;

  _PictureTaker({this.image, this.imagePicker, this.isImageFromFile, this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => imagePicker.showDialog(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            fit: FlexFit.loose,
            flex: 4,
            child: (image == null
                ? Container(
                    height: 100,
                    width: 100,
                    child: Image.asset(
                      "assets/placeholder.png",
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Color(0xff7c94b6),
                      image: DecorationImage(
                        image: !isImageFromFile
                            ? FileImage(File(image.path))
                            : NetworkToFileImage(
                                url: url, file: image, debug: true),
                        fit: BoxFit.cover,
                      ),
                      border:
                          Border.all(color: InsideColors.lightBlue, width: 4.0),
                      borderRadius:
                          BorderRadius.all(const Radius.circular(80.0)),
                    ),
                  )),
          ),
          Flexible(
            fit: FlexFit.loose,
            flex: 5,
            child: Container(
              child: Text(
                "Prendre une photo ou en ajouter une depuis la galerie...",
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
                style: TextStyle(
                  color: InsideColors.pink,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
