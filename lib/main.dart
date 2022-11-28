import 'package:egorka/core/bloc/history_orders/history_orders_bloc.dart';
import 'package:egorka/core/bloc/profile.dart/profile_bloc.dart';
import 'package:egorka/core/bloc/search/search_bloc.dart';
import 'package:egorka/helpers/location.dart';
import 'package:egorka/helpers/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  Location().checkPermission;
  initializeDateFormatting('ru');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchAddressBloc>(
          create: (context) => SearchAddressBloc(),
        ),
        BlocProvider<HistoryOrdersBloc>(
          create: (context) => HistoryOrdersBloc(),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(),
        ),
      ],
      child: ScreenUtilInit(
          designSize: const Size(428, 926),
          builder: (context, child) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: AppRoute.home,
              onGenerateRoute: AppRoute.onGenerateRoute,
            );
          }),
    );
  }
}
