import 'package:flutter/material.dart';
import 'package:tictactoe_game/models/tictactoe_model.dart';
import 'package:tictactoe_game/screens/tictactoe_home_page.dart';

import '../models/board.dart';
import '../models/game.dart';
import '../models/player.dart';
import '../services/database/database_service.dart';
import '../services/utils.dart';

class PlayerWaitingPage extends StatefulWidget {
  PlayerWaitingPage({super.key, required this.currentPlayer});

  Player currentPlayer;

  late Player selectedOpponent;
  int selectedWaitIndex = -1;
  bool isSelectedOpponent = false;

  late int selectedGameIndex = -1;
  late Game selectedGame;
  String selectedGameID = "";

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

    debugPrint("CURRENT PLAYER: ${widget.currentPlayer.toString()}");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Multi Player - Game Setup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Text(
              "Existing Players To Contact",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            Expanded(child: playerListContainer()),
            Text(
              "Game Status for ${widget.currentPlayer.name}",
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const Text(
              "Initialize And/Or Select Game Then\nSelect Opponent From List Above",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
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
          // widget.selectedGameID = game.gameID;
          await DatabaseService.insertIfGameNotExist(game);
        },
        child:
            Text("Initialize Game with Player: ${widget.currentPlayer.name}"),
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
          if (widget.selectedGameID.isEmpty ||
              widget.selectedGame.playerOName.isEmpty ||
              widget.selectedGame.playerXName.isEmpty) {
            Utils.buildShowDialog(
                context,
                "Game Must be initialized and Selected",
                "Game must be selected with both Player X and Player O valued.",
                true);
            return;
          }

          //Player X will update the selected game
          if (widget.currentPlayer.playerID == widget.selectedGame.playerXID) {
            widget.selectedGame = widget.selectedGame.copyWith(
              date: Utils.dateFormat.format(DateTime.now()),
              gameStatus: GameStatus.ACTIVE.status,
              selectedBoardID: BoardID.BoardID_8X8.id,
              action: GameAction.NO_ACTION.action,
              tappedIndex: -1,
              activePlayerID: widget.selectedGame.playerXID,
              playerOScore: 0,
              playerXScore: 0,
            );
            await DatabaseService.updateGame(widget.selectedGame);
          }

          //navigate to the game page
          navigateToPage();

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
                  return buildPlayerTile(player, index);
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
        color: Colors.cyan,
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
                  // print("[${widget.currentPlayer.playerID}] == [${game.playerXID}]  "
                  //     "||  [${widget.currentPlayer.playerID}] == [${game.playerOID}] ");
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
  Widget buildPlayerTile(Player player, int index) {
    return Container(
      color: player.name == widget.currentPlayer.name
          ? Colors.white70
          : Colors.transparent,
      child: ListTile(
        leading: buildCopyTextClipboardIconButton(player),

        title: Text(
          player.tilePlayerInfo(),
          style: const TextStyle(
            fontSize: 16.0,
            decoration: TextDecoration.none,
          ),
        ),

        trailing: widget.currentPlayer.name == player.name
            ? IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.redAccent,
                onPressed: () {
                  String result = DatabaseService.deletePlayer(player);
                  if (result.isNotEmpty) {
                    showDialog("Delete Player Request Failed",
                        "Unable to delete the requested player (${player.name}.\n"
                        " $result",
                        true);
                    return;
                  }
                },
              )
            : null,

        //select any player opponent but current player
        onLongPress: widget.currentPlayer.name != player.name
          ? () async {
              if (widget.selectedGameID.isEmpty) {
                showDialog("Select Game First",
                    "Game must be selected before selecting opponent.", true);
                return;
              }
              setState(() {
                widget.selectedOpponent = player;
                widget.isSelectedOpponent = true;
                widget.selectedWaitIndex = index;
              });

              //update the game data
              widget.selectedGame =
                  widget.selectedGame.copyWith(
                      playerOID: player.playerID,
                      playerOName: player.name,
                  );
              await DatabaseService.updateGame(widget.selectedGame);
            }
          : null,
      ),
    );
  }

  // IconButton buildTextMessageIconButton(Player player) {
  //   return IconButton(
  //       icon: const Icon(Icons.phone_android),
  //       color: Colors.black,
  //       onPressed: () async {
  //         TextEditingController phoneController =
  //         TextEditingController(text: player.phoneNumber);
  //         String result = await Utils.buildShowPhoneTextFieldDialog(
  //             context,
  //             "Enter Phone Number to Text ${player.name}",
  //             "Invalid Phone Number",
  //             phoneController.text.isValidPhoneNumber,
  //             phoneController);
  //
  //         if (result.toUpperCase() == "OK") {
  //           String msg = "Tic Tac Toe Player:\n "
  //               "${widget.currentPlayer.name} has challenged you with a game."
  //               " After signing in, join game between \n"
  //               "${widget.currentPlayer.name} and  ${player.name}";
  //           try {
  //             Utils.send_SMS2(msg, [phoneController.text]);
  //           } catch (e) {
  //             showMessage("SEND PHONE TEXT MESSAGE ERROR: $e", true);
  //           }
  //         }
  //       });
  // }

  IconButton buildCopyTextClipboardIconButton(Player player) {
    return IconButton(
      icon: const Icon(Icons.phone_android),
      color: Colors.black,
      onPressed: () async {
        Utils.copyChallengeRequestToClipboard(context,
            widget.currentPlayer, player);
      });
  }

  ///
  /// build & display the player tile
  Widget buildGameTile(Game game, int index) => Container(
    color: widget.selectedGameID.isNotEmpty && widget.selectedGameIndex == index
        ? Colors.white70
        : Colors.transparent,
    // child: widget.currentPlayer.playerID == game.playerX ||
    //     widget.currentPlayer.playerID == game.playerO ? ListTile(
    child: ListTile(
      title: Text(
        widget.ticTacToe.getGameTile(game, widget.currentPlayer.name,
            widget.isSelectedOpponent ? widget.selectedOpponent.name : ""),
        style: const TextStyle(
          fontSize: 16.0,
          decoration: TextDecoration.none,
        ),
      ),

      //allow only current user to delete game
      trailing: widget.currentPlayer.playerID == game.playerXID
          ? IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.redAccent,
              onPressed: () {
                String result = DatabaseService.deleteGame(game);
                if (result.isNotEmpty) {
                  showDialog("Delete Player Request Failed",
                      "Unable to delete the requested player (${game.gameID}.\n"
                      " $result",
                      true);
                  return;
                }
              },
            )
          : null,

      //select the game to work with
      onLongPress: widget.currentPlayer.playerID == game.playerXID ||
          widget.currentPlayer.playerID == game.playerOID
          ? () async {
              //if opponent is selected
              if (widget.isSelectedOpponent &&
                  widget.selectedOpponent.name !=
                      widget.currentPlayer.name) {
                widget.selectedGame = game.copyWith(
                    playerOID: widget.selectedOpponent.playerID,
                    playerOName: widget.selectedOpponent.name,
                );
                widget.selectedGameID = game.gameID;
                await DatabaseService.updateGame(widget.selectedGame);
              } else {
                widget.selectedGame = game.copyWith();
                widget.selectedGameID = game.gameID;
                await DatabaseService.updateGame(widget.selectedGame);
              }

              setState(() {
                widget.selectedGameID = game.gameID;
                widget.selectedGameIndex = index;
              });
            }
          : null,

      //Reset the long tap changes
      onTap: () {
        setState(() {
          widget.selectedGameID = "";
          widget.selectedGameIndex = -1;
        });
      },
    ),
  );

  ///
  /// Show message (snakbar)
  ///
  void showMessage(String message, bool isError) {
    Utils.showSnackBarMessage(context, message, isError);
  }

  ///
  /// show dialog
  ///
  void showDialog(String title, String message, bool isError) {
    Utils.buildShowDialog(context, title, message, isError);
  }

  ///
  /// Navigate to the TicTacToe page
  ///
  void navigateToPage() {
    Navigator.push(context,
        MaterialPageRoute(
            builder: (_) => TicTacToeHomePage(
                  playerXName: widget.selectedGame.playerXName,
                  playerOName: widget.selectedGame.playerOName,
                  selectedGame: widget.selectedGame,
                  currentPlayer: widget.currentPlayer,
                ))
      ).then((_) async {
        // get callback after coming back from NextPage()
        int totWins = widget.currentPlayer.totalWins;
        int totLosses = widget.currentPlayer.totalLosses;

        widget.selectedGame =
            (await DatabaseService.findGame(widget.selectedGame.gameID))!;

        debugPrint("CALLED BACK GAME FROM DB.... ${widget.selectedGame.toString()}");

        if (widget.selectedGame.playerOID == widget.currentPlayer.playerID) {
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
        debugPrint("CALLED BACK PLAYER.... ${widget.currentPlayer.toString()}");
        DatabaseService.updatePlayer(widget.currentPlayer);
      });
  }
}

///
///
class _ScrollbarBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) {
    return Scrollbar(
      controller: details.controller,
      thickness: 6.0,
      thumbVisibility: true,
      trackVisibility: true,
      child: child,
    );
  }
}

