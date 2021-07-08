import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inside/Config/colors.dart';

class Dropdown extends StatefulWidget {
  BuildContext inheritedContext;
  String initialValue;
  List<Widget> dropdownContent;

  Dropdown({
    @required this.inheritedContext,
    @required this.initialValue,
    @required this.dropdownContent,
  });

  @override
  _DropdownState createState() => new _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(context, widget.dropdownContent),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.all(17),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                widget.initialValue,
                style: TextStyle(
                    color: InsideColors.burgundy,
                    fontSize: 18),
              ),
              Image.asset('assets/arrowDown.png'),
            ],
          ),
        ),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: new BorderRadius.all(
            Radius.circular(5),
          ),
        ),
      ),
    );
  }

  onTap(context, content) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height / 4,
          child: ListView(
            shrinkWrap: true,
            children: content,
          ),
        );
      },
    );
  }
}
