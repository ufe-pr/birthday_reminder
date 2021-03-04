import 'package:birthday_reminder/constants/navigator.dart';
import 'package:birthday_reminder/core/database/db_provider.dart';
import 'package:birthday_reminder/core/models/birthday.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'events.dart';
part 'state.dart';

class BirthdayBloc extends Bloc<BirthdayEvent, BirthdayState> {
  BirthdayBloc() : super(BirthdayState());

  static BirthdayDatabaseProvider _databaseProvider;

  static Future<void> initialise() async {
    _databaseProvider = await BirthdayDatabaseProvider().instance;
  }

  @override
  Stream<BirthdayState> mapEventToState(BirthdayEvent event) async* {
    if (event is BirthdaysInitializeRequested) {
      await _databaseProvider.updateStream();
    } else if (event is NewBirthdayAdded) {
      yield state.copyWith(loading: true);
      await _databaseProvider.insert(event.birthday);
      yield state.copyWith(loading: false, lastEvent: event);
      navigatorKey.currentState.pop();
    } else if (event is BirthdayUpdated) {
      yield state.copyWith(loading: true);
      await _databaseProvider.update(event.updatedBirthday);
      yield state.copyWith(loading: false, lastEvent: event);
      navigatorKey.currentState.pop();
    } else if (event is BirthdaysChanged) {
      print('Birthdays changed: ${event.birthdays}');
      yield BirthdayState(birthdays: event.birthdays, loading: false);
    }
  }

  @override
  void onChange(Change<BirthdayState> change) {
    print(change);
    super.onChange(change);
  }
}
