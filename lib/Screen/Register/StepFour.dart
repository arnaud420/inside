import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inside/Config/colors.dart';
import 'package:inside/Config/validationMessages.dart';
import 'package:inside/Widget/Forms/Dropdown.dart';

class StepFour extends StatefulWidget {
  final formKey;
  final String ageMin, distance, ageMax;
  final Function setAge, setDistance;

  StepFour({
    @required this.formKey,
    @required this.ageMax,
    @required this.ageMin,
    @required this.distance,
    @required this.setAge,
    @required this.setDistance,
  });

  @override
  _StepFourState createState() => new _StepFourState();
}

class _StepFourState extends State<StepFour> {
  int _distanceValue, _ageMin, _ageMax;
  bool _ageError;

  @override
  void initState() {
    super.initState();
    _distanceValue = int.parse(widget.distance);
    _ageMin = int.parse(widget.ageMin);
    _ageMax = int.parse(widget.ageMax);
    _ageError = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Text(
                'Quelles sont vos préférences de recherche ?',
                style: TextStyle(color: InsideColors.pink, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            _FieldTitle(title: 'Distance'),
            Row(
              children: <Widget>[
                Flexible(
                  flex: 8,
                  child: Slider(
                    activeColor: InsideColors.brownie,
                    min: 0.0,
                    max: 100.0,
                    onChanged: (newRating) {
                      setState(() => _distanceValue = newRating.round());
                      widget.setDistance(newRating.round().toString());
                    },
                    value: _distanceValue.toDouble(),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Text(
                    '${_distanceValue.toString()} Km',
                    style: TextStyle(
                      color: InsideColors.burgundy,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            _FieldTitle(title: 'Âge'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: Text(
                    'De',
                    style: TextStyle(
                      color: InsideColors.burgundy,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
                Flexible(
                  flex: 4,
                  child: Dropdown(
                    dropdownContent: _ageDropdownContent(),
                    inheritedContext: context,
                    initialValue: _ageMin.toString(),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Text(
                    'à',
                    style: TextStyle(
                      color: InsideColors.burgundy,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
                Flexible(
                  flex: 4,
                  child: Dropdown(
                    dropdownContent: _ageDropdownContent(isMin: false),
                    inheritedContext: context,
                    initialValue: _ageMax.toString(),
                  ),
                ),
              ],
            ),
            _ageError
                ? Container(
                    margin: EdgeInsets.only(left: 16, top: 10),
                    child: Text(
                      ValidationMessage.ageMaxGreater,
                      style: TextStyle(
                        color: Colors.red[600],
                        fontSize: 11.5,
                      ),
                    ),
                  )
                : SizedBox(),
          ],
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

  String _validate(String value) {
    if (value.length == 0) {
      return ValidationMessage.mandatoryField;
    }

    return null;
  }

  _ageDropdownContent({bool isMin = true}) {
    List<Widget> ages = [];
    for (int age = 18; age < 70; age++) {
      ages.add(
        ListTile(
          title: Center(
            child: Text(
              '$age',
              style: TextStyle(color: InsideColors.blue, fontSize: 17),
            ),
          ),
          onTap: () => _saveMinAge(context, age, isMin),
        ),
      );
    }

    return ages;
  }

  _saveMinAge(BuildContext context, int age, bool isMin) {
    // If the age entered is greater than the min age -> display error
    if ((!isMin && age < _ageMin) || (isMin && age > _ageMax)) {
      setState(() {
        _ageError = true;
      });
    } else {
      setState(() {
        _ageError = false;
        if (isMin) {
          _ageMin = age;
        } else {
          _ageMax = age;
        }
      });
      widget.setAge(isMin, age.toString());
    }
    Navigator.pop(context);
  }
}

class _FieldTitle extends StatelessWidget {
  final String title;

  _FieldTitle({this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
      child: Text(
        title,
        style: TextStyle(color: InsideColors.pink, fontSize: 18),
      ),
    );
  }
}
