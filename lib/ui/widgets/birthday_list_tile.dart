import 'package:birthday_reminder/core/models/birthday.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final DateFormat _dateFormat = DateFormat.MMMM('en_US').add_d();

class BirthdayListTile extends StatefulWidget {
  const BirthdayListTile({Key key, this.birthday}) : super(key: key);

  final Birthday birthday;

  @override
  _BirthdayListTileState createState() => _BirthdayListTileState();
}

class _BirthdayListTileState extends State<BirthdayListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.birthday.celebrant),
      subtitle: Text(_dateFormat.format(widget.birthday.birthday)),
      trailing: PopupMenuButton<String>(
        icon: Icon(Icons.more_vert_rounded),
        onSelected: null,
        itemBuilder: (_) => [
          PopupMenuItem<String>(
            child: Text('Delete Birthday'),
            value: 'delete',
          ),
          PopupMenuDivider(),
          PopupMenuItem<String>(
            child: Text('Edit Birthday'),
            value: 'edit',
          ),
        ],
      ),
    );
  }
}
