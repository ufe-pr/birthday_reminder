part of 'bloc.dart';

abstract class BirthdayEvent {}

class BirthdaysInitializeRequested extends BirthdayEvent {}

class NewBirthdayAdded extends BirthdayEvent {
  final Birthday birthday;

  NewBirthdayAdded(this.birthday);
}

class BirthdayUpdated extends BirthdayEvent {
  final Birthday updatedBirthday;

  BirthdayUpdated(this.updatedBirthday);
}

class BirthdaysChanged extends BirthdayEvent {
  final Iterable<Birthday> birthdays;

  BirthdaysChanged(this.birthdays);
}
