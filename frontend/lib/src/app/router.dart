import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter router = GoRouter(
  routes: [
    // ...landingNavigation,
  ],
  initialLocation: "/",
  errorBuilder: (error, stackTrace) => Scaffold(
    body: Center(
      child: Text(
        '$error',
        textAlign: TextAlign.center,
      ),
    ),
  ),
);
