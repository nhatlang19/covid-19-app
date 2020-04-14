import 'package:covid19/bloc/country/country_event.dart';
import 'package:intl/intl.dart';

import 'package:covid19/bloc/country/country_bloc.dart';
import 'package:covid19/bloc/country/country_state.dart';
import 'package:covid19/model/country.dart';
import 'package:covid19/widget/dashboard/select_country.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  Country selectedCountry;
  Country global;

  final f = new NumberFormat("##,###", "en_US");

  CountryBloc _countryBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _countryBloc = BlocProvider.of<CountryBloc>(context);
    _countryBloc.listen((onData) {
      if (onData is CountryInfoLoaded) {
        selectedCountry = onData.country;
        if (onData.country.country == 'Global') {
          global = onData.country;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountryBloc, CountryState>(
      builder: (context, state) {
        if (state is CountryUninitialized) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is CountryError) {
          return Center(
            child: Text('failed to fetch posts'),
          );
        }
        if (state is CountryInfoLoaded) {
          return _buildPage();
        }

        return Container();
      },
    );
  }

  Widget _buildPage() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _buildFilterCountries(),
          _buildTotalConfirmed(),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Row(
              children: <Widget>[
                Expanded(child: _buildTotalDeaths()),
                Expanded(child: _buildTotalCritical()),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Row(
              children: <Widget>[
                Expanded(child: _buildTotalRecovered()),
                Expanded(child: _buildTotalAffectedCountries()),
              ],
            ),
          ),
          Center(
              child: Text('Last updated: ' +
                  DateTime.fromMillisecondsSinceEpoch(selectedCountry.updated)
                      .toIso8601String()))
        ],
      ),
    );
  }

  Widget _buildFilterCountries() {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 15, right: 15),
      child: Container(
        decoration: new BoxDecoration(
            color: Colors.black54,
            borderRadius: new BorderRadius.all(Radius.circular(10))),
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(selectedCountry.country,
                style: TextStyle(color: Colors.white, fontSize: 14)),
            InkWell(
                onTap: () async {
                  final result =
                      await Navigator.of(context).push(_createRoute());

                  setState(() {
                    selectedCountry = result as Country;
                  });
                  if ((result as Country).country == 'Global') {
                    _countryBloc..add(FetchGlobal());
                  }
                },
                child: Text('Change',
                    style: TextStyle(color: Colors.green[300], fontSize: 14)))
          ],
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => BlocProvider(
        create: (context) =>
            CountryBloc(httpClient: http.Client())..add(FetchCountries()),
        child: SelectCountry(
          global: global,
          selected: selectedCountry,
        ),
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Widget _buildTotalConfirmed() {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Card(
        elevation: 1,
        color: Colors.black54,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Total Confirmed',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  )),
              Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.check, color: Colors.green, size: 40.0),
                    Text(
                      f.format(selectedCountry.cases),
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 40,
                          fontWeight: FontWeight.w900),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(),
                  Row(
                    children: <Widget>[
                      Text(
                        'Daily Increment:',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Text(
                        '+' + f.format(selectedCountry.todayCases),
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.w900),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalDeaths() {
    return Card(
      elevation: 1,
      color: Colors.black54,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  'Total Deaths',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                )),
            Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(Icons.check, color: Colors.red, size: 20.0),
                  Text(
                    f.format(selectedCountry.deaths),
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.w900),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(),
                Row(
                  children: <Widget>[
                    SizedBox(),
                    Text(
                      '+' + f.format(selectedCountry.todayDeaths),
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.w900),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRecovered() {
    return Card(
      elevation: 1,
      color: Colors.black54,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  'Total Recovered',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                )),
            Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(Icons.check, color: Colors.blue[400], size: 20.0),
                  Text(
                    f.format(selectedCountry.recovered),
                    style: TextStyle(
                        color: Colors.blue[400],
                        fontSize: 20,
                        fontWeight: FontWeight.w900),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(),
                Row(
                  children: <Widget>[
                    SizedBox(),
                    Text(
                      '',
                      style: TextStyle(
                          color: Colors.blue[400],
                          fontSize: 14,
                          fontWeight: FontWeight.w900),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalCritical() {
    return Card(
      elevation: 1,
      color: Colors.black54,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  'Total Critical',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                )),
            Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(Icons.check, color: Colors.yellowAccent, size: 20.0),
                  Text(
                    f.format(selectedCountry.critical),
                    style: TextStyle(
                        color: Colors.yellowAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.w900),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(),
                Row(
                  children: <Widget>[
                    SizedBox(),
                    Text(
                      '',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.w900),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalAffectedCountries() {
    return Card(
      elevation: 1,
      color: Colors.black54,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  'Affected Countries',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                )),
            Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(Icons.check, color: Colors.purpleAccent, size: 20.0),
                  Text(
                    f.format(global.affectedCountries),
                    style: TextStyle(
                        color: Colors.purpleAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.w900),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(),
                Row(
                  children: <Widget>[
                    SizedBox(),
                    Text(
                      '',
                      style: TextStyle(
                          color: Colors.blue[400],
                          fontSize: 14,
                          fontWeight: FontWeight.w900),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
