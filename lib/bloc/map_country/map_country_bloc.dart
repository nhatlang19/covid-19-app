import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:covid19/bloc/map_country/map_country_event.dart';
import 'package:covid19/bloc/map_country/map_country_state.dart';
import 'package:covid19/model/country.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_bloc/flutter_bloc.dart';

class MapCountryBloc extends Bloc<MapCountryEvent, MapCountryState> {
  final String API = 'https://corona.lmao.ninja';

  final http.Client httpClient;

  MapCountryBloc({@required this.httpClient});

  @override
  // TODO: implement initialState
  MapCountryState get initialState => MapCountryUninitialized();

//  @override
//  Stream<CountryState> transformEvents(
//      Stream<CountryEvent> events,
//      Stream<CountryState> Function(CountryEvent event) next,
//      ) {
//    return super.transformEvents(
//      events.debounceTime(
//        Duration(milliseconds: 500),
//      ),
//      next,
//    );
//  }

  @override
  Stream<MapCountryState> mapEventToState(MapCountryEvent event) async* {
    if (event is FetchCountriesForMap) {
      try {
        final countries = await fetchCountries();
        yield MapCountriesLoaded(countries: countries);
      } catch (_) {
        yield MapCountryError();
      }
    }
  }

  Future<List<Country>> fetchCountries() async {
    final response = await httpClient.get('$API/v2/countries');

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      List<Country> countries = [];
      try {
        countries = data.map((rawCountry) {
          var info = rawCountry['countryInfo']['_id'] != null
              ? CountryInfo(
                  id: int.parse(rawCountry['countryInfo']['_id'].toString()),
                  iso2: rawCountry['countryInfo']['iso2'].toString(),
                  iso3: rawCountry['countryInfo']['iso3'].toString(),
                  lat:
                      double.parse(rawCountry['countryInfo']['lat'].toString()),
                  long: double.parse(
                      rawCountry['countryInfo']['long'].toString()),
                  flag: rawCountry['countryInfo']['flag'].toString())
              : null;
          return Country(
              country: rawCountry['country'].toString(),
              updated: int.parse(rawCountry['updated'].toString()),
              cases: int.parse(rawCountry['cases'].toString()),
              todayCases: int.parse(rawCountry['todayCases'].toString()),
              deaths: int.parse(rawCountry['deaths'].toString()),
              todayDeaths: int.parse(rawCountry['todayDeaths'].toString()),
              recovered: int.parse(rawCountry['recovered'].toString()),
              active: int.parse(rawCountry['active'].toString()),
              critical: int.parse(rawCountry['critical'].toString()),
              casesPerOneMillion:
                  double.parse(rawCountry['casesPerOneMillion'].toString()),
              deathsPerOneMillion:
                  double.parse(rawCountry['deathsPerOneMillion'].toString()),
              tests: int.parse(rawCountry['tests'].toString()),
              testsPerOneMillion:
                  double.parse(rawCountry['testsPerOneMillion'].toString()),
              affectedCountries: 0,
              info: info);
        }).toList();
      } catch (ex) {
        print(ex.toString());
      }
      return countries;
    } else {
      throw Exception('error fetching Countrys');
    }
  }
}
