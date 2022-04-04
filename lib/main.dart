import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import 'package:peliculas_app/services/moviedb_service.dart';
import 'package:peliculas_app/providers/movie_provider.dart';
import 'package:peliculas_app/screens/screens.dart';
 
void main() {

  timeDilation = 1.0;

  runApp(AppState());
}

class AppState extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [  
        Provider(create: (_) => MoviedbService()),
        ChangeNotifierProvider(
          create: (context) => MovieProvier(context.read<MoviedbService>()), 
          // lazy: false
        ) 
      ],
      child: MyApp(),
    );
  }
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Selector<MovieProvier, bool>(
      selector: (_, model) => model.darkMode,
      builder: (_, darkMode, __) => MaterialApp(
        title: 'App Peliculas',
        debugShowCheckedModeBanner: false,
        initialRoute: 'home',
        routes: {
          'home'   : (_) => HomeScreen(),
          'detail' : (_) => DetailScreen()
        },
        theme: darkMode ? ThemeData.dark() : ThemeData.light().copyWith(
          appBarTheme: AppBarTheme(
            color: Colors.indigo
          )
        ),
      ),
    );
  }
}