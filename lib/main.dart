import 'package:flutter/material.dart';
import 'package:covtracker/app/repositories/data_repository.dart';
import 'package:covtracker/app/services/api.dart';
import 'package:covtracker/app/services/data_cache_service.dart';
import 'package:covtracker/app/ui/dashboard.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/services/api_service.dart';

void main() async {
  //SYNCHRONUS API'S ARE MORE EFFECIENT AND EASY TO USE AND FAST TOO.

  //shared preferences için WidgetsFlutterBinding.ensureInitialized(); yazıldı.
  WidgetsFlutterBinding.ensureInitialized();
  final _sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(sharedPreferences: _sharedPreferences));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key, this.sharedPreferences}) : super(key: key);
  final SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return Provider<DataRepository>(
      create: (_) => DataRepository(
          apiService: APIService(
            API.sandbox(),
          ),
          dataCacheService:
              DataCacheService(sharedPreferences: sharedPreferences)),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'nCov 2021 Tracker',
          theme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: Color(0xFF101010),
              cardColor: Color(0xFF222222)),
          home: Dashboard()),
    );
  }
}
