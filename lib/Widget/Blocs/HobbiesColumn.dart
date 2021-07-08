import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inside/Blocs/Hobbies/HobbieBloc.dart';
import 'package:inside/Blocs/Hobbies/HobbieState.dart';
import 'package:inside/Config/colors.dart';
import 'package:inside/Models/Hobbie.dart';
import 'package:inside/Widget/Elements/HobbieItem.dart';

class HobbiesColumn extends StatelessWidget {
  final String iconName;
  final String title;
  final List<dynamic> hobbies;
  final bool border;

  HobbiesColumn({
    @required this.iconName,
    @required this.title,
    @required this.hobbies,
    this.border = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 15),
              child: Column(
                children: [
                  Image.asset('assets/$iconName'),
                  Text(title, style: TextStyle(fontSize: 17),),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                decoration: border
                    ? BoxDecoration(
                      border: Border(
                        right: BorderSide(color: InsideColors.grey),
                      ),
                    )
                    : null,
                child: BlocBuilder<HobbieBloc, HobbieState>(
                  builder: (context, state) {
                    if (state is LoadedHobbies) {
                      return GridView.count(
                        childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 1.4),
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        crossAxisCount: 2,
                        children: hobbies.map(
                          (hobbie) => HobbieItem(hobbie: Hobbie.fromMap(Map<String, dynamic>.from(hobbie), hobbie['id']))
                        ).toList()
                      );
                    }

                    return CircularProgressIndicator();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}