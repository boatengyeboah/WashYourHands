import 'package:flutter/material.dart';
import 'package:saving_our_planet/spacing.dart';

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
            Text("All content found on this website, " +
                "including: text, images, audio, or other formats were created " +
                "for informational purposes only. Offerings for continuing education " +
                "credits are clearly identified and the appropriate target audience is " +
                "identified. The Content is not intended to be a substitute for professional" +
                " medical advice, diagnosis, or treatment. Always seek the advice of your" +
                " physician or other qualified health provider with any questions you may " +
                "have regarding a medical condition. Never disregard professional" +
                " medical advice or delay in seeking it because of something you have read on this Website.\n\n" +
                "If you think you may have a medical emergency, call your doctor, go to the emergency department," +
                " or call 911 immediately. Dannemiller does not recommend or endorse any specific tests," +
                " physicians, products, procedures, opinions, or other information that may be mentioned" +
                " on Dannemiller.com. Reliance on any information provided by Dannemiller.com, Dannemiller" +
                " employees, contracted writers, or medical professionals presenting content for" +
                " publication to Dannemiller is solely at your own risk.\n\n" +
                "Links to educational content not created by YSplit" +
                " are taken at your own risk. "),
          ],
        ),
      ),
    );
  }
}
