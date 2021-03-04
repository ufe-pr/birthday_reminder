import 'package:birthday_reminder/core/bloc/birthday_bloc/bloc.dart';
import 'package:birthday_reminder/core/database/db_provider.dart';
import 'package:birthday_reminder/ui/widgets/add_birthday_dialog.dart';
import 'package:birthday_reminder/ui/widgets/birthday_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

final DateFormat _dateFormat = DateFormat.MMMM('en_US').add_d();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const List<String> _tabs = const ['Today', 'Upcoming', 'Past'];
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    BirthdayBloc.initialise().then((value) {
      BirthdayDatabaseProvider().birthdayStream.listen((event) {
        context.read<BirthdayBloc>().add(BirthdaysChanged(event));
      });
      context.read<BirthdayBloc>().add(BirthdaysInitializeRequested());
    });
    context.read<BirthdayBloc>().listen((BirthdayState state) {
      if (state.lastEvent is NewBirthdayAdded) {
        var birthday = (state.lastEvent as NewBirthdayAdded).birthday;
        _key.currentState
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
              content: Text(
            'Set a reminder for '
            '${birthday.celebrant}\'s '
            'birthday on '
            '${_dateFormat.format(birthday.birthday)}',
          )));
      } else if (state.lastEvent is BirthdayUpdated) {}
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        key: _key,
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => const AddBirthdayDialog(),
          ),
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                title: Text('Birthday reminder'),
                forceElevated: innerBoxIsScrolled,
                floating: true,
                pinned: true,
                bottom: TabBar(
                  tabs: _tabs.map<Tab>((e) => Tab(text: e)).toList(),
                ),
              ),
            )
          ],
          body: SafeArea(
            top: false,
            bottom: false,
            child: BlocBuilder<BirthdayBloc, BirthdayState>(
              builder: (context, state) {
                if (state.loading == true) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return TabBarView(
                  children: [
                    BirthdayList(
                      birthdays: state.todayBirthdays,
                      key: PageStorageKey<String>(_tabs[0]),
                    ),
                    BirthdayList(
                      birthdays: state.upcomingBirthdays,
                      key: PageStorageKey<String>(_tabs[1]),
                    ),
                    BirthdayList(
                      birthdays: state.pastBirthdays,
                      key: PageStorageKey<String>(_tabs[2]),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
