import 'package:flutter/material.dart';
import 'package:flutter_native_dialog/flutter_native_dialog.dart';
import 'package:saving_our_planet/spacing.dart';

class WashTab extends StatefulWidget {
  WashTab({Key key}) : super(key: key);

  @override
  _WashTabState createState() => _WashTabState();
}

class _WashTabState extends State<WashTab> {
  @override
  void initState() {
    initStoredData();
    fetchData();
    super.initState();
  }

  void initStoredData() {

  }

  Future fetchData() {

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
              )
            ],
          ),
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
          Text('😧'),
          Text('😐'),
          Text('😃'),
          Text('😎'),
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
              '4',
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
  }
}
