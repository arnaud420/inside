import 'package:flutter/material.dart';
import 'package:inside/Config/colors.dart';

class FloatingTextField extends StatefulWidget {
  final String label;
  final Function validation;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool isDateField;
  final Function onTap;
  final String initialValue;
  final int maxLines;
  final String placeholder;

  FloatingTextField(
      {@required this.label,
      @required this.validation,
      @required this.controller,
      this.keyboardType,
      this.isPassword: false,
      this.isDateField: false,
      this.onTap,
      this.initialValue,
      this.maxLines: 1,
      this.placeholder});

  @override
  _FloatingTextFieldState createState() => new _FloatingTextFieldState();
}

class _FloatingTextFieldState extends State<FloatingTextField> {
  FocusNode _focus = FocusNode();
  bool _isFocused = false;
  String _error;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = !_isFocused;
      if (!_isFocused) {
        validate(widget.controller.text);
      }
    });
  }

  validate(val) {
    final String isValidated = widget.validation(val);
    setState(() {
      _error = isValidated;
    });

    return isValidated;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isDateField && widget.controller.text != widget.initialValue) {
      widget.controller.text =
          widget.initialValue == null ? "" : widget.initialValue;
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 25),
      child: TextFormField(
        onTap: () => widget.onTap == null ? null : widget.onTap(context),
        focusNode: _focus,
        minLines: widget.maxLines != 1 ? 12 : 1,
        maxLines: widget.maxLines,
        controller: widget.controller,
        obscureText: widget.isPassword,
        validator: (val) {
          return widget.validation(val);
        },
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: InsideColors.brownie, width: 1),
          ),
          suffixIcon: _error != null ? Icon(Icons.error) : null,
          labelText: widget.label,
          labelStyle: TextStyle(
              color: _isFocused ? InsideColors.pink : InsideColors.darkGrey),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: InsideColors.brownie, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: InsideColors.brownie, width: 1),
          ),
          errorText: _error,
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: InsideColors.brownie, width: 1),
          ),
        ),
        style: TextStyle(color: InsideColors.darkGrey),
        keyboardType: widget.keyboardType,
      ),
    );
  }
}
