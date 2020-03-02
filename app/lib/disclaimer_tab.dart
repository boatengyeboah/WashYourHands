import 'package:flutter/material.dart';
import 'package:saving_our_planet/spacing.dart';
import 'package:url_launcher/url_launcher.dart';

class DisclaimerTab extends StatefulWidget {
  DisclaimerTab({Key key}) : super(key: key);

  @override
  _DisclaimerTabState createState() => _DisclaimerTabState();
}

class _DisclaimerTabState extends State<DisclaimerTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disclaimer'),
      ),
      body: Container(
        padding: inset3,
        child: ListView(
          children: <Widget>[
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: 'This app was created by: '),
                  WidgetSpan(
                    child: GestureDetector(
                        onTap: () {
                          launch('https://twitter.com/_kboy_');
                        },
                        child: Text(
                          '@_kboy_, ',
                          style: Theme.of(context).textTheme.body1.copyWith(
                                color: Color(0xFF62B4FF),
                                fontWeight: FontWeight.bold,
                              ),
                        )),
                  ),
                  WidgetSpan(
                    child: GestureDetector(
                        onTap: () {
                          launch('https://twitter.com/tundeoalao');
                        },
                        child: Text(
                          '@tundeoalao & ',
                          style: Theme.of(context).textTheme.body1.copyWith(
                                color: Color(0xFF62B4FF),
                                fontWeight: FontWeight.bold,
                              ),
                        )),
                  ),
                  WidgetSpan(
                    child: GestureDetector(
                        onTap: () {
                          launch('https://twitter.com/landon_vh');
                        },
                        child: Text(
                          '@landon_vh',
                          style: Theme.of(context).textTheme.body1.copyWith(
                                color: Color(0xFF62B4FF),
                                fontWeight: FontWeight.bold,
                              ),
                        )),
                  )
                ],
                style: Theme.of(context).textTheme.body1,
              ),
            ),
            Container(
              margin: inset3t,
              child: Text("All content found on this website, " +
                  "including: text, images, audio, or other formats were created " +
                  "for informational purposes only. Offerings for continuing education " +
                  "credits are clearly identified and the appropriate target audience is " +
                  "identified. The Content is not intended to be a substitute for professional" +
                  " medical advice, diagnosis, or treatment. Always seek the advice of your" +
                  " physician or other qualified health provider with any questions you may " +
                  "have regarding a medical condition. Never disregard professional" +
                  " medical advice or delay in seeking it because of something you have read on this Website.\n\n" +
                  "If you think you may have a medical emergency, call your doctor, go to the emergency department," +
                  " or call 911 immediately. This app does not recommend or endorse any specific tests," +
                  " physicians, products, procedures, opinions, or other information that may be mentioned" +
                  " on this app.\n\n" +
                  "Links to educational content not created by by this app" +
                  " are taken at your own risk. "),
            ),
            Container(
              margin: inset4t,
              child: Text(
                'Credits & Sources',
                style: Theme.of(context).textTheme.display1,
              ),
            ),
            Container(
              margin: inset3t,
              child: Text('https://coronavirus.app/\n'),
            ),
            Text('World Health Organization News\n'),
            Text('NewsAPI.org\n'),
            Text(
                'https://github.com/hiiamrohit/Countries-States-Cities-database\n'),
          ],
        ),
      ),
    );
  }
}
