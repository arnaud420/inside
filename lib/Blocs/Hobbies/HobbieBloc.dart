import 'package:bloc/bloc.dart';
import 'package:inside/Blocs/Hobbies/HobbieEvent.dart';
import 'package:inside/Blocs/Hobbies/HobbieState.dart';
import 'package:inside/Models/Hobbie.dart';
import 'package:inside/Repositories/HobbieRepository.dart';

class HobbieBloc extends Bloc<HobbieEvent, HobbieState> {

  @override
  HobbieState get initialState => LoadingHobbies();

  @override
  Stream<HobbieState> mapEventToState(HobbieEvent event) async* {
    if (event is getHobbies) {
      yield* _mapLoadingEventsToState();
    }
  }

  Stream<HobbieState> _mapLoadingEventsToState() async* {
    try {
      final HobbieRepository _hobbieRepository = HobbieRepository();
      List<Hobbie> hobbies = await _hobbieRepository.getHobbies();

      yield LoadedHobbies(hobbies: hobbies);
    } catch (e) {
      print('Error while loading hobbies : $e');
      yield LoadingHobbiesError();
    }
  }
}