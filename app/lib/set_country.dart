import 'package:flutter/material.dart';
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
  Country selectedCountry;
  Country selectedState;
  Country selectedCity;

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
              child: SearchableDropdown<Country>(
                items: fakeCountries().map((country) {
                  return DropdownMenuItem<Country>(
                    child: Text(country.name),
                    value: country,
                  );
                }).toList(),
                onChanged: (country) {
                  setState(() {
                    this.selectedCountry = country;
                  });
                },
                label: 'Select your country',
              ),
            ),
            Container(
              margin: inset5t,
              child: SearchableDropdown<Country>(
                items: fakeCountries().map((state) {
                  return DropdownMenuItem<Country>(
                    child: Text(state.name),
                    value: state,
                  );
                }).toList(),
                onChanged: (state) {
                  setState(() {
                    this.selectedState = state;
                  });
                },
                label: 'Select your state',
              ),
            ),
            Container(
              margin: inset5t,
              child: SearchableDropdown<Country>(
                items: fakeCountries().map((city) {
                  return DropdownMenuItem<Country>(
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
              ),
            ),
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

  List<Country> fakeCountries() {
    List<Country> result = [];

    result.add(Country(id: '1', name: 'United States'));
    result.add(Country(id: '2', name: 'United Kingdom'));

    return result;
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
