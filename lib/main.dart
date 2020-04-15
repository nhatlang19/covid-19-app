import 'package:covid19/bloc/country/country_bloc.dart';
import 'package:covid19/bloc/country/country_event.dart';
import 'package:covid19/bloc/map_country/map_country_bloc.dart';
import 'package:covid19/bloc/map_country/map_country_event.dart';
import 'package:covid19/widget/dashboard.dart';
import 'package:covid19/widget/show_map.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'COVID-19',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String title = 'Home';
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    BlocProvider(
      create: (context) =>
          CountryBloc(httpClient: http.Client())..add(FetchGlobal()),
      child: Dashboard(),
    ),
    BlocProvider(
      create: (context) => MapCountryBloc(httpClient: http.Client())
        ..add(FetchCountriesForMap()),
      child: ShowMap(),
    ),
  ];

  String _title(int index) {
    switch (index) {
      case 0:
        return "Dashboard";
      case 1:
        return 'Map';
      default:
        return "Dashboard";
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      title = _title(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
        centerTitle: true,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: FancyBottomNavigation(
        tabs: [
          TabData(iconData: Icons.home, title: "Dashhboard"),
          TabData(iconData: Icons.map, title: "Show Map"),
        ],
        onTabChangedListener: _onItemTapped,
      ),
    );
  }
}
