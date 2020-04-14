import 'package:equatable/equatable.dart';

class Country extends Equatable {
  final String country;
  final int updated;
  final int cases;
  final int todayCases;
  final int deaths;
  final int todayDeaths;
  final int recovered;
  final int active;
  final int critical;
  final double casesPerOneMillion;
  final double deathsPerOneMillion;
  final int tests;
  final double testsPerOneMillion;
  final int affectedCountries;
  final CountryInfo info;

  const Country(
      {this.country,
      this.updated,
      this.cases,
      this.todayCases,
      this.deaths,
      this.todayDeaths,
      this.recovered,
      this.active,
      this.critical,
      this.casesPerOneMillion,
      this.deathsPerOneMillion,
      this.tests,
      this.testsPerOneMillion,
      this.affectedCountries,
      this.info});

  @override
  List<Object> get props => [
        this.country,
        this.updated,
        this.cases,
        this.todayCases,
        this.deaths,
        this.todayDeaths,
        this.recovered,
        this.active,
        this.critical,
        this.casesPerOneMillion,
        this.deathsPerOneMillion,
        this.tests,
        this.testsPerOneMillion,
        this.affectedCountries,
        this.info,
      ];

  @override
  String toString() => 'Country { country: $country }';
}

class CountryInfo extends Equatable {
  final int id;
  final String iso2;
  final String iso3;
  final double lat;
  final double long;
  final String flag;

  const CountryInfo(
      {this.id, this.iso2, this.iso3, this.lat, this.long, this.flag});

  @override
  List<Object> get props =>
      [this.id, this.iso2, this.iso3, this.lat, this.long, this.flag];

  @override
  String toString() => 'CountryInfo { id: $id }';
}
