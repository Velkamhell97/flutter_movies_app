import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'services/moviedb_service.dart';
import 'providers/movie_provider.dart';
import 'screens/screens.dart';
 
void main() async {
  await dotenv.load();
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [  
        Provider(create: (_) => MoviedbService()),
        ChangeNotifierProvider(
          create: (context) => MovieProvider(context.read<MoviedbService>()), 
          // lazy: false
        ) 
      ],
      child: const MyApp(),
    );
  }
}
 
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<MovieProvider, bool>(
      selector: (_, model) => model.darkMode,
      builder: (_, darkMode, __) => MaterialApp(
        title: 'App Peliculas',
        debugShowCheckedModeBanner: false,
        initialRoute: 'home',
        routes: {
          'home'   : (_) => const HomeScreen(),
          'detail' : (_) => const DetailScreen()
        },
        theme: darkMode ? ThemeData.dark() : ThemeData.light().copyWith(
          appBarTheme: const AppBarTheme(
            color: Colors.indigo
          )
        ),
      ),
    );
  }
}