import 'package:flutter/material.dart';
import 'package:inside/Config/colors.dart';
import 'package:inside/Config/validationMessages.dart';
import 'package:inside/Helpers/ColorHelper.dart';
import 'package:inside/Models/Hobbie.dart';
import 'package:inside/Repositories/HobbieRepository.dart';
import 'package:super_tooltip/super_tooltip.dart';

class StepThree extends StatefulWidget {
  final formKey;
  final List<Hobbie> hobbiesLiked;
  final List<Hobbie> hobbiesDisliked;
  final Function setHobbieLiked;
  final Function setHobbieDisliked;
  final Function removeHobbie;
  final bool errorHobbie;

  StepThree({
    @required this.formKey,
    @required this.setHobbieLiked,
    @required this.hobbiesLiked,
    @required this.hobbiesDisliked,
    @required this.errorHobbie,
    @required this.removeHobbie,
    @required this.setHobbieDisliked,
  });

  @override
  _StepThreeState createState() => new _StepThreeState();
}

class _StepThreeState extends State<StepThree> {
  List<Hobbie> _hobbies;

  @override
  initState() {
    super.initState();
    _getHobbies();
  }

  _getHobbies() async {
    List<Hobbie> hobbies = await HobbieRepository().getHobbies();
    setState(() {
      _hobbies = hobbies;
    });
  }

  bool isHobbieAlreadySelected(Hobbie hobbie) {
    //Init the component with already liked or disliked hobbies if there are some
    var hobbiesLiked = widget.hobbiesLiked
        .where((Hobbie hobbieFiltered) => hobbieFiltered.name == hobbie.name)
        .toList();
    var hobbiesDisliked = widget.hobbiesDisliked
        .where((Hobbie hobbieFiltered) => hobbieFiltered.name == hobbie.name)
        .toList();
    if (hobbiesLiked.length > 0) {
      return true;
    } else if (hobbiesDisliked.length > 0) {
      return false;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Text(
                'Dites nous en plus sur ce que vous aimez... Ou pas !',
                style: TextStyle(color: InsideColors.pink, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            (_hobbies != null
                ? GridView.count(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    crossAxisCount: 3,
                    children: List.generate(
                      _hobbies.length,
                      (index) {
                        return _InterestItem(
                          index: index,
                          hobbie: _hobbies[index],
                          setHobbieLiked: (Hobbie hobbie) =>
                              widget.setHobbieLiked(hobbie),
                          setHobbieDisliked: (Hobbie hobbie) =>
                              widget.setHobbieDisliked(hobbie),
                          removeHobbie: (Hobbie hobbie) =>
                              widget.removeHobbie(hobbie),
                          isAlreadySelected:
                              isHobbieAlreadySelected(_hobbies[index]),
                        );
                      },
                    ),
                  )
                : CircularProgressIndicator()),
            widget.errorHobbie
                ? Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      ValidationMessage.hobbieRequired,
                      style: TextStyle(
                        color: Colors.red[600],
                        fontSize: 11.5,
                      ),
                    ),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }
}

class _InterestItem extends StatefulWidget {
  final int index;
  final Hobbie hobbie;
  final bool isAlreadySelected;
  final Function setHobbieLiked;
  final Function setHobbieDisliked;
  final Function removeHobbie;

  _InterestItem(
      {this.index,
      this.hobbie,
      this.isAlreadySelected,
      this.setHobbieDisliked,
      this.removeHobbie,
      this.setHobbieLiked});

  @override
  _InterestItemState createState() => _InterestItemState();
}

class _InterestItemState extends State<_InterestItem> {
  bool _isLiked;
  SuperTooltip tooltip;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isAlreadySelected;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: () => _displayTooltip(),
                  child: Container(
                    margin: EdgeInsets.only(left: _isLiked != null ? 8 : 0),
                    decoration: BoxDecoration(
                      color: ColorHelper()
                          .getColorFromString(widget.hobbie.backgroundColor),
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(15),
                    child: Image.asset('assets/${widget.hobbie.icon}'),
                  ),
                ),
                (_isLiked != null
                    ? GestureDetector(
                        onTap: () => _tapedInterest(widget.hobbie, like: null),
                        child: Container(
                          decoration: BoxDecoration(
                            color: InsideColors.darkGrey.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : SizedBox()),
                (_isLiked != null
                    ? Positioned(
                        right: 2,
                        top: 2,
                        width: 30,
                        height: 30,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(_isLiked
                                    ? 'assets/heart.png'
                                    : 'assets/broken_heart.png'),
                              ),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    : SizedBox()),
              ],
            ),
          ),
          Text(
            widget.hobbie.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  _displayTooltip() {
    if (tooltip != null && tooltip.isOpen) {
      tooltip.close();
      return;
    }

    tooltip = SuperTooltip(
      maxWidth: 150,
      minWidth: 145,
      popupDirection: TooltipDirection.up,
      arrowTipDistance: 15.0,
      arrowBaseWidth: 30.0,
      arrowLength: 30.0,
      borderColor: InsideColors.pink,
      borderWidth: 2.0,
      hasShadow: false,
      content: new Material(
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () => _tapedInterest(widget.hobbie, like: true),
              child: Image(
                image: AssetImage('assets/heart.png'),
                height: 50,
                width: 50,
                fit: BoxFit.fill,
              ),
            ),
            Container(
              height: 65.0,
              width: 1.0,
              color: InsideColors.grey,
              margin: const EdgeInsets.only(left: 13.0, right: 10.0),
            ),
            GestureDetector(
              onTap: () => _tapedInterest(widget.hobbie, like: false),
              child: Image(
                image: AssetImage('assets/broken_heart.png'),
                height: 55,
                width: 55,
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      ),
    );

    tooltip.show(context);
  }

  _tapedInterest(Hobbie hobbie, {bool like}) {
    setState(() {
      _isLiked = like;
    });

    if (like == true) {
      widget.setHobbieLiked(hobbie);
    } else if (like == false) {
      widget.setHobbieDisliked(hobbie);
    } else if (like == null) {
      widget.removeHobbie(hobbie);
    }

    tooltip.close();
  }
}
