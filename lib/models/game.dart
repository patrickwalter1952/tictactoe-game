
import 'package:intl/intl.dart';
import 'package:tictactoe_game/models/board.dart';
import 'package:tictactoe_game/models/player.dart';

import '../services/utils.dart';

enum GameStatus {
  INACTIVE(status: "inactive"),
  WAITING(status: "waiting"),
  ACTIVE(status: "active"),
  COMPLETE(status: "complete");

  const GameStatus ({
    required this.status,
  });
  final String status;
}

enum GameAction {
  NO_ACTION(action: ""),
  CHANGED_BOARD(action: "changedBoard"),
  SELECTED_BOARD_POS(action: "selectedBoardPos"),
  CHECK_WINNER(action: "checkWinner"),
  CLEARED_BOARD(action: "clearBoard"),
  END_GAME(action: "endGame");

  const GameAction({
    required this.action,
  });
  final String action;
}

class Game {
  final String gameID;
  final String date;
  final String gameStatus;        //waiting, active, complete
  final String playerXID;
  final String playerXName;
  final String playerOID;
  final String playerOName;
  final int playerXScore;
  final int playerOScore;
  final String selectedBoardID;   //enum BoardID
  final String activePlayerID;    //playerID
  final int tappedIndex;
  final bool xTurn;
  final String action;

  Game({
    required this.gameID,
    required this.date,
    required this.gameStatus,
    required this.playerXID,
    required this.playerXName,
    required this.playerOID,
    required this.playerOName,
    this.playerXScore = 0,
    this.playerOScore = 0,
    required this.selectedBoardID,
    required this.activePlayerID,
    required this.tappedIndex,
    this.xTurn = true,
    this.action = "",
  });

  Map<String, dynamic> toMap() {
    return {
      'gameID': gameID,
      'date': date,
      'gameStatus': gameStatus,
      'playerXID': playerXID,
      'playerXName': playerXName,
      'playerOID': playerOID,
      'playerOName': playerOName,
      'playerXScore':playerXScore,
      'playerOScore': playerOScore,
      'selectedBoardID': selectedBoardID,
      'activePlayerID': activePlayerID,
      'tappedIndex': tappedIndex,
      'xTurn': xTurn,
      'action': action,
    };
  }

  static Game initializeGame(Player currentPlayer) {
    return Game(
      date: Utils.dateFormat.format(DateTime.now()),
      gameID: DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
      gameStatus: GameStatus.INACTIVE.status,
      playerXID: currentPlayer.playerID,
      playerXName: currentPlayer.name,
      playerOID: "",
      playerOName: "",
      playerOScore: 0,
      playerXScore: 0,
      selectedBoardID: BoardID.BoardID_8X8.id,
      activePlayerID: currentPlayer.playerID,
      tappedIndex: -1,
      xTurn: true,
      action: GameAction.NO_ACTION.action,
    );
  }

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      gameID: map['gameID'] ?? '',
      date: map['date'] ?? '',
      gameStatus: map['gameStatus'] ?? '',
      playerXID: map['playerXID'] ?? '',
      playerXName: map['playerXName'] ?? '',
      playerOID: map['playerOID'] ?? '',
      playerOName: map['playerOName'] ?? '',
      playerXScore: map['playerXScore']?? 0.0,
      playerOScore: map['playerOScore']?? 0.0,
      selectedBoardID: map['selectedBoardID'] ?? '',
      activePlayerID: map['activePlayerID'] ?? '',
      tappedIndex: map['tappedIndex'] ?? -1,
      xTurn: map['xTurn'] ?? true,
      action: map['action'] ?? GameAction.NO_ACTION.action,

    );
  }

  Game copyWith({
    String? gameID,
    String? date,
    String? gameStatus,
    String? playerXID,
    String? playerXName,
    String? playerOID,
    String? playerOName,
    int? playerXScore,
    int? playerOScore,
    String? selectedBoardID,
    String? activePlayerID,
    int? tappedIndex,
    bool? xTurn,
    String? action,
  }) {
    return Game (
      gameID: gameID ?? this.gameID,
      date: date ?? this.date,
      gameStatus: gameStatus ?? this.gameStatus,
      playerXID: playerXID ?? this.playerXID,
      playerXName: playerXName ?? this.playerXName,
      playerOID: playerOID ?? this.playerOID,
      playerOName: playerOName ?? this.playerOName,
      playerXScore: playerXScore ?? this.playerXScore,
      playerOScore: playerOScore ?? this.playerOScore,
      selectedBoardID: selectedBoardID ?? this.selectedBoardID,
      activePlayerID: activePlayerID ?? this.activePlayerID,
      tappedIndex: tappedIndex ?? this.tappedIndex,
      xTurn: xTurn ?? this.xTurn,
      action: action ?? this.action,
    );
  }

  @override
  String toString() {
    return "date: $date,  gameID: $gameID, gameStatus: $gameStatus, " +
        "playerXID: $playerXID, playerXName: $playerXName, "
        "playerOID: $playerOName, playerOName: $playerOName, "
        "playerXScore: $playerXScore, playerOScore: $playerOScore, "
        "selectedBoardID: $selectedBoardID," +
        "activePlayerID: $activePlayerID, tappedIndex: $tappedIndex, " +
        "xTurn: $xTurn   action: $action";
  }

  @override
  String tileGameInfo() {
    return "date: $date\ngameID: $gameID " +
        "\nplayerX: $playerXName \nplayerO: $playerOName ";
  }
}
