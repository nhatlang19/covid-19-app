import 'package:covid19/bloc/country/country_bloc.dart';
import 'package:covid19/bloc/country/country_state.dart';
import 'package:covid19/model/country.dart';
import 'package:covid19/utils/flag_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectCountry extends StatefulWidget {
  final Country selected;
  final Country global;

  SelectCountry({Key key, this.selected, this.global}) : super(key: key);

  @override
  SelectCountryState createState() => SelectCountryState();
}

class SelectCountryState extends State<SelectCountry> {
  TextEditingController editingController = TextEditingController();

  List<Country> duplicateItems = [];
  List<Country> items = [];

  CountryBloc _countryBloc;

  @override
  void initState() {
    _countryBloc = BlocProvider.of<CountryBloc>(context);
    _countryBloc.listen((onData) {
      print(onData);
      if (onData is CountriesLoaded) {
        duplicateItems = onData.countries;
        duplicateItems.insert(0, widget.global);
        items.addAll(duplicateItems);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Select Country'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(widget.selected),
          ),
        ],
      ),
      body: BlocBuilder<CountryBloc, CountryState>(
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
          if (state is CountriesLoaded) {
            return Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) {
                        filterSearchResults(value);
                      },
                      controller: editingController,
                      decoration: InputDecoration(
                        labelText: "Search",
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.black12,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            Navigator.of(context).pop(items[index]);
                          },
                          leading: ClipRect(
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: Image.network(
                                items[index].info != null
                                    ? FlagUtil.getFlagShiny(
                                        items[index].info.iso2)
                                    : FlagUtil.getFlagShiny('vi'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(items[index].country),
                          trailing: Text(items[index].cases.toString()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          return Container();
        },
      ),
    );
  }

  void filterSearchResults(String query) {
    List<Country> dummySearchList = List<Country>();
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List<Country> dummyListData = List<Country>();
      dummySearchList.forEach((item) {
        if (item.country.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }
}
