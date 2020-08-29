import 'package:TWENTY_FORTY_EIGHT_GAME/screens/about_screen.dart';
import 'package:TWENTY_FORTY_EIGHT_GAME/screens/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'loading_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    showAlertDialog(BuildContext context, String titleContent,
        String messageContent, String button1Content, String button2Content) {
      Widget buttonTwo = FlatButton(
        child: Text(
          button2Content,
          style: TextStyle(
            color: Colors.black,
            fontSize: 19.0,
          ),
        ),
        onPressed: () {
          if (button2Content == 'No') {
            Navigator.pop(context);
          } else if (button2Content == 'Next') {
            Navigator.pop(context);
            showAlertDialog(
                context,
                'Controls',
                '-Swipe up to move the tiles up.\n-Swipe down to move the tiles down.\n-Swipe left to move the tiles left.\n-Swipe right to move the tiles right.',
                'Back',
                'Play');
          } else if (button2Content == 'Play') {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return GameScreen();
            }));
          }
        },
      );
      Widget buttonOne = FlatButton(
        child: Text(
          button1Content,
          style: TextStyle(
            color: Colors.black,
            fontSize: 19.0,
          ),
        ),
        onPressed: () {
          if (button1Content == 'Yes') {
            SystemNavigator.pop();
          } else if (button1Content == 'Back') {
            Navigator.pop(context);
          }
        },
      );

      AlertDialog alert = AlertDialog(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            titleContent,
            style: TextStyle(
              fontSize: 28.0,
              fontFamily: 'RobotoMono',
            ),
          ),
        ),
        content: Text(
          messageContent,
          style: TextStyle(
            color: Colors.black,
            fontSize: 19.0,
            fontFamily: 'RobotoMono',
          ),
        ),
        actions: [
          buttonOne,
          buttonTwo,
        ],
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    final buttonStart = Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          showAlertDialog(
              context,
              'Instructions',
              "     The objective of this game is to combine the numbers displayed on the tiles, by moving the tiles around. When two equal tiles have the same numbers and collide, they combine to give you one greater tile that displays their sum and also increase your score. Do this until you reach 2048 tile to win the game. But if you didn't reached 2048 tile and the board fills up, the game is over.",
              'Back',
              'Next');
        },
        padding: EdgeInsets.all(12),
        color: Colors.black,
        child: Text('Start',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            )),
      ),
    );

    final buttonHighScores = Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return LoadingScreen();
          }));
        },
        padding: EdgeInsets.all(12),
        color: Colors.black,
        child: Text('High Scores',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            )),
      ),
    );

    final buttonAbout = Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return AboutScreen();
          }));
        },
        padding: EdgeInsets.all(12),
        color: Colors.black,
        child: Text('About',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            )),
      ),
    );

    final buttonExit = Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          showAlertDialog(context, 'Attention',
              'Are you sure you want to exit?', 'Yes', 'No');
        },
        padding: EdgeInsets.all(12),
        color: Colors.black,
        child: Text('Exit',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            )),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('2048'),
      ),
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [const Color(0xFFFFFFFF), const Color(0xFFFFFFFF)])),
          padding: EdgeInsets.all(0),
          child: Column(
            children: <Widget>[
              Center(
                child: Container(
                  color: Colors.orange[100],
                  width: 335,
                  margin: EdgeInsets.symmetric(vertical: 0),
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Text(
                    'The 2048 is a sliding block puzzle game with a 4×4 grid.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              buttonStart,
              buttonHighScores,
              buttonAbout,
              buttonExit,
            ],
          )),
    );
  }
}
