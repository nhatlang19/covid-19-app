import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:covid19/model/country.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import 'package:covid19/bloc/country/country_event.dart';
import 'package:covid19/bloc/country/country_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountryBloc extends Bloc<CountryEvent, CountryState> {
  final String API = 'https://corona.lmao.ninja';

  final http.Client httpClient;

  CountryBloc({@required this.httpClient});

  @override
  // TODO: implement initialState
  CountryState get initialState => CountryUninitialized();

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
  Stream<CountryState> mapEventToState(CountryEvent event) async* {
    if (event is FetchCountries) {
      try {
        final countries = await fetchCountries();
        yield CountriesLoaded(countries: countries);
      } catch (_) {
        yield CountryError();
      }
    }

    if (event is FetchGlobal) {
      try {
        final country = await fetchGlobal();
        yield CountryInfoLoaded(country: country);
      } catch (_) {
        yield CountryError();
      }
    }

    if (event is FetchCountry) {
      try {
        final country = await fetchCountry(event.country);
        yield CountryInfoLoaded(country: country);
      } catch (_) {
        yield CountryError();
      }
    }
  }

  Future<Country> fetchGlobal() async {
    final response = await httpClient.get('$API/v2/all');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      try {
        return Country(
            country: 'Global',
            updated: int.parse(data['updated'].toString()),
            cases: int.parse(data['cases'].toString()),
            todayCases: int.parse(data['todayCases'].toString()),
            deaths: int.parse(data['deaths'].toString()),
            todayDeaths: int.parse(data['todayDeaths'].toString()),
            recovered: int.parse(data['recovered'].toString()),
            active: int.parse(data['active'].toString()),
            critical: int.parse(data['critical'].toString()),
            casesPerOneMillion:
                double.parse(data['casesPerOneMillion'].toString()),
            deathsPerOneMillion:
                double.parse(data['deathsPerOneMillion'].toString()),
            tests: int.parse(data['tests'].toString()),
            testsPerOneMillion:
                double.parse(data['testsPerOneMillion'].toString()),
            affectedCountries: int.parse(data['affectedCountries'].toString()),
            info: null);
      } catch (ex) {
        print(ex.toString());
      }
    } else {
      throw Exception('error fetching Countrys');
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

  Future<Country> fetchCountry(String country) async {
    final response = await httpClient.get('$API/v2/countries/$country');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Country(
          country: data['Country'],
          updated: int.parse(data['Country'].toString()),
          cases: int.parse(data['Country'].toString()),
          todayCases: int.parse(data['Country'].toString()),
          deaths: int.parse(data['Country'].toString()),
          todayDeaths: int.parse(data['Country'].toString()),
          recovered: int.parse(data['Country'].toString()),
          active: int.parse(data['Country'].toString()),
          critical: int.parse(data['Country'].toString()),
          casesPerOneMillion: double.parse(data['Country'].toString()),
          deathsPerOneMillion: double.parse(data['Country'].toString()),
          tests: int.parse(data['Country'].toString()),
          testsPerOneMillion: double.parse(data['Country'].toString()),
          affectedCountries: int.parse(data['Country'].toString()),
          info: null);
    } else {
      throw Exception('error fetching Countrys');
    }
  }
}
