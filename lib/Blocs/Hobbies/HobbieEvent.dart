import 'package:equatable/equatable.dart';

abstract class HobbieEvent extends Equatable {
  const HobbieEvent();

  @override
  List<Object> get props => [];
}

class getHobbies extends HobbieEvent {}