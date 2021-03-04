import 'package:birthday_reminder/core/models/birthday.dart';
import 'package:birthday_reminder/ui/widgets/birthday_list_tile.dart';
import 'package:flutter/material.dart';


class BirthdayList extends StatefulWidget {
  final List<Birthday> birthdays;

  const BirthdayList({Key key, this.birthdays}) : super(key: key);
  @override
  _BirthdayListState createState() => _BirthdayListState();
}

class _BirthdayListState extends State<BirthdayList> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverList(
          key: PageStorageKey<Key>(widget.key),
          delegate: SliverChildBuilderDelegate(
                (context, index) {
                  var birthday = widget.birthdays[index];
              return BirthdayListTile(
                birthday: Birthday(
                  celebrant: birthday.celebrant,
                  birthday: birthday.birthday,
                  id: birthday.id,
                ),
              );
            },
            childCount: widget.birthdays.length,
          ),
        ),
      ],
    );
  }
}
