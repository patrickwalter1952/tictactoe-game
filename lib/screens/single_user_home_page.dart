import 'dart:math';

import 'package:flutter/material.dart';

import '../models/board.dart';
import '../services/utils.dart';

class SingleUserHomePage extends StatefulWidget {
  @override
  _SingleUserHomePageState createState() => _SingleUserHomePageState();
}

class _SingleUserHomePageState extends State<SingleUserHomePage> {
  int nbrSquares = BoardID.BoardID_8X8.size;
  int nbrRows = BoardID.BoardID_8X8.rowsCols;
  int nbrColumns = BoardID.BoardID_8X8.rowsCols;

  // 1st player is X
  bool xTurn = true;
  late List<String> displayElement;
  int oScore = 0;
  int xScore = 0;
  int filledBoxes = 0;
  String selectedBoardSize = "";

  @override
  void initState() {
    super.initState();
    selectedBoardSize = BoardID.BoardID_8X8.id;
    displayElement = List.filled(nbrSquares, '', growable: true);

    _clearBoard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title : const Text("Single User - Tic Tac Toe"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 2.0, 16.0, 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Build and display Players and the Scores
            buildPlayersAndScores(),

            Column(
              children: [
                Text(
                  "The Selected Board Size: $selectedBoardSize",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),

            //Build and display the tic-tac-toe board
            buildTicTacToeBoard(),

            //Build and display to select tic-tac-toe board size
            buildSelectBoardSize(),

            //Build and display Clear Board button
            buildClearScoreBoard(),

          ],
        ),
      ),
    );
  }

  ///
  /// Build and display clear score board button
  ///
  Padding buildClearScoreBoard() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: _clearBoard,
            child: const Text(
              "Clear Score Board",
            ),
          ),
        ],
      ),
    );
  }

  ///
  /// Build and display selected tic-tac-toe board size
  ///
  Column buildSelectBoardSize() {

    final myButtonStyle = ElevatedButton.styleFrom(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
      minimumSize: const Size(40, 30),
      maximumSize: const Size(66, 30),
      backgroundColor: Colors.blue,
    );

    return Column(
      children: [
        const Text(
          "Select the Tic-Tac-Toe Board Size",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Padding(
          padding: const EdgeInsets.all(1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(

                style: myButtonStyle,
                onPressed: () {
                  nbrSquares = BoardID.BoardID_3X3.size;
                  nbrColumns = BoardID.BoardID_3X3.rowsCols;
                  nbrRows = nbrColumns;
                  _clearBoard();
                  selectedBoardSize = BoardID.BoardID_3X3.id;
                },
                child: Text(BoardID.BoardID_3X3.id),
              ),
              ElevatedButton(
                style: myButtonStyle,
                onPressed: () {
                  nbrSquares = BoardID.BoardID_4X4.size;
                  nbrColumns = BoardID.BoardID_4X4.rowsCols;
                  nbrRows = nbrColumns;
                  _clearBoard();
                  selectedBoardSize = BoardID.BoardID_4X4.id;
                },
                child: Text(BoardID.BoardID_4X4.id),
              ),
              ElevatedButton(
                style: myButtonStyle,
                onPressed: () {
                  nbrSquares = BoardID.BoardID_5X5.size;
                  nbrColumns = BoardID.BoardID_5X5.rowsCols;
                  nbrRows = nbrColumns;
                  _clearBoard();
                  selectedBoardSize = BoardID.BoardID_5X5.id;
                },
                child: Text(BoardID.BoardID_5X5.id),
              ),
              ElevatedButton(
                style: myButtonStyle,
                onPressed: () {
                  nbrSquares = BoardID.BoardID_6X6.size;
                  nbrColumns = BoardID.BoardID_6X6.rowsCols;
                  nbrRows = nbrColumns;
                  _clearBoard();
                  selectedBoardSize = BoardID.BoardID_6X6.id;
                },
                child: Text(BoardID.BoardID_6X6.id),
              ),
              ElevatedButton(
                style: myButtonStyle,
                onPressed: () {
                  nbrSquares = BoardID.BoardID_7X7.size;
                  nbrColumns = BoardID.BoardID_7X7.rowsCols;
                  nbrRows = nbrColumns;
                  _clearBoard();
                  selectedBoardSize = BoardID.BoardID_7X7.id;
                },
                child: Text(BoardID.BoardID_7X7.id),
              ),
              ElevatedButton(
                style: myButtonStyle,
                onPressed: () {
                  nbrSquares = BoardID.BoardID_8X8.size;
                  nbrColumns = BoardID.BoardID_8X8.rowsCols;
                  nbrRows = nbrColumns;
                  _clearBoard();
                  selectedBoardSize = BoardID.BoardID_8X8.id;
                },
                child: Text(BoardID.BoardID_8X8.id),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ///
  /// display and update players and the scores
  ///
  Padding buildPlayersAndScores() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Player X',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      xScore.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Player O',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    Text(
                      oScore.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///
  /// Build the Tic-Tac-Toe Board
  ///
  Expanded buildTicTacToeBoard() {
    return Expanded(
      child: GridView.builder(
          itemCount: nbrSquares,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: sqrt(nbrSquares).round()),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                _tapped(index);
              },
              child: Container(
                decoration:
                BoxDecoration(border: Border.all(color: Colors.white)),
                child: Center(
                  child: Text(
                    displayElement[index],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  ///
  /// filling the boxes when tapped with X
  /// or O respectively and then checking the winner function
  ///
  void _tapped(int index) {
    setState(() {
      if (!xTurn && displayElement[index] == '') {
        displayElement[index] = 'O';
        filledBoxes++;
      } else if (xTurn && displayElement[index] == '') {
        displayElement[index] = 'X';
        filledBoxes++;
      }

      xTurn = !xTurn;
      _checkWinner();
    });
  }

  ///
  /// check for the winner in the game
  ///
  void _checkWinner() {
    // Checking rows
    for (int i = 0; i < nbrSquares; i = i + nbrRows) {
      int cnt = 0;

      for (int j = i; j < i + nbrColumns; j++) {
        if (displayElement[i] != '' && displayElement[i] == displayElement[j]) {
          cnt++;
        }
      }
      if (cnt == nbrColumns) {
        _showWinDialog(displayElement[i]);
        return;
      }
    }

    //check columns
    for (int i = 0; i < nbrColumns; i++) {
      int cnt = 0;
      // print('i = $i   cnt = $cnt');

      for (int j = i; j < nbrSquares; j = j + nbrRows) {
        if (displayElement[i] != '' && displayElement[i] == displayElement[j]) {
          cnt++;
        }
        // print('i = $i   j = $j   displayElement[i] = ${displayElement[i]}   displayElement[j] = ${displayElement[j]}    cnt = $cnt');
      }

      // print('cnt = $cnt   NBR_COLS = $NBR_COLS');

      if (cnt == nbrRows) {
        _showWinDialog(displayElement[i]);
        return;
      }
    }

    //Checking Diagonal
    int diagCnt = nbrRows + 1;
    int cnt = 0;
    for (int j = 0; j < nbrSquares; j = j + diagCnt) {
      if (displayElement[0] == displayElement[j] && displayElement[0] != '') {
        cnt++;
      }
    }
    if (cnt == nbrRows) {
      _showWinDialog(displayElement[0]);
      return;
    }

    diagCnt = nbrRows - 1;
    cnt = 0;
    for (int j = diagCnt; j < nbrSquares - nbrColumns + 1; j = j + diagCnt) {
      if (displayElement[diagCnt] == displayElement[j] &&
          displayElement[diagCnt] != '') {
        cnt++;
      }
    }
    if (cnt == nbrRows) {
      _showWinDialog(displayElement[diagCnt]);
      return;
    }

    //DRAW
    if (filledBoxes == nbrSquares) {
      _showDrawDialog();
    }
  }

  ///
  /// dialog box whenever a user wins or the match is a draw.
  ///
  void _showWinDialog(String winner) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("\" $winner \" is Winner!!!"),
            actions: [
              ElevatedButton(
                child: const Text("Play Again"),
                onPressed: () {
                  // _clearBoard();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });

    if (winner == 'O') {
      oScore++;
    } else if (winner == 'X') {
      xScore++;
    }
  }

  ///
  ///  dialog box whenever the match is a draw
  ///
  void _showDrawDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Draw"),
            actions: [
              ElevatedButton(
                child: const Text("Play Again"),
                onPressed: () {
                  // _clearBoard();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  ///
  /// Clear board
  ///
  void _clearBoard() {
    setState(() {
      for (int i = 0; i < nbrSquares; i++) {
        displayElement[i] = '';
      }
    });

    xTurn = true;
    filledBoxes = 0;
  }

  ///
  /// clear scores and board
  ///
  void _clearScoreBoard() {
    setState(() {
      xScore = 0;
      oScore = 0;
      for (int i = 0; i < nbrSquares; i++) {
        displayElement[i] = '';
      }
    });
    xTurn = true;
    filledBoxes = 0;
  }
}
