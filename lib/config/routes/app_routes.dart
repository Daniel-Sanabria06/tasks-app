
import 'package:flutter_tasks_app/src/pages/home_page.dart';
import 'package:go_router/go_router.dart';

final  appRouter = GoRouter(
  initialLocation: '/',
  routes:[
    GoRoute(
      path: '/',
      builder: (context,state) => const MyHomePage(),
    ),
    
  ],
);