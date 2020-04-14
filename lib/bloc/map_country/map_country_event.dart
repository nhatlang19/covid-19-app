import 'package:covid19/model/country.dart';
import 'package:equatable/equatable.dart';

abstract class MapCountryEvent extends Equatable {
  final String country;

  const MapCountryEvent({this.country});

  @override
  List<Object> get props => [];
}

class FetchCountriesForMap extends MapCountryEvent {}
