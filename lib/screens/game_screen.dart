import 'package:TWENTY_FORTY_EIGHT_GAME/utilities/user_scores.dart';
import 'package:flutter/material.dart';
import 'package:TWENTY_FORTY_EIGHT_GAME/game_logic.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:TWENTY_FORTY_EIGHT_GAME/utilities/score_db.dart'
    as score_database;

// ignore: non_constant_identifier_names
final BoxColors = <int, Color>{
  2: Colors.orange[50],
  4: Colors.orange[100],
  8: Colors.orange[200],
  16: Colors.orange[300],
  32: Colors.orange[400],
  64: Colors.orange[500],
  128: Colors.orange[600],
  256: Colors.orange[700],
  512: Colors.orange[800],
  1024: Colors.orange[900],
  2048: Colors.deepOrange,
};

bool gameOverForBackAppBar = false;
int scoreForBackAppBar = 0;

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('2048: Playing'),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            if (gameOverForBackAppBar == false && scoreForBackAppBar != 0) {
              _GameWidgetState gameWidgetStateObject = new _GameWidgetState();
              gameWidgetStateObject.showAlertDialog(
                  context,
                  'Attention',
                  'Do you want to quit the game?\n\n  If you quit, your current score right now will not saved.',
                  'Yes, I want to quit',
                  'No');
            } else if (gameOverForBackAppBar == true ||
                scoreForBackAppBar == 0) {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            }
          },
        ),
      ),
      body: GameWidget(),
    );
  }
}

class BoardGridWidget extends StatelessWidget {
  final _GameWidgetState _state;
  BoardGridWidget(this._state);
  @override
  Widget build(BuildContext context) {
    final boardSize = _state.boardSize();
    double width =
        (boardSize.width - (_state.column + 1) * _state.cellPadding) /
            _state.column;
    List<CellBox> _backgroundBox = List<CellBox>();
    for (int r = 0; r < _state.row; ++r) {
      for (int c = 0; c < _state.column; ++c) {
        CellBox box = CellBox(
          left: c * width + _state.cellPadding * (c + 1),
          top: r * width + _state.cellPadding * (r + 1),
          size: width,
          color: Colors.grey[300],
        );
        _backgroundBox.add(box);
      }
    }
    return Positioned(
        left: 0.0,
        top: 0.0,
        child: Container(
          width: _state.boardSize().width,
          height: _state.boardSize().height,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Stack(
            children: _backgroundBox,
          ),
        ));
  }
}

class GameWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GameWidgetState();
  }
}

class _GameWidgetState extends State<GameWidget> {
  final database = score_database.openDB();
  Game _game;
  MediaQueryData _queryData;
  final int row = 4;
  final int column = 4;
  final double cellPadding = 5.0;
  final EdgeInsets _gameMargin = EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0);
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _game = Game(row, column);
    newGame();
  }

  void newGame() {
    _game.init();
    setState(() {});
    gameOverForBackAppBar = false;
    scoreForBackAppBar = _game.scoreWithOutCommas;
  }

  void moveLeft() {
    setState(() {
      _game.moveLeft();
      checkGameOver();
    });
  }

  void moveRight() {
    setState(() {
      _game.moveRight();
      checkGameOver();
    });
  }

  void moveUp() {
    setState(() {
      _game.moveUp();
      checkGameOver();
    });
  }

  void moveDown() {
    setState(() {
      _game.moveDown();
      checkGameOver();
    });
  }

  void checkGameOver() {
    onPlayAudio("assets/audios/moved.wav");
    if (_game.isGameOver()) {
      onPlayAudio("assets/audios/gameover.wav");
      // insert in the database
      Score score = Score(
          id: 1,
          scoreDate: DateTime.now().toString(),
          userScore: _game.scoreWithOutCommas);
      // manipulate the databaase
      score_database.manipulateDatabase(score, database);
      gameOverForBackAppBar = true;
      showAlertDialog(context, 'Game Over',
          'Your score is saved. Do you want to restart the game?', 'Yes', 'No');
    }
    scoreForBackAppBar = _game.scoreWithOutCommas;
  }

  void onPlayAudio(String path) async {
    AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
    assetsAudioPlayer.open(
      Audio(path),
    );
  }

  void showAlertDialog(BuildContext context, String titleContent,
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
          Navigator.pop(context);
          newGame();
        } else if (button1Content == 'Yes, I want to quit') {
          Navigator.pop(context);
          Navigator.popUntil(context, ModalRoute.withName('/'));
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

  @override
  Widget build(BuildContext context) {
    List<CellWidget> _cellWidgets = List<CellWidget>();
    for (int r = 0; r < row; ++r) {
      for (int c = 0; c < column; ++c) {
        _cellWidgets.add(CellWidget(cell: _game.get(r, c), state: this));
      }
    }
    _queryData = MediaQuery.of(context);
    List<Widget> children = List<Widget>();
    children.add(BoardGridWidget(this));
    children.addAll(_cellWidgets);
    return Column(
      children: <Widget>[
        Container(
          color: Colors.orange[100],
          child: Container(
            width: 330,
            height: 80,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Score: " + _game.scoreWithCommas,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(
          height: 35,
        ),
        
        Container(
            margin: _gameMargin,
            width: _queryData.size.width,
            height: _queryData.size.width,
            child: GestureDetector(
              onVerticalDragUpdate: (detail) {
                if (detail.delta.distance == 0 || _isDragging) {
                  return;
                }
                if (!_game.isGameOver()) {
                  _isDragging = true;
                  if (detail.delta.direction > 0) {
                    moveDown();
                  } else {
                    moveUp();
                  }
                }
              },
              onVerticalDragEnd: (detail) {
                _isDragging = false;
              },
              onVerticalDragCancel: () {
                _isDragging = false;
              },
              onHorizontalDragUpdate: (detail) {
                if (detail.delta.distance == 0 || _isDragging) {
                  return;
                }
                if (!_game.isGameOver()) {
                  _isDragging = true;
                  if (detail.delta.direction > 0) {
                    moveLeft();
                  } else {
                    moveRight();
                  }
                }
              },
              onHorizontalDragDown: (detail) {
                _isDragging = false;
              },
              onHorizontalDragCancel: () {
                _isDragging = false;
              },
              child: Stack(
                children: children,
              ),
            )),
        FloatingActionButton(
          onPressed: () {
            showAlertDialog(context, 'Attention',
                'Do you want to restart the game?', 'Yes', 'No');
          },
          tooltip: 'Restart',
          child: Icon(
            Icons.refresh,
            color: Colors.white,
          ),
          backgroundColor: Colors.black,
        ),
      ],
    );
  }

  Size boardSize() {
    assert(_queryData != null);
    Size size = _queryData.size;
    num width = size.width - _gameMargin.left - _gameMargin.right;
    return Size(width, width);
  }
}

class AnimatedCellWidget extends AnimatedWidget {
  final BoardCell cell;
  final _GameWidgetState state;
  AnimatedCellWidget(
      {Key key, this.cell, this.state, Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    double animationValue = animation.value;
    Size boardSize = state.boardSize();
    double width = (boardSize.width - (state.column + 1) * state.cellPadding) /
        state.column;
    if (cell.number == 0) {
      return Container();
    } else {
      return CellBox(
        left: (cell.column * width + state.cellPadding * (cell.column + 1)) +
            width / 2 * (1 - animationValue),
        top: cell.row * width +
            state.cellPadding * (cell.row + 1) +
            width / 2 * (1 - animationValue),
        size: width * animationValue,
        color: BoxColors.containsKey(cell.number)
            ? BoxColors[cell.number]
            : BoxColors[BoxColors.keys.last],
        text: Text(
          cell.number.toString(),
          maxLines: 1,
          style: TextStyle(
            fontSize: 30.0 * animationValue,
            fontWeight: FontWeight.bold,
            color: cell.number < 32 ? Colors.grey[600] : Colors.grey[50],
          ),
        ),
      );
    }
  }
}

class CellWidget extends StatefulWidget {
  final BoardCell cell;
  final _GameWidgetState state;
  CellWidget({this.cell, this.state});
  _CellWidgetState createState() => _CellWidgetState();
}

class _CellWidgetState extends State<CellWidget>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(
        milliseconds: 200,
      ),
      vsync: this,
    );
    animation = new Tween(begin: 0.0, end: 1.0).animate(controller);
  }

  dispose() {
    controller.dispose();
    super.dispose();
    widget.cell.isNew = false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cell.isNew && !widget.cell.isEmpty()) {
      controller.reset();
      controller.forward();
      widget.cell.isNew = false;
    } else {
      controller.animateTo(1.0);
    }
    return AnimatedCellWidget(
      cell: widget.cell,
      state: widget.state,
      animation: animation,
    );
  }
}

class CellBox extends StatelessWidget {
  final double left;
  final double top;
  final double size;
  final Color color;
  final Text text;
  CellBox({this.left, this.top, this.size, this.color, this.text});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
          width: size,
          height: size,
          padding: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Center(
              child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: text))),
    );
  }
}
