import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tictactoe_game/services/database/database_service.dart';

import '../models/board.dart';
import '../models/game.dart';
import '../models/player.dart';
import '../services/utils.dart';

class TicTacToeComputerHomePage extends StatefulWidget {
  TicTacToeComputerHomePage();

  String playerXName = "You";
  String playerOName = "Computer";

  @override
  _TicTacToeComputerHomePageState createState() => _TicTacToeComputerHomePageState();
}

class _TicTacToeComputerHomePageState extends State<TicTacToeComputerHomePage> {
  static String XVALUE = 'X';
  static String OVALUE = 'O';
  static String BLANK_VALUE = '';

  int nbrSquares = BoardID.BoardID_8X8.size;
  int nbrRows = BoardID.BoardID_8X8.rowsCols;
  int nbrColumns = BoardID.BoardID_8X8.rowsCols;

  // 1st player is X
  bool xTurn = true;
  late List<String> displayElement;
  int selectedIndex = -1;
  int oScore = 0;
  int xScore = 0;
  int filledBoxes = 0;
  String selectedBoardID = "";

  @override
  void dispose() {
    super.dispose();
    DatabaseService.closeRealTimeUpdateListener();
  }

  @override
  void initState() {
    super.initState();
    selectedBoardID = BoardID.BoardID_8X8.id;
    displayElement = List.filled(nbrSquares, BLANK_VALUE, growable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title : const Text("Computer - Tic Tac Toe"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 1.0, 16.0, 1.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Build and display Players and the Scores
            buildPlayersAndScores(),

            Column(
              children: [
                Text(
                  "The Selected Board Size: $selectedBoardID",
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigoAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            onPressed: () {
              // _clearBoard;
              setNewBoardSize(BoardID.getBoardID(selectedBoardID));
            },
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
                  setNewBoardSize(BoardID.BoardID_3X3);
                },
                child: Text(BoardID.BoardID_3X3.id),
              ),
              ElevatedButton(
                style: myButtonStyle,
                onPressed: () {
                  setNewBoardSize(BoardID.BoardID_4X4);
                },
                child: Text(BoardID.BoardID_4X4.id),
              ),
              ElevatedButton(
                style: myButtonStyle,
                onPressed: () {
                  setNewBoardSize(BoardID.BoardID_5X5);
                },
                child: Text(BoardID.BoardID_5X5.id),
              ),
              ElevatedButton(
                style: myButtonStyle,
                onPressed: () {
                  setNewBoardSize(BoardID.BoardID_6X6);
                },
                child: Text(BoardID.BoardID_6X6.id),
              ),
              ElevatedButton(
                style: myButtonStyle,
                onPressed: () {
                  setNewBoardSize(BoardID.BoardID_7X7);
                },
                child: Text(BoardID.BoardID_7X7.id),
              ),
              ElevatedButton(
                style: myButtonStyle,
                onPressed: () {
                  setNewBoardSize(BoardID.BoardID_8X8);
                },
                child: Text(BoardID.BoardID_8X8.id),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void setNewBoardSize(BoardID boardID) {
    nbrSquares = boardID.size;
    nbrColumns = boardID.rowsCols;
    nbrRows = nbrColumns;
    _clearBoard();
    selectedBoardID = boardID.id;
  }

  ///
  /// display and update players and the scores
  ///
  Padding buildPlayersAndScores() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
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
                    Text(
                      'Player-X:\n${widget.playerXName}',
                      style: const TextStyle(
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
                    Text(
                        'Player-O:\n${widget.playerOName}',
                        style: const TextStyle(
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
                selectedIndex= index;
                _tapped(index);

                //computers turn
                // print("TTT AFTER TAP: XtURN == [$xTurn]  ");
                if (!xTurn) {
                  createComputerMove();
                }
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
  Future<void> _tapped(int index) async {
    setState(() {
      if (!xTurn && displayElement[index] == BLANK_VALUE) {
        displayElement[index] = OVALUE;
        filledBoxes++;
      } else if (xTurn && displayElement[index] == BLANK_VALUE) {
        displayElement[index] = XVALUE;
        filledBoxes++;
      }

      xTurn = !xTurn;
    });

    await _checkWinner();
  }

  ///
  /// check for the winner in the game
  ///
  Future<void> _checkWinner() async {
    // Checking rows
    for (int i = 0; i < nbrSquares; i = i + nbrRows) {
      int cnt = 0;

      for (int j = i; j < i + nbrColumns; j++) {
        // print("_checkWinner CHK ROWS -- [$i][$j] == [${displayElement[j]}]");
        if (displayElement[i] != BLANK_VALUE &&
            displayElement[i] == displayElement[j]) {
          cnt++;
        }
      }
      if (cnt == nbrColumns) {
        xTurn = true;
        _showWinDialog(displayElement[i]);
        return;
      }
    }

    //check columns
    for (int i = 0; i < nbrColumns; i++) {
      int cnt = 0;
      // print('i = $i   cnt = $cnt');

      for (int j = i; j < nbrSquares; j = j + nbrRows) {
        // print("_checkWinner CHK COLS -- [$i][$j] == [${displayElement[j]}]");
        if (displayElement[i] != BLANK_VALUE &&
            displayElement[i] == displayElement[j]) {
          cnt++;
        }
      }

      if (cnt == nbrRows) {
        xTurn = true;
        _showWinDialog(displayElement[i]);
        return;
      }
    }

    //Checking Diagonal
    int diagCnt = nbrRows + 1;
    int cnt = 0;
    for (int j = 0; j < nbrSquares; j = j + diagCnt) {
      // print("_checkWinner CHK DIAG LRTB -- [$j] == [${displayElement[j]}]");
      if (displayElement[0] == displayElement[j] &&
          displayElement[0] != BLANK_VALUE) {
        cnt++;
      }
    }
    if (cnt == nbrRows) {
      xTurn = true;
      _showWinDialog(displayElement[0]);
      return;
    }

    diagCnt = nbrRows - 1;
    cnt = 0;
    for (int j = diagCnt; j < nbrSquares - nbrColumns + 1; j = j + diagCnt) {
      // print("_checkWinner CHK DIAG RLTB -- [$j] == [${displayElement[j]}]");
      if (displayElement[diagCnt] == displayElement[j] &&
          displayElement[diagCnt] != BLANK_VALUE) {
        cnt++;
      }
    }
    if (cnt == nbrRows) {
      xTurn = true;
      _showWinDialog(displayElement[diagCnt]);
      return;
    }

    //DRAW
    if (filledBoxes == nbrSquares) {
      // print("_checkWinner DRAW CHK FILLED -- [$filledBoxes] == [$nbrSquares]");
      xTurn = true;
      _showDrawDialog();
    }
  }

  ///
  /// dialog box whenever a user wins or the match is a draw.
  ///
  void _showWinDialog(String winner) {
    Utils.buildShowDialog(context,"Game Winner",
        "\" $winner \" is Winner!!!", false);
    // _clearBoard();

    if (winner == 'O') {
      oScore++;
    } else if (winner == 'X') {
      xScore++;
    }

    // showDialog(
    //     barrierDismissible: false,
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: Text("\" $winner \" is Winner!!!"),
    //         actions: [
    //           ElevatedButton(
    //             child: const Text("Play Again"),
    //             onPressed: () {
    //               // _clearBoard();
    //               Navigator.of(context).pop();
    //             },
    //           )
    //         ],
    //       );
    //     });
    //
    // if (winner == 'O') {
    //   oScore++;
    // } else if (winner == 'X') {
    //   xScore++;
    // }
  }

  ///
  ///  dialog box whenever the match is a draw
  ///
  void _showDrawDialog() {
    Utils.buildShowDialog(context,"Game Draw",
        "Game is a Draw, no Winner", false);
    // _clearBoard();
    // showDialog(
    //     barrierDismissible: false,
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: const Text("Draw"),
    //         actions: [
    //           ElevatedButton(
    //             child: const Text("Play Again"),
    //             onPressed: () {
    //               // _clearBoard();
    //               Navigator.of(context).pop();
    //             },
    //           )
    //         ],
    //       );
    //     });
  }

  ///
  /// Clear board
  ///
  void _clearBoard() {
    setState(() {
      for (int i = 0; i < nbrSquares; i++) {
        displayElement[i] = BLANK_VALUE;
      }
    });
    xTurn = true;
    filledBoxes = 0;
  }

  // ///
  // /// clear scores and board
  // ///
  // void _clearScoreBoard() {
  //   setState(() {
  //     xScore = 0;
  //     oScore = 0;
  //     for (int i = 0; i < nbrSquares; i++) {
  //       displayElement[i] = BLANK_VALUE;
  //     }
  //   });
  //   xTurn = true;
  //   filledBoxes = 0;
  // }


  Future<void> createComputerMove() async {
    int posToWin = -1;
    int posToBlock = -1;
    int nextBestPos = -1;
    int cnt = 0;
    int cntXPos = 0;

    // First see if there's a move the computer can make to win
    // Checking rows
    for (int i = 0; i < nbrSquares; i = i + nbrRows) {
      cnt = 0;
      posToWin = -1;
      cntXPos = 0;

      for (int j = i; j < i + nbrColumns; j++) {
        // print("CHK ROWS -- [$i][$j] == [${displayElement[j]}]");
        if (displayElement[j] == OVALUE) {
          cnt++;
        } else if (displayElement[j] == XVALUE) {
          cntXPos++;
        } else {
          posToWin = j;
        }
      }

      // print("CHK ROWS --posToWin [$posToWin]  cnt [$cnt]  cntXPos [$cntXPos]");
      if (posToWin != -1 && cnt == nbrColumns - 1) {
        // print("CHK ROWS -- [$i] ... TAPPED [$posToWin]");
        await _tapped(posToWin);
        return;
      }

      if (posToWin != -1 && cntXPos == nbrColumns - 1) {
        posToBlock = posToWin;
        // print("CHK ROWS -- [$i] ... POS TO BLOCK [$posToBlock]");
      }

      if (posToWin != -1 && cntXPos > 0) {
        nextBestPos = posToWin;
        // print("CHK ROWS -- [$i] ... NEXT BEST POS [$nextBestPos]");
      }
    }

    //check columns
    for (int i = 0; i < nbrColumns; i++) {
      cnt = 0;
      posToWin = -1;
      cntXPos = 0;

      for (int j = i; j < nbrSquares; j = j + nbrRows) {
        // print("CHK COLS -- [$i][$j] == [${displayElement[j]}]");
        if (displayElement[j] == OVALUE) {
          cnt++;
        } else if (displayElement[j] == XVALUE) {
          cntXPos++;
        } else {
          posToWin = j;
        }
      }

      // print("CHK COLS --posToWin [$posToWin]  cnt [$cnt]  cntXPos [$cntXPos]");

      if (posToWin != -1 && cnt == nbrColumns - 1) {
        // print("CHK COLS -- [$i] ... TAPPED [$posToWin]");
        _tapped(posToWin);
        return;
      }

      if (posToWin != -1 && cntXPos == nbrColumns - 1) {
        posToBlock = posToBlock == -1 ? posToWin : posToBlock;
        // print("CHK COLS -- [$i] ... POS TO BLOCK [$posToBlock]");
      }

      if (posToWin != -1 && cntXPos > 0) {
        nextBestPos = nextBestPos == -1 ? posToWin : nextBestPos;;
        // print("CHK COLS -- [$i] ... NEXT BEST POS [$nextBestPos]");
      }
    }

    //Checking Diagonal
    int diagCnt = nbrColumns + 1;
    cnt = 0;
    posToWin = -1;
    cntXPos = 0;

    for (int j = 0; j < nbrSquares; j = j + diagCnt) {
      // print("CHK DIAG LRTB -- [$j] == [${displayElement[j]}]");
      if (displayElement[j] == OVALUE) {
        cnt++;
      } else if (displayElement[j] == XVALUE) {
        cntXPos++;
      } else {
        posToWin = j;
      }
    }

    print("CHK DIAG --posToWin [$posToWin]  cnt [$cnt]  cntXPos [$cntXPos]");

    if (posToWin != -1 && cnt == nbrColumns - 1) {
      // print("CHK DIAG  LRTB --  TAPPED [$posToWin]");
      _tapped(posToWin);
      return;
    }

    if (posToWin != -1 && cntXPos == nbrColumns - 1) {
      posToBlock = posToBlock == -1 ? posToWin : posToBlock;
      // print("CHK DIAG --.. POS TO BLOCK [$posToBlock]");
    }

    if (posToWin != -1 && cntXPos > 0) {
      nextBestPos = nextBestPos == -1 ? posToWin : nextBestPos;;
      // print("CHK DIAG LRTB -- .. NEXT BEST POS [$nextBestPos]");
    }

    diagCnt = nbrRows - 1;
    cnt = 0;
    posToWin = -1;
    cntXPos = 0;

    for (int j = diagCnt; j < nbrSquares - nbrColumns + 1; j = j + diagCnt) {
      // print("CHK DIAG RLTB -- [$j] == [${displayElement[j]}]");
      if (displayElement[j] == OVALUE) {
        cnt++;
      } else if (displayElement[j] == XVALUE) {
        cntXPos++;
      } else {
        posToWin = j;
      }
    }

    // print("CHK DIAG RLTB --posToWin [$posToWin]  cnt [$cnt]  cntXPos [$cntXPos]");

    if (posToWin != -1 && cnt == nbrColumns - 1) {
      // print("CHK DIAG  RLTB --  TAPPED [$posToWin]");
      _tapped(posToWin);
      return;
    }

    if (posToWin != -1 && cntXPos == nbrColumns - 1) {
      posToBlock = posToBlock == -1 ? posToWin : posToBlock;
      // print("CHK DIAG --.. POS TO BLOCK [$posToBlock]");
    }

    if (posToWin != -1 && cntXPos > 0) {
      nextBestPos = nextBestPos == -1 ? posToWin : nextBestPos;
      // print("CHK DIAG -- .. NEXT BEST POS [$nextBestPos]");
    }

    if (posToBlock > -1 || nextBestPos > -1) {
      _tapped(posToBlock > -1 ? posToBlock : nextBestPos);
    }

  }
}
