import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget setupProviders(Widget child) {
  return MultiBlocProvider(
    providers: [
      // authentication
      // BlocProvider(create: (context) {
      //   final cubit = AuthenticationCubit(
      //     preferencesRepo: context.read(),
      //   );
      //   cubit.isUserLoggedIn();
      //   cubit.logoutListener();
      //   return cubit;
      // }),
    ],
    child: child,
  );
}
