import 'package:firebase_core/firebase_core.dart';
import 'package:first_ai/data/datasources/alert/alert_datasource_impl.dart';
import 'package:first_ai/data/datasources/authentication/auth_datasource_impl.dart';
import 'package:first_ai/data/datasources/flood/flood_datasource_impl.dart';
import 'package:first_ai/data/datasources/weather/weather_datasource_impl.dart';
import 'package:first_ai/data/helpers/notifications.dart';
import 'package:first_ai/data/helpers/utils.dart';
import 'package:first_ai/data/repositories/alertrepo_impl.dart';
import 'package:first_ai/data/repositories/authrepo_impl.dart';
import 'package:first_ai/data/repositories/floodrepo_impl.dart';
import 'package:first_ai/data/repositories/weatherrepo_impl.dart';
import 'package:first_ai/domain/clients/gemini_client.dart';
import 'package:first_ai/domain/repositories/alert_repository.dart';
import 'package:first_ai/domain/repositories/auth_repository.dart';
import 'package:first_ai/domain/repositories/flood_repository.dart';
import 'package:first_ai/domain/repositories/weather_repository.dart';
import 'package:first_ai/presentation/screens/starters/starter.dart';
import 'package:first_ai/presentation/viewmodels/alert_vm.dart';
import 'package:first_ai/presentation/viewmodels/auth_vm.dart';
import 'package:first_ai/presentation/viewmodels/chat_vm.dart';
import 'package:first_ai/presentation/viewmodels/flood_vm.dart';
import 'package:first_ai/presentation/viewmodels/gemini_vm.dart';
import 'package:first_ai/presentation/viewmodels/google_vm.dart';
import 'package:first_ai/presentation/viewmodels/weather_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyC9TS4MZTNRNzNGK0F5ACwFi75lGe-OgZY",
      appId: "1:460628855416:android:82b3c1f6e5de0c10503b8d",
      messagingSenderId: "460628855416",
      projectId: "floodai-1f951"
    ),
  );
  await Notifications().initNotifications();
  final guide = await Utils().loadJson();

  await dotenv.load(fileName: '.env');
  String iaKey = dotenv.env['IA_KEY']!;
  final model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: iaKey,
    safetySettings: [
      SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high),
      SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
      SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
      SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.high),
    ],
  );
  final gemini = GeminiClient(model: model);

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => gemini),
        ChangeNotifierProvider(create: (_) {
          AuthRepository authRepository = AuthRepositoryImpl(authDataSourceImpl: AuthDataSourceImpl());
          return AuthViewModel(authRepository: authRepository);
        }),
        ChangeNotifierProvider(create: (_) {
          WeatherRepository weatherRepository = WeatherRepositoryImpl(weatherDataSourceImpl: WeatherDataSourceImpl());
          return WeatherViewModel(weatherRepository: weatherRepository);
        }),
        ChangeNotifierProvider(create: (_) => GeminiViewModel(guide)),
        ChangeNotifierProvider(create: (_) => GoogleViewModel()),
        ChangeNotifierProvider(create: (_) {
          FloodRepository floodRepository = FloodRepositoryImpl(floodDataSourceImpl: FloodDataSourceImpl());
          return FloodViewModel(floodRepository: floodRepository);
        }),
        ChangeNotifierProvider(create: (_) {
          AlertRepository alertRepository = AlertRepositoryImpl(alertDataSourceImpl: AlertDataSourceImpl());
          return AlertViewModel(alertRepository: alertRepository);
        }),
        ChangeNotifierProvider(create: (_) => ChatViewModel()),
      ],
      child: const MyApp(),
    )
  );
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
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Customizecolor(const Color(0xff673AB7)).shade100,
      )
    );
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('fr'), // French
      ],
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
      home: const StarterScreen()
    );
  }
}
