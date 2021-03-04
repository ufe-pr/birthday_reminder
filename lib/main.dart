import 'package:birthday_reminder/constants/navigator.dart';
import 'package:birthday_reminder/core/bloc/birthday_bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'ui/home.dart';

const Color primary_swatch = MaterialColor(0xff122e9b, {
  500: Colors.blue,
});

void main() {
  initializeDateFormatting('en_US');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<BirthdayBloc>(
      create: (_) => BirthdayBloc(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: primary_swatch,
          appBarTheme: AppBarTheme(
            color: Colors.white,
            elevation: 2,
            textTheme: TextTheme(
              headline6: Theme.of(context).textTheme.headline6.copyWith(
                    color: primary_swatch,
                  ),
            ),
          ),
          tabBarTheme: TabBarTheme(
            labelColor: primary_swatch,
            unselectedLabelColor: Colors.grey,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                color: primary_swatch,
                width: 2,
              ),
              insets: EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: primary_swatch,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: primary_swatch,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: primary_swatch,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).disabledColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).errorColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).errorColor,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Home(),
      ),
    );
  }
}
