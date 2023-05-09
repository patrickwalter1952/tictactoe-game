import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tictactoe_game/models/tictactoe_model.dart';
import 'package:tictactoe_game/screens/tictactoe_home_page.dart';
import 'package:tictactoe_game/services/string_extensions.dart';

import '../models/board.dart';
import '../models/game.dart';
import '../models/player.dart';
import '../services/database/database_service.dart';
import '../services/utils.dart';

class PlayerWaitingPage extends StatefulWidget {
  PlayerWaitingPage({
    super.key,
    required this.currentPlayer
  });

  Player currentPlayer;

  late Player selectedOpponent;
  int selectedWaitIndex = -1;
  bool isSelectedOpponent = false;

  late int selectedGameIndex = -1;
  late Game selectedGame;
  String selectedGameID = "";
  bool isSelectedGame = false;

  TicTacToe ticTacToe = TicTacToe(
      games: [],
      players: [],
  );

  @override
  State<PlayerWaitingPage> createState() => _PlayerWaitingPageState();
}

class _PlayerWaitingPageState extends State<PlayerWaitingPage> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Multiplayer - Player Status'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Text(
              "Existing Player To Contact\nPut Your Name in Waiting List",
              style: TextStyle(fontSize: 20),
            ),

            Expanded(child: playerListContainer()),

            const Text(
              "Waiting List - Select Opponent",
              style: TextStyle(fontSize: 20),
            ),

            Expanded(child: playerWaitingListContainer()),

            Text(
              "Game Status for ${widget.currentPlayer.name}",
              style: const TextStyle(fontSize: 20),
            ),

            Expanded(child: gameListContainer()),

            const SizedBox(height: 8),

            createInitializeGameButton(),

            const SizedBox(height: 8),

            createStartGameButton(),

          ],
        ),
      ),
    );
  }

  ///
  /// Button to Initialize a New Game
  SizedBox createInitializeGameButton() {
    return SizedBox(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          minimumSize: const Size.fromHeight(40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        onPressed: () async {
          Game game = Game.initializeGame(widget.currentPlayer);
          widget.selectedGameID = game.gameID;
          await DatabaseService.insertIfGameNotExist(game);
        },
        child: Text("Initialize Game with Player: ${widget.currentPlayer.name}"),
      ),
    );
  }

  ///
  /// Button to Start Tic Tac Toe New Game
  SizedBox createStartGameButton() {
    return SizedBox(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          minimumSize: const Size.fromHeight(40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        onPressed: () async {
             if (!widget.isSelectedGame || widget.selectedGame.playerO.isEmpty ||
              widget.selectedGame.playerX.isEmpty) {
            Utils.buildShowDialog(
                context,
                "Game Must be initialized",
                "Game must be selected with both Player X and Player O valued.",
                true);
            return;
          }

          widget.selectedGame = widget.selectedGame.copyWith(
            date: Utils.dateFormat.format(DateTime.now()),
            gameStatus: GameStatus.ACTIVE.status,
            selectedBoardID: BoardID.BoardID_8X8.id,
            action: GameAction.NO_ACTION.action,
            tappedIndex: -1,
          );
          await DatabaseService.updateGame(widget.selectedGame);

          String? playerOName = widget.ticTacToe.getPlayer(widget.selectedGame.playerO)?.name;
          String? playerXName = widget.ticTacToe.getPlayer(widget.selectedGame.playerX)?.name;
          // print("GET PLAYER X  -- [$playerXName]  PLAYER O  -- [$playerOName]");

          Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TicTacToeHomePage(
                playerXName: playerXName as String,
                playerOName: playerOName as String,
                selectedGame: widget.selectedGame,
                currentPlayer: widget.currentPlayer,
              ))
          ).then((_) async {
            // get callback after coming back from NextPage()
            int totWins = widget.currentPlayer.totalWins;
            int totLosses = widget.currentPlayer.totalLosses;

            widget.selectedGame = (await DatabaseService.findGame(widget.selectedGame.gameID))!;
            print("CALLED BACK GAME FROM DB.... ${widget.selectedGame.toString()}");

            if (widget.selectedGame.playerO == widget.currentPlayer.playerID) {
              widget.currentPlayer = widget.currentPlayer.copyWith(
                totalWins: totWins + widget.selectedGame.playerOScore,
                totalLosses: totLosses + widget.selectedGame.playerXScore,
              );
            } else {
              widget.currentPlayer = widget.currentPlayer.copyWith(
                totalWins: totWins + widget.selectedGame.playerXScore,
                totalLosses: totLosses + widget.selectedGame.playerOScore,
              );
            }
            print("CALLED BACK PLAYER.... ${widget.currentPlayer.toString()}");
            DatabaseService.updatePlayer(widget.currentPlayer);
          });
        },
        child: const Text("Start Tic Tac Toe Game"),
      ),
    );
  }

  ///
  /// container for showing the current list of all players
  Widget playerListContainer() {
    final scrollController = ScrollController();
    return Container(
      height: 200,
      width: 340,
      margin: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.cyan,
      ),
      child: ScrollConfiguration(
        behavior: _ScrollbarBehavior(),
        child: StreamBuilder(
          stream: DatabaseService.getAllPlayers(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong! ${snapshot.error}");
            } else if (snapshot.hasData) {
              final players = snapshot.data!;
              return ListView.separated(
                shrinkWrap: true,
                controller: scrollController,
                separatorBuilder: (_, __) => const Divider(
                  height: 2,
                  thickness: 4,
                ),
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                itemCount: players.length,
                itemBuilder: (BuildContext context, int index) {
                  final player = players[index];
                  if (index == 0) {
                    widget.ticTacToe.resetPlayers();
                  }

                  widget.ticTacToe.addPlayer(player);
                  return buildPlayerTile(player);
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }


  ///
  /// container for showing the current list of players waiting to play game
  Widget playerWaitingListContainer() {
    final scrollController = ScrollController();
    return Container(
      height: 140,
      width: 340,
      margin: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.orange,
      ),
      child: ScrollConfiguration(
        behavior: _ScrollbarBehavior(),
        child: StreamBuilder(
          stream: DatabaseService.getAllPlayersWaiting(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong! ${snapshot.error}");
            } else if (snapshot.hasData) {
              final players = snapshot.data!;
              return ListView.separated(
                controller: scrollController,
                shrinkWrap: true,
                separatorBuilder: (_, __) => const Divider(
                  height: 2,
                  thickness: 4,
                ),
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                itemCount: players.length,
                itemBuilder: (BuildContext context, int index) {
                  final player = players[index];
                  return buildPlayerWaitingTile(player, index);
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  ///
  /// container for showing the current list of Games with status
  Widget gameListContainer() {
    final scrollController = ScrollController();
    return Container(
      height: 140,
      width: 340,
      margin: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.yellow,
      ),
      child: ScrollConfiguration(
        behavior: _ScrollbarBehavior(),
        child: StreamBuilder(
          stream: DatabaseService.getAllGames(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong! ${snapshot.error}");
            } else if (snapshot.hasData) {
              final games = snapshot.data!;
              return ListView.separated(
                controller: scrollController,
                shrinkWrap: true,
                separatorBuilder: (_, __) => const Divider(
                  height: 2,
                  thickness: 4,
                ),
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                itemCount: games.length,
                itemBuilder: (BuildContext context, int index) {
                  final game = games[index];
                  // print("ITEMBUILDER-- GAME ${game.toString()}");
                  // print("[" + widget.currentPlayer.playerID + "] == [" +
                  //     game.playerX + "]  ||  [" +
                  //     widget.currentPlayer.playerID + "] == [" + game.playerO +
                  //     "] ");
                  if (index == 0) {
                    widget.ticTacToe.resetGames();
                  }
                  widget.ticTacToe.addGame(game);
                  return buildGameTile(game, index);
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  ///
  /// build & display the player tile
  Widget buildPlayerTile(Player player) {
    return ListTile(
      leading: IconButton(
        icon: const Icon(Icons.phone_android),
        color: Colors.black,

        onPressed: () async {
          TextEditingController phoneController =
            TextEditingController(text: player.phoneNumber);
          String result =
            await Utils.buildShowPhoneTextFieldDialog(
                context,
                "Enter Phone Number to Text",
                "Invalid Phone Number",
                phoneController.text.isValidPhoneNumber,
                phoneController);

          if (result.toUpperCase() == "OK") {
            String msg = "Tic Tac Toe Player:\n "
                "${widget.currentPlayer.name} has challenged you with a game."
                " After signing in, join game between \n"
                "${widget.currentPlayer.name} and  ${player.name}";
            try {
              Utils.send_SMS2(msg, [phoneController.text]);
            } catch (e) {
              Utils.showSnackBarMessage(context,
                  "SEND PHONE TEXT MESSAGE ERROR: $e", true);
              // print("SEND PHONE TEXT MESSAGE ERROR: $e");
            }
          }
        }
      ),

      title: Text(
        player.tilePlayerInfo(),
        style: const TextStyle(
          fontSize: 16.0,
          decoration: TextDecoration.none,
        ),
      ),

      trailing: widget.currentPlayer.name == player.name ? IconButton(
        icon: const Icon(Icons.delete),
        color: Colors.redAccent,
        onPressed: () {
          String result = DatabaseService.deletePlayer(player);
        },
      ) : null,

      onTap: widget.currentPlayer.name == player.name ? () {
            Player changePlayer =
            player.copyWith(playerStatus: GameStatus.WAITING.status);
            DatabaseService.updatePlayer(changePlayer);
          } : null,
    );
  }

    ///
    /// build & display the WAITING player tile
    Widget buildPlayerWaitingTile(Player player, int index) {
      return Container (
        color: widget.isSelectedOpponent && widget.selectedWaitIndex == index
            ? Colors.white70 : Colors.transparent,
        child: ListTile(
          title: Text(
            player.tilePlayerInfo(),
            style: const TextStyle(
              fontSize: 16.0,
              decoration: TextDecoration.none,
            ),
          ),

          trailing: widget.currentPlayer.name == player.name
            ? IconButton(
                icon: const Icon(Icons.dangerous_outlined),
                color: Colors.redAccent,
                onPressed: () {
                  Player changePlayer =
                          player.copyWith(playerStatus: GameStatus.INACTIVE.status);
                  DatabaseService.updatePlayer(changePlayer);
                },
            )
            : null,

          onLongPress: () {
            print("SELECTED PLAYER WAITING: ${player.toString()}");
            setState(() {
              widget.selectedOpponent = player;
              widget.isSelectedOpponent = true;
              widget.selectedWaitIndex = index;
            });
          },

          onTap: () {
            setState(() {
              widget.isSelectedOpponent = false;
              widget.selectedWaitIndex = -1;
            });
          },
        ),
      );
    }

    ///
    /// build & display the player tile
    Widget buildGameTile(Game game, int index) => Container(
      color: widget.isSelectedGame && widget.selectedGameIndex == index
          ? Colors.white70 : Colors.transparent,
      child: widget.currentPlayer.playerID == game.playerX ||
          widget.currentPlayer.playerID == game.playerO ? ListTile(
        title: Text(
          widget.ticTacToe.getGameTile(game,
              widget.currentPlayer.name,
              widget.isSelectedOpponent ? widget.selectedOpponent.name : ""),
          style: const TextStyle(
            fontSize: 16.0,
            decoration: TextDecoration.none,
          ),
        ),

        trailing: widget.currentPlayer.playerID == game.playerX ?
        IconButton(
          icon: const Icon(Icons.delete),
          color: Colors.redAccent,

          onPressed: () {
            String result = DatabaseService.deleteGame(game);
          },
        ) : null ,

        onLongPress: () async {
          print("SELECTED GAME: ${game.toString()}");
          if (widget.isSelectedOpponent) {
            widget.selectedGame = game.copyWith(
                playerO: widget.selectedOpponent.playerID);
            await DatabaseService.updateGame(widget.selectedGame);

          } else {
            widget.selectedGame = game.copyWith();
            await DatabaseService.updateGame(widget.selectedGame);
          }

          if (widget.selectedGame.playerO.isEmpty) {
            Utils.buildShowDialog(
                context,
                "Game Must be initialized",
                "Game requires a selected opponent Player From Waiting List.",
                true);
            return;
          }

          setState(() {
            widget.isSelectedGame = true;
            widget.selectedGameIndex = index;
           });
        },

        onTap: () {
          setState(() {
            widget.isSelectedGame = false;
            widget.selectedGameIndex = -1;
          });
        },
      ) : null,
    );
}

///
///
class _ScrollbarBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    return Scrollbar(
        controller: details.controller,
        thickness: 6.0,
        thumbVisibility: true,
        trackVisibility: true,
        child: child,);
  }
}