import 'package:first_ai/data/datasources/weather/weather_datasource_impl.dart';
import 'package:first_ai/data/repositories/weatherrepo_impl.dart';
import 'package:first_ai/domain/clients/gemini_client.dart';
import 'package:first_ai/domain/repositories/weather_repository.dart';
import 'package:first_ai/presentation/screens/starters/starter.dart';
import 'package:first_ai/presentation/viewmodels/gemini_vm.dart';
import 'package:first_ai/presentation/viewmodels/google_vm.dart';
import 'package:first_ai/presentation/viewmodels/weather_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:provider/provider.dart';

Future main() async {

  await dotenv.load(fileName: '.env');
  String iaKey = dotenv.env['IA_KEY']!;
  final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: iaKey);
  final gemini = GeminiClient(model: model);

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => gemini),
        ChangeNotifierProvider(create: (_) {
          WeatherRepository weatherRepository = WeatherRepositoryImpl(weatherDataSourceImpl: WeatherDataSourceImpl());
          return WeatherViewModel(weatherRepository: weatherRepository);
        }),
        ChangeNotifierProvider(create: (_) => GeminiViewModel()),
        ChangeNotifierProvider(create: (_) => GoogleViewModel()),
      ],
      child: const MyApp(),
    )
  );
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  MaterialColor Customizecolor(Color color){
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for(int i = 1; i < 10; i++){
      strengths.add(0.1 * i);
    }

    for(var str in strengths){
      final double ds = 0.5 - str;
      swatch[(str * 1000).round()] = Color.fromRGBO(
          r + ((ds < 0 ? r : (255 - r)) * ds).round(),
          g + ((ds < 0 ? g : (255 - g)) * ds).round(),
          b + ((ds < 0 ? b : (255 - b)) * ds).round(),
          1
      );
    }

    return MaterialColor(color.value, swatch);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'First AI',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Customizecolor(const Color(0xff673AB7)),
        ),
        primarySwatch: Customizecolor(const Color(0xff673AB7)),
        useMaterial3: true,
        fontFamily: 'Cabin',
      ),
      home: const StarterScreen(),
    );
  }
}
