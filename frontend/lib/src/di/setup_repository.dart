import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/src/core/core.dart';

setupRepository() {
  return [
    RepositoryProvider(
      create: (context) => SharedPreference(),
    ),
  ];
}
