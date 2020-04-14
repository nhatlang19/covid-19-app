import 'package:covid19/model/country.dart';
import 'package:equatable/equatable.dart';

abstract class MapCountryState extends Equatable {
  const MapCountryState();

  @override
  List<Object> get props => [];
}

class MapCountryUninitialized extends MapCountryState {}

class MapCountryError extends MapCountryState {}

class MapCountriesLoaded extends MapCountryState {
  final List<Country> countries;

  const MapCountriesLoaded({
    this.countries,
  });

  MapCountriesLoaded copyWith({
    List<Country> countries,
    bool hasReachedMax,
  }) {
    return MapCountriesLoaded(
      countries: countries ?? this.countries,
    );
  }

  @override
  List<Object> get props => [countries];

  @override
  String toString() => 'CountryLoaded { countries: ${countries.length} }';
}
