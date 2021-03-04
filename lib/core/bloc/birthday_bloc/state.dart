part of 'bloc.dart';

class BirthdayState {
  final List<Birthday> birthdays;
  final bool loading;
  final BirthdayEvent lastEvent;

  final Iterable<Birthday> _tb;

  final Iterable<Birthday> _pb;

  final Iterable<Birthday> _ub;

  Iterable<Birthday> get todayBirthdays => _tb;

  Iterable<Birthday> get pastBirthdays => _pb;

  Iterable<Birthday> get upcomingBirthdays => _ub;

  BirthdayState({
    this.loading: true,
    this.lastEvent,
    this.birthdays: const [],
  })  : _tb = birthdays.where((e) => e.birthday.isToday).toList(),
        _pb = birthdays.where((e) => e.birthday.isPast).toList(),
        _ub = birthdays.where((e) => e.birthday.isFuture).toList();

  BirthdayState copyWith({bool loading: true, BirthdayEvent lastEvent}) =>
      BirthdayState(
        loading: loading ?? this.loading,
        birthdays: birthdays,
        lastEvent: lastEvent,
      );
}

extension StartOfDay on DateTime {
  bool get isToday {
    var now = DateTime.now();
    var newDate = DateTime(this.year, this.month, this.day);
    var today = DateTime(now.year, now.month, now.day);

    return newDate.isAtSameMomentAs(today);
  }

  bool get isPast {
    var now = DateTime.now();
    var newDate = DateTime(this.year, this.month, this.day);
    var today = DateTime(now.year, now.month, now.day);

    return newDate.isBefore(today);
  }

  bool get isFuture {
    var now = DateTime.now();
    var newDate = DateTime(this.year, this.month, this.day);
    var today = DateTime(now.year, now.month, now.day);

    return newDate.isAfter(today);
  }
}
