import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:inside/Config/colors.dart';

class ExpandableItem extends StatefulWidget {
  final String headerTitle;
  final child;

  ExpandableItem({@required this.headerTitle, @required this.child});

  ExpandableItemState createState() => ExpandableItemState();
}

class ExpandableItemState extends State<ExpandableItem> {
  ExpandableController _expandableController = ExpandableController();
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _expandableController.addListener(_onExpansionChange);
  }

  @override
  void dispose() {
    super.dispose();
    _expandableController.dispose();
  }

  _onExpansionChange() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      controller: _expandableController,
      header: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        color: !_isExpanded ? InsideColors.lightBlue : InsideColors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                widget.headerTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
                padding: EdgeInsets.only(right: 20),
                child: Image.asset(!_isExpanded
                    ? 'assets/arrow_down_white.png'
                    : 'assets/arrow_up_white.png')),
          ],
        ),
      ),
      expanded: widget.child,
      tapHeaderToExpand: true,
      hasIcon: false,
    );
  }
}