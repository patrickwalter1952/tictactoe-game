
import 'package:tictactoe_game/models/player.dart';
import 'package:tictactoe_game/models/game.dart';

///TicTacToe
///
class TicTacToe {
  List<Game> games = [];
  List<Player> players = [];

  TicTacToe({
    required games,
    required players,
  });

  TicTacToe copyWith({
    List<Game>? games,
    List<Player>? players,
  }) {
    return TicTacToe (
      games: games ?? this.games,
      players: players ?? this.players,
    );
  }

  ///
  /// get Game display list tile title
  String getGameTile(Game game, String currentPlayer, String opponentPlayer) {
    try {
      Player? playerX = getPlayer(game.playerXID);
      Player? playerO = getPlayer(game.playerOID);
      String? nameX = playerX == null ? currentPlayer : playerX.name;
      String? nameO = playerO == null ? opponentPlayer : playerO.name;

      return "date: ${game.date} \nplayerX: $nameX\nplayerO: $nameO";
    } catch (e) {
      print("Error: Invalid Game .. $e");
    }
    return "";
  }

  @override
  String toString() {
    return "TICTACTOE: [$players]  [$games]";
  }

  //==============================
  // Player
  //==============================
  void resetPlayers() {
    players.clear();
  }

  void setPlayers(List<Player> playerList) {
    players.clear();
    players.addAll(playerList);
  }

  void addPlayer(Player player) {
    players.add( player);
  }

  Player? getPlayer(String playerID) {
    // print("LIST OF PLAYERS: SIZE .. [${players.length}]");
    try {
      for (Player player in players) {
        // print("?????: [${player.playerID}] ==== [$playerID]");
        if (player.playerID == playerID) {
          // print("FOUND: $player");
          return player;
        }
      }
    } catch (e) {
      print("Error: Invalid Player ID ($playerID).. $e");
    }
    return null;
  }

  Player? getPlayerFromName(String name) {
    try {
      for (Player player in players) {
        if (player.name == name) {
          return player;
        }
      }
    } catch (e) {
      print("Error: Invalid Player Name ($name).. $e");
    }
    return null;
  }

  //==============================
  // Games
  //==============================
  void resetGames() {
    games.clear();
  }

  void setGames(List<Game> gameList) {
    games.clear();
    games.addAll(gameList);
  }

  void addGame(Game game) {
    games.add(game);
  }

  Game? getGame(String gameID) {
    try {
      for (Game game in games) {
        if (game.gameID == gameID) {
          return game;
        }
      }
    } catch (e) {
      print("Error: Invalid Game ID ($gameID).. $e");
    }
    return null;
  }

}
