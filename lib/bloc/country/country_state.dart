import 'package:covid19/model/country.dart';
import 'package:equatable/equatable.dart';

abstract class CountryState extends Equatable {
  const CountryState();

  @override
  List<Object> get props => [];
}

class CountryUninitialized extends CountryState {}

class CountryError extends CountryState {}

class CountryInfoLoaded extends CountryState {
  final Country country;
  final Country global;

  const CountryInfoLoaded({this.country, this.global});

  CountryInfoLoaded copyWith({Country country, Country global}) {
    return CountryInfoLoaded(
      country: country ?? this.country,
      global: global ?? this.global,
    );
  }

  @override
  List<Object> get props => [country, global];

  @override
  String toString() => 'CountryInfoLoaded { Info: ${country.country} }';
}

class CountriesLoaded extends CountryState {
  final List<Country> countries;

  const CountriesLoaded({
    this.countries,
  });

  CountriesLoaded copyWith({
    List<Country> countries,
    bool hasReachedMax,
  }) {
    return CountriesLoaded(
      countries: countries ?? this.countries,
    );
  }

  @override
  List<Object> get props => [countries];

  @override
  String toString() => 'CountryLoaded { countries: ${countries.length} }';
}
