import 'package:flutter/material.dart';
import 'package:flutter_native_dialog/flutter_native_dialog.dart';
import 'package:saving_our_planet/api_client.dart';
import 'package:saving_our_planet/pref_keys.dart';
import 'package:saving_our_planet/sanitry_ranking.dart';
import 'package:saving_our_planet/spacing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WashTab extends StatefulWidget {
  WashTab({Key key}) : super(key: key);

  @override
  _WashTabState createState() => _WashTabState();
}

class _WashTabState extends State<WashTab> {
  static const WASHED_HANDS_TODAY_AMOUNT_KEY = "WASHED_HANDS_TODAY_AMOUNT_KEY";
  static const LAST_WASH_HANDS_DATE_KEY = "";
  SanitryRankingResponse sanitryRankingResponse;
  bool rankByCities = true;

  int washedHandsHowManyTimesToday = -1;

  @override
  void initState() {
    initStoredData();
    fetchData();
    super.initState();
  }

  void initStoredData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(WASHED_HANDS_TODAY_AMOUNT_KEY)) {
      this.washedHandsHowManyTimesToday =
          prefs.getInt(WASHED_HANDS_TODAY_AMOUNT_KEY);
    } else {
      setState(() {
        this.washedHandsHowManyTimesToday = 0;
      });
    }

    await resetHandsWashedTodayIfNewDay();
  }

  Future fetchData() async {
    SanitryRankingResponse _sanitryRankingResponse =
        await ApiClient.fetchSanitryRanking();
    setState(() {
      this.sanitryRankingResponse = _sanitryRankingResponse;
      print(this.sanitryRankingResponse.byCities.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wash'),
      ),
      body: Container(
        margin: inset3,
        child: RefreshIndicator(
          onRefresh: fetchData,
          child: ListView(
            children: <Widget>[
              emojiRow(),
              dataWidget(),
              buttonRow(),
              Container(
                margin: inset4t,
                child: Text(
                  'Rankings',
                  style: Theme.of(context).textTheme.display1,
                ),
              ),
              Text(
                'See which countries and cities are washing their hands the most.',
              ),
              Container(
                margin: inset4t,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: inset2r,
                        child: tabWidget(
                          text: 'Cities',
                          selected: rankByCities,
                          onTap: () {
                            setState(() {
                              this.rankByCities = true;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: inset2r,
                        child: tabWidget(
                          text: 'Countries',
                          selected: !rankByCities,
                          onTap: () {
                            setState(() {
                              this.rankByCities = false;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ...selectedSanitryRankings().map((ranking) {
                return ListTile(
                  title: Text(ranking.name),
                  trailing: Text(ranking.score.toString()),
                );
              }).toList()
            ],
          ),
        ),
      ),
    );
  }

  List<SanitryRanking> selectedSanitryRankings() {
    List<SanitryRanking> result = [];

    if (this.sanitryRankingResponse != null) {
      if (rankByCities) {
        return this.sanitryRankingResponse.byCities;
      } else {
        return this.sanitryRankingResponse.byCountries;
      }
    }

    return result;
  }

  Widget tabWidget({VoidCallback onTap, bool selected, String text}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40.0,
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.subtitle.copyWith(
                  color: selected ? Colors.white : Color(0xFF62B4FF),
                ),
          ),
        ),
        decoration: BoxDecoration(
          color: selected ? Color(0xFF62B4FF) : Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }

  Widget buttonRow() {
    return Container(
      margin: inset4t,
      child: FlatButton(
        color: Theme.of(context).primaryColor,
        onPressed: _washedMyHandsTapped,
        child: Text(
          'JUST WASHED MY HANDS',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget emojiRow() {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.display2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            '😧',
            style: TextStyle(
                color: Colors.grey.withOpacity(
                    this.washedHandsHowManyTimesToday >= 0 ? 1 : 0.5)),
          ),
          Text(
            '😐',
            style: TextStyle(
                color: Colors.grey.withOpacity(
                    this.washedHandsHowManyTimesToday >= 1 ? 1 : 0.5)),
          ),
          Text(
            '😃',
            style: TextStyle(
                color: Colors.grey.withOpacity(
                    this.washedHandsHowManyTimesToday >= 2 ? 1 : 0.5)),
          ),
          Text(
            '😎',
            style: TextStyle(
                color: Colors.grey.withOpacity(
                    this.washedHandsHowManyTimesToday >= 3 ? 1 : 0.5)),
          ),
        ],
      ),
    );
  }

  Widget dataWidget() {
    return Container(
      margin: inset4t,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: inset3b,
            child: Text(
              this.washedHandsHowManyTimesToday.toString(),
              style: Theme.of(context).textTheme.display4.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
      height: 200.0,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/wash_background.png"),
        fit: BoxFit.contain,
      )),
    );
  }

  _washedMyHandsTapped() async {
    final result = await FlutterNativeDialog.showConfirmDialog(
      title: "Did you just wash your hands?",
      positiveButtonText: "Yes",
      negativeButtonText: "No",
    );

    if (!result) {
      return;
    }

    await resetHandsWashedTodayIfNewDay();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      this.washedHandsHowManyTimesToday++;
    });
    prefs.setInt(
        WASHED_HANDS_TODAY_AMOUNT_KEY, this.washedHandsHowManyTimesToday);
    prefs.setInt(
        LAST_WASH_HANDS_DATE_KEY, DateTime.now().millisecondsSinceEpoch);

    ApiClient.inputSanitryEntry(
        prefs.getString(CITY_ID_KEY), prefs.getString(COUNTRY_ID_KEY));
  }

  Future resetHandsWashedTodayIfNewDay() async {
    final now = DateTime.now();
    final lastMidnight = new DateTime(now.year, now.month, now.day);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(LAST_WASH_HANDS_DATE_KEY)) {
      int lastRecorded = prefs.getInt(LAST_WASH_HANDS_DATE_KEY);
      if (lastMidnight.millisecondsSinceEpoch > lastRecorded) {
        this.washedHandsHowManyTimesToday = 0;
        prefs.setInt(
            WASHED_HANDS_TODAY_AMOUNT_KEY, this.washedHandsHowManyTimesToday);
      }
    }
  }
}
