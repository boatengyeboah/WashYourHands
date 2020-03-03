import 'package:flutter/material.dart';
import 'package:saving_our_planet/api_client.dart';
import 'package:saving_our_planet/country.dart';
import 'package:saving_our_planet/main_tabs.dart';
import 'package:saving_our_planet/pref_keys.dart';
import 'package:saving_our_planet/spacing.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetCountry extends StatefulWidget {
  SetCountry({Key key}) : super(key: key);

  @override
  _SetCountryState createState() => _SetCountryState();
}

class _SetCountryState extends State<SetCountry> {
  List<PlaceData> countries = [];
  List<PlaceData> states = [];
  List<PlaceData> cities = [];
  PlaceData selectedCountry;
  PlaceData selectedState;
  PlaceData selectedCity;

  @override
  void initState() {
    fetchCountries();
    super.initState();
  }

  fetchCountries() async {
    List<PlaceData> _countries = await ApiClient.fetchCountries();
    setState(() {
      this.countries = _countries;
    });
  }

  fetchStateData() async {
    List<PlaceData> _states = await ApiClient.fetchStates(selectedCountry.id);
    setState(() {
      this.states = _states;
    });
  }

  fetchCities() async {
    List<PlaceData> _cities = await ApiClient.fetchCities(selectedState.id);
    setState(() {
      this.cities = _cities;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Where are you?'),
      ),
      body: Container(
        margin: inset3,
        child: ListView(
          children: <Widget>[
            Text(
                "We'll use this data to show you relevant information based on your location."),
            Container(
              margin: inset5t,
              child: SearchableDropdown<PlaceData>(
                items: this.countries.map((country) {
                  return DropdownMenuItem<PlaceData>(
                    child: Text(country.name),
                    value: country,
                  );
                }).toList(),
                onChanged: (country) {
                  setState(() {
                    this.selectedCountry = country;
                    fetchStateData();
                  });
                },
                label: 'Select your country',
                searchFn:
                    (String keyword, List<DropdownMenuItem<PlaceData>> items) {
                  return searchFn(items, keyword);
                },
              ),
            ),
            if (selectedCountry != null) ...[
              Container(
                margin: inset5t,
                child: SearchableDropdown<PlaceData>(
                  items: states.map((state) {
                    return DropdownMenuItem<PlaceData>(
                      child: Text(state.name),
                      value: state,
                    );
                  }).toList(),
                  onChanged: (state) {
                    setState(() {
                      this.selectedState = state;
                      fetchCities();
                    });
                  },
                  label: 'Select your state',
                  searchFn: (String keyword,
                      List<DropdownMenuItem<PlaceData>> items) {
                    return searchFn(items, keyword);
                  },
                ),
              ),
            ],
            if (selectedState != null) ...[
              Container(
                margin: inset5t,
                child: SearchableDropdown<PlaceData>(
                  items: cities.map((city) {
                    return DropdownMenuItem<PlaceData>(
                      child: Text(city.name),
                      value: city,
                    );
                  }).toList(),
                  onChanged: (city) {
                    setState(() {
                      this.selectedCity = city;
                    });
                  },
                  label: 'Select your city',
                  searchFn: (String keyword,
                      List<DropdownMenuItem<PlaceData>> items) {
                    return searchFn(items, keyword);
                  },
                ),
              ),
            ],
            Container(
              margin: inset4t,
              child: FlatButton(
                color: Theme.of(context)
                    .primaryColor
                    .withOpacity(isInputValid() ? 1 : 0.5),
                onPressed: _submitTapped,
                child: Text(
                  'Continue',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<int> searchFn(List<DropdownMenuItem<PlaceData>> items, String keyword) {
    List<int> shownIndexes = [];

    int i = 0;
    items.forEach((item) {
      if (item.value.name.toLowerCase().contains(keyword.toLowerCase())) {
        shownIndexes.add(i);
      }
      i++;
    });
    return shownIndexes;
  }

  bool isInputValid() {
    return this.selectedCity != null &&
        this.selectedCountry != null &&
        this.selectedState != null;
  }

  _submitTapped() async {
    if (!isInputValid()) {
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(COUNTRY_DATA_SET_KEY, true);
    prefs.setString(COUNTRY_ID_KEY, this.selectedCountry.id);
    prefs.setString(STATE_ID_KEY, this.selectedState.id);
    prefs.setString(CITY_ID_KEY, this.selectedCity.id);

    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => MainTabs(),
    ));
  }
}
