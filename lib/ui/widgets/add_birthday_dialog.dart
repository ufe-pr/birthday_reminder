import 'package:birthday_reminder/core/bloc/birthday_bloc/bloc.dart';
import 'package:birthday_reminder/core/models/birthday.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddBirthdayDialog extends StatefulWidget {
  const AddBirthdayDialog({Key key}) : super(key: key);

  @override
  _AddBirthdayDialogState createState() => _AddBirthdayDialogState();
}

// TODO: Add support for edit
class _AddBirthdayDialogState extends State<AddBirthdayDialog> {
  DateTime _date;
  bool _dateError;

  final GlobalKey<FormState> _key = GlobalKey();
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add a new birthday',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 30),
              buildTextFormField(context),
              SizedBox(height: 20),
              buildDateField(context),
              SizedBox(height: 20),
              BlocBuilder<BirthdayBloc, BirthdayState>(
                builder: (context, state) => Row(
                  children: [
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        onPressed: state.loading == true
                            ? null
                            : () {
                                var formValid = _key.currentState.validate();
                                var dateValid = validateDate();
                                if (formValid && dateValid) {
                                  context
                                      .read<BirthdayBloc>()
                                      .add(NewBirthdayAdded(Birthday(
                                        celebrant: _controller.text.trim(),
                                        birthday: _date,
                                      )));
                                }
                              },
                        child: state.loading == true
                            ? const SizedBox(
                                child: const CircularProgressIndicator(),
                                height: 20,
                                width: 20,
                              )
                            : Text('Add'),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).disabledColor,
                        textColor: Colors.white,
                        onPressed: state.loading == true
                            ? null
                            : () {
                                Navigator.pop(context);
                              },
                        child: Text('Cancel'),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildTextFormField(BuildContext context) {
    return TextFormField(
      key: ValueKey('add_birthday_dialog_textFormField'),
      controller: _controller,
      validator: (value) => value.isEmpty ? "Please provide a name" : null,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        hintText: 'Whose birthday is it?',
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Material buildDateField(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: _dateError == true
              ? Theme.of(context).errorColor
              : Theme.of(context).primaryColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  _date == null
                      ? "What's the date of birth?"
                      : DateFormat("MMMM d", 'en_US').format(_date),
                  style: TextStyle(
                    color: _dateError == true
                        ? Theme.of(context).errorColor
                        : null,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.perm_contact_calendar_rounded,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () async {
                _date = (await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(DateTime.now().year),
                      lastDate: DateTime(DateTime.now().year, 12, 31, 23, 59, 59, 999, 999999),
                    )) ??
                    _date;
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  bool validateDate() {
    if (_date == null) {
      _dateError = false;
    }
    _dateError = true;
    setState(() {});
    return _dateError;
  }
}
