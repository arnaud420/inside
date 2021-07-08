import 'package:equatable/equatable.dart';
import 'package:inside/Models/Hobbie.dart';

abstract class HobbieState extends Equatable {
  const HobbieState();

  @override
  List<Object> get props => [];
}

class LoadingHobbies extends HobbieState {}

class LoadedHobbies extends HobbieState {
  final List<Hobbie> hobbies;

  LoadedHobbies({this.hobbies});

  @override
  List<Object> get props => [hobbies];
}

class LoadingHobbiesError extends HobbieState {}