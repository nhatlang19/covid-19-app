import 'package:covid19/model/country.dart';
import 'package:equatable/equatable.dart';

abstract class CountryEvent extends Equatable {
  final String country;

  const CountryEvent({this.country});

  @override
  List<Object> get props => [];
}

class FetchGlobal extends CountryEvent {}

class FetchCountries extends CountryEvent {}

class FetchCountry extends CountryEvent {
  @override
  List<Object> get props => [this.country];
}
