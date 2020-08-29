import 'package:TWENTY_FORTY_EIGHT_GAME/utilities/user_scores.dart';
import 'package:flutter/material.dart';
import 'package:TWENTY_FORTY_EIGHT_GAME/utilities/constants.dart';
import 'package:date_format/date_format.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:TWENTY_FORTY_EIGHT_GAME/utilities/score_db.dart'
    as score_database;

class ScoreScreen extends StatelessWidget {
  final query;
  ScoreScreen({this.query});

  List<TableRow> createRow(var x) {
    Comparator<Score> priceComparator =
        (a, b) => b.userScore.compareTo(a.userScore);
    // sort the top 10 only from lowest to highest scores
    x.sort(priceComparator);

    List<TableRow> rows = [];
    rows.add(
      TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Center(
              child: Text(
                "Rank",
                style: highScoreTableHeaders,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Center(
              child: Text(
                "Date",
                style: highScoreTableHeaders,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Center(
              child: Text(
                "Score",
                style: highScoreTableHeaders,
              ),
            ),
          ),
        ],
      ),
    );

    int numOfRows = x.length;
    List<String> topRanks = ["🥇", "🥈", "🥉"];
    for (var i = 0; i < numOfRows && i < 10; i++) {
      // for scores
      var row = x[i].toString().split(",");
      // for dates
      var date = row[1].split(" ")[0].split("-");
      var scoreDate = formatDate(
          DateTime(int.parse(date[0]), int.parse(date[1]), int.parse(date[2])),
          [yy, '-', M, '-', d]);

      Widget item = TableCell(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            i < 3 ? topRanks[i] + '${i + 1}' : '${i + 1}',
            style: highScoreTableRowsStyle,
            textAlign: TextAlign.center,
          ),
        ),
      );
      Widget item1 = TableCell(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '$scoreDate',
              style: highScoreTableRowsStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
      Widget item2 = TableCell(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            '${addCommas(row[0])}',
            style: highScoreTableRowsStyle,
            textAlign: TextAlign.center,
          ),
        ),
      );
      rows.add(
        TableRow(
          children: [item, item1, item2],
        ),
      );
    }
    return rows;
  }

  String addCommas(String x) {
    String output = x.replaceAllMapped(
        new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    return output;
  }

  showAlertDialog(BuildContext context) {
    Widget noButton = FlatButton(
      child: Text(
        "No",
        style: TextStyle(
          color: Colors.black,
          fontSize: 19.0,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget yesButton = FlatButton(
      child: Text(
        "Yes",
        style: TextStyle(
          color: Colors.black,
          fontSize: 19.0,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
        Navigator.popUntil(context, ModalRoute.withName('/'));
        score_database.deleteDB();
      },
    );

    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      title: Center(
        child: Text(
          "Attention",
          style: TextStyle(
              color: Colors.black, fontSize: 28.0, fontFamily: 'RobotoMono'),
        ),
      ),
      content: Text(
        "Are you sure you want to delete all scores permanently?",
        style: TextStyle(
            color: Colors.black, fontSize: 19.0, fontFamily: 'RobotoMono'),
      ),
      actions: [
        yesButton,
        noButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: query.length == 0
            ? Stack(
                children: <Widget>[
                  Center(
                    child: Text(
                      "No Scores Yet!",
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.black,
                        fontFamily: 'RobotoMono',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(6.0, 10.0, 6.0, 15.0),
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      tooltip: 'Home',
                      iconSize: 35,
                      icon: Icon(MdiIcons.arrowLeft),
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              )
            : Column(
                children: <Widget>[
                  Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(6.0, 10.0, 6.0, 15.0),
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          tooltip: 'Home',
                          iconSize: 35,
                          icon: Icon(MdiIcons.arrowLeft),
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 15.0),
                          child: Text(
                            'High Scores',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 32,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(6.0, 10.0, 6.0, 15.0),
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          tooltip: 'Delete',
                          iconSize: 33,
                          icon: Icon(MdiIcons.delete),
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onPressed: () {
                            showAlertDialog(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 15.0),
                      child: Text(
                        'Top 10 only',
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 31,
                          fontFamily: 'RobotoMono',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        textBaseline: TextBaseline.alphabetic,
                        children: createRow(query),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
