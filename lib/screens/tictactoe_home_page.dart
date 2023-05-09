import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tictactoe_game/services/database/database_service.dart';

import '../models/board.dart';
import '../models/game.dart';
import '../models/player.dart';
import '../services/utils.dart';

class TicTacToeHomePage extends StatefulWidget {
  TicTacToeHomePage({
    required this.playerXName,
    required this.playerOName,
    required this.selectedGame,
    required this.currentPlayer,
  });

  String playerXName;
  String playerOName;
  Game selectedGame;
  Player currentPlayer;

  @override
  _TicTacToeHomePageState createState() => _TicTacToeHomePageState();
}

class _TicTacToeHomePageState extends State<TicTacToeHomePage> {
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
    // print("TicTacToeHomePage initState GAME: ${widget.selectedGame.toString()}");
    selectedBoardID = BoardID.BoardID_8X8.id;
    displayElement = List.filled(nbrSquares, BLANK_VALUE, growable: true);

    widget.selectedGame = widget.selectedGame.copyWith(
      activePlayerID: widget.currentPlayer.playerID,
      playerOScore: 0,
      playerXScore: 0,
      tappedIndex: -1,
      gameStatus: GameStatus.ACTIVE.status,
    );

    DatabaseService.updateGame(widget.selectedGame);

    //Setup Realtime Database listener
    DatabaseService.subscribeToRealTimeUpdatesGames(
        widget.selectedGame.gameID,
        onChanged
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title : const Text("Tic Tac Toe"),
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

            //Build and display End Game button
            buildEndGameButton(),

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
              setActionSendRealtimeUpdate(GameAction.CLEARED_BOARD);
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
  /// Build and display End Game button
  ///
  Padding buildEndGameButton() {
     return Padding(
      padding: const EdgeInsets.all(4.0),
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
              _clearBoard;
              setActionSendRealtimeUpdate(GameAction.END_GAME);
            },
            child: const Text(
              "End Tic Tac Toe Game",
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

                  //update game with the selected game board
                  setActionSendRealtimeUpdate(GameAction.CHANGED_BOARD);
                },
                child: Text(BoardID.BoardID_3X3.id),
              ),
              ElevatedButton(
                style: myButtonStyle,
                onPressed: () {
                  setNewBoardSize(BoardID.BoardID_4X4);

                  //update game with the selected game board
                  setActionSendRealtimeUpdate(GameAction.CHANGED_BOARD);
                },
                child: Text(BoardID.BoardID_4X4.id),
              ),
              ElevatedButton(
                style: myButtonStyle,
                onPressed: () {
                  setNewBoardSize(BoardID.BoardID_5X5);

                  //update game with the selected game board
                  setActionSendRealtimeUpdate(GameAction.CHANGED_BOARD);
                },
                child: Text(BoardID.BoardID_5X5.id),
              ),
              ElevatedButton(
                style: myButtonStyle,
                onPressed: () {
                  setNewBoardSize(BoardID.BoardID_6X6);

                  //update game with the selected game board
                  setActionSendRealtimeUpdate(GameAction.CHANGED_BOARD);
                },
                child: Text(BoardID.BoardID_6X6.id),
              ),
              ElevatedButton(
                style: myButtonStyle,
                onPressed: () {
                  setNewBoardSize(BoardID.BoardID_7X7);

                  //update game with the selected game board
                  setActionSendRealtimeUpdate(GameAction.CHANGED_BOARD);
                },
                child: Text(BoardID.BoardID_7X7.id),
              ),
              ElevatedButton(
                style: myButtonStyle,
                onPressed: () {
                  setNewBoardSize(BoardID.BoardID_8X8);

                  //update game with the selected game board
                  setActionSendRealtimeUpdate(GameAction.CHANGED_BOARD);
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
  /// Database change listener
  ///
  Future<void> onChanged(dynamic value) async {
    try {
      widget.selectedGame = Game.fromMap(value);

      print("RECEIVED FROM LISTENER: ${widget.selectedGame.toString()}");

      //don't want to receive your own changes
      if (widget.selectedGame.activePlayerID == widget.currentPlayer.playerID) {
        widget.selectedGame = widget.selectedGame.copyWith(
          action: GameAction.NO_ACTION.action,
        );
        return;
      }

      if (widget.selectedGame.action == GameAction.CLEARED_BOARD.action) {
        Utils.showSnackBarMessage(context, "Clear Board was selected..", false);
        _clearBoard();
        widget.selectedGame = widget.selectedGame.copyWith(
          action: GameAction.NO_ACTION.action,
        );

      } else if (widget.selectedGame.action == GameAction.CHANGED_BOARD.action) {
        Utils.showSnackBarMessage(context,
            "New Board Size was selected..${widget.selectedGame.selectedBoardID}",
            false);
        setNewBoardSize(BoardID.getBoardID(widget.selectedGame.selectedBoardID));
        //reset action
        widget.selectedGame = widget.selectedGame.copyWith(
          action: GameAction.NO_ACTION.action,
        );

      } else if (widget.selectedGame.action == GameAction.SELECTED_BOARD_POS.action) {
        Utils.showSnackBarMessage(context,
            "Opponent selected Board Location..${widget.selectedGame.tappedIndex}",
            false);

        //Use the requested index to tap
        _tapped(widget.selectedGame.tappedIndex);

        widget.selectedGame = widget.selectedGame.copyWith(
          action: GameAction.NO_ACTION.action,
        );
      } else if (widget.selectedGame.action == GameAction.END_GAME.action) {
        Utils.showSnackBarMessage(context,
            "Opponent selected End Game..${widget.selectedGame.action}",
            false);

        String otherPlayer = getOtherPlayer();
        await Utils.buildShowDialog(context,"Game Over",
              "Player $otherPlayer wants to end the game.", false);

        widget.selectedGame = widget.selectedGame.copyWith(
          action: GameAction.NO_ACTION.action,
        );
      } else {
        Utils.showSnackBarMessage(context,
            "RECEIVED FROM LISTENER: INVALID ACTION..."
                "[${widget.selectedGame.action}]", true);
        // print("RECEIVED FROM LISTENER: INVALID ACTION...[${widget.selectedGame.action}]");
      }

    } catch(e) {
      Utils.showSnackBarMessage(context,
          "RECEIVED SYSTEM ERROR: $e", true);
      // print("ERROR:$e");
    }
  }

  ///
  /// Get the other player
  String getOtherPlayer() {
    if (widget.currentPlayer.name == widget.playerOName) {
      return widget.playerXName;
    } else {
      return widget.playerOName;
    }
  }

  ///
  ///Set game action and send realtime database updates
  Future<void> setActionSendRealtimeUpdate(GameAction gameAction) async {

    // print("setActionSendRealtimeUpdate .gameAction >> [${gameAction.action}] "
    //     " currentPlayerID ${widget.currentPlayer.playerID}  "
    //     "selected GAME: ${widget.selectedGame}");

    if (gameAction.action == GameAction.NO_ACTION.action) {
      return;

    } else if (gameAction.action == GameAction.CLEARED_BOARD.action) {
      widget.selectedGame = widget.selectedGame.copyWith(
        action: gameAction.action,
        activePlayerID: widget.currentPlayer.playerID,
      );

    } else if (gameAction.action == GameAction.CHANGED_BOARD.action) {
      widget.selectedGame = widget.selectedGame.copyWith(
        selectedBoardID: selectedBoardID,
        action: gameAction.action,
        activePlayerID: widget.currentPlayer.playerID,
      );

    } else if (gameAction.action == GameAction.SELECTED_BOARD_POS.action) {
      widget.selectedGame = widget.selectedGame.copyWith(
        tappedIndex: selectedIndex,
        action: gameAction.action,
        xTurn: xTurn,
        activePlayerID: widget.currentPlayer.playerID,
        playerXScore: xScore,
        playerOScore: oScore,
      );

    } else if (gameAction.action == GameAction.END_GAME.action) {
      widget.selectedGame = widget.selectedGame.copyWith(
        action: gameAction.action,
        gameStatus: GameStatus.COMPLETE.status,
        tappedIndex: selectedIndex,
        activePlayerID: widget.currentPlayer.playerID,
      );

    } else {
      print("RECEIVED FROM LISTENER: UNKNOWN ACTION...[${gameAction.action}]");
      return;
    }

    //only update database/send action to other player if activeID is this player
    if (widget.selectedGame.activePlayerID == widget.currentPlayer.playerID) {
      print("setActionSendRealtimeUpdate .SEND UPDATE.. ${widget.selectedGame.toString()}");
      await DatabaseService.updateGame(widget.selectedGame);
    }

    //reset the game action
    widget.selectedGame = widget.selectedGame.copyWith(
      action: GameAction.NO_ACTION.action,
    );

  }

  ///set the new Board ID and size
  void setNewBoardSize(BoardID boardID) {
    nbrSquares = boardID.size;
    nbrColumns = boardID.rowsCols;
    nbrRows = nbrColumns;
    _clearBoard();
    selectedBoardID = boardID.id;
  }

  ///
  /// display and update players and the scores
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
  Expanded buildTicTacToeBoard() {
    return Expanded(
      child: GridView.builder(
          itemCount: nbrSquares,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: sqrt(nbrSquares).round()),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () async {
                //verify correct players turn
                if ((xTurn && widget.playerOName == widget.currentPlayer.name) ||
                    (!xTurn && widget.playerXName == widget.currentPlayer.name)) {
                  String name = xTurn ? 'X - ${widget.playerXName}' :
                        'O - ${widget.playerOName}';
                  Utils.showSnackBarMessage(context,
                      "It is Player $name turn.", true);
                  return;
                }

                selectedIndex= index;
                _tapped(index);

                await setActionSendRealtimeUpdate(GameAction.SELECTED_BOARD_POS);
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
  void _tapped(int index) async {
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
        if (displayElement[i] != BLANK_VALUE && displayElement[i] == displayElement[j]) {
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
      for (int j = i; j < nbrSquares; j = j + nbrRows) {
        if (displayElement[i] != BLANK_VALUE && displayElement[i] == displayElement[j]) {
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
      if (displayElement[0] == displayElement[j] && displayElement[0] != BLANK_VALUE) {
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
      xTurn = true;
      _showDrawDialog();
    }
  }

  ///
  /// dialog box whenever a user wins or the match is a draw.
  ///
  void _showWinDialog(String winner) {
    Utils.buildShowDialog(context,"Game Winner",
        "\" $winner \" is Winner!!", false);

    if (winner == OVALUE) {
      oScore++;
    } else if (winner == XVALUE) {
      xScore++;
    }
  }

  ///
  ///  dialog box whenever the match is a draw
  ///
  void _showDrawDialog() {
    Utils.buildShowDialog(context,"Game Draw",
        "Game is a Draw, no Winner", false);
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
}
