
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/game.dart';
import '../../models/player.dart';



class DatabaseService {

  static CollectionReference playersCollection = FirebaseFirestore.instance.collection("players");
  static CollectionReference gamesCollection = FirebaseFirestore.instance.collection("games");
  static late StreamSubscription<DocumentSnapshot<Object?>> listener;

  ////////////////////////////////////////////////////////////////////
  // PLAYERS DATABASE
  ////////////////////////////////////////////////////////////////////
  ///
  /// Get all Players
  static Stream<List<Player>> getAllPlayers() =>
      FirebaseFirestore.instance.collection("players").orderBy("name").snapshots().
          map((snapshot) => snapshot.docs.map((doc) =>
          Player.fromMap(doc.data())).toList());

  static void printAllPlayers() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("players").get().then(
          (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          print('${docSnapshot.id} => ${docSnapshot.data()}');
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  ///
  /// CREATE PLAYER
  static Future<Player?> createPlayer(Player player) async {
    try {
      //generate auto-generated ID
      final docPlayer = playersCollection.doc(player.playerID);
      docPlayer.set(player.toMap());

      print("PLAYER INSERTED: ${player.toString()}");
      return player;
    } catch (e) {
      print("PLAYER NOT INSERTED: ${player.toString()} \n ${e.toString()}");
      return null;
    }
  }

  ///
  /// CHECK PLAYER EXIST .. If not then insert
  static Future<Player?> insertIfPlayerNotExist(Player player) async {
    bool foundPlayer = false;

    try {
      final docRef = await playersCollection.where("name", isEqualTo: player.name).get().
      then((snapshot) async {
        foundPlayer = false;
        for (var element in snapshot.docs) {
          foundPlayer = true;
          Player dbPlayer = Player.fromMap(element.data() as Map<String, dynamic>);

          print("insertIfPlayerNotExist  FOUND ${element.data()}");

          if (player.phoneNumber != dbPlayer.phoneNumber) {
            player = dbPlayer.copyWith(
                phoneNumber: player.phoneNumber);
            updatePlayer(player);
          } else {
            player = dbPlayer.copyWith();
          }
        }
        if (!foundPlayer) {
          await createPlayer(player);
          print("insertIfPlayerNotExist  NOT FOUND - CREATED - ${player.toString()}");
        }
        return player;
      });
    } catch (e) {
      print("ERROR - Check for Player existence - insertIfPlayerNotExist.... $e");
    }
    return player;
  }

  ///
  /// CHECK PLAYER EXIST .. If not then insert
  static Future<bool> doesPlayerExist(String playerName) async {
    bool foundPlayer = false;

    try {
      final docRef = await playersCollection.where("name", isEqualTo: playerName).get().
      then((snapshot) {
        // bool foundPlayer = false;
        for (var element in snapshot.docs) {
          foundPlayer = true;
        }
        print("doesPlayerExist $playerName IN: $foundPlayer");
      });
      print("doesPlayerExist $playerName OUT: $foundPlayer");
      return foundPlayer;
    } catch (e) {
      print("ERROR - Check for Player existence - doesPlayerExist.... $e");
      return foundPlayer;
    }
  }

  ///
  /// Find the requested Player
  static Future<Player?> findPlayer(String playerName) async {
    late Player? player;
    bool foundPlayer = false;

    try {
      await playersCollection.where("name", isEqualTo: playerName).get().
      then((snapshot) {
        // bool foundPlayer = false;
        for (var element in snapshot.docs) {
          foundPlayer = true;

          player = Player.fromMap(element.data() as Map<String, dynamic>);
        }
      });

      if (foundPlayer) {
        print("doesPlayerExist $playerName OUT: ${player.toString()}");
      } else {
        print("doesPlayerExist $playerName OUT -- NOT FOUND");
      }

      return player;
    } catch (e) {
      print("ERROR - Check for Player existence - FindPlayer.... $e");
      return null;
    }
  }

  ///
  /// UPDATE PLAYER
  /// return: error message
   static String updatePlayer(Player player)  {
    try {
      final docPlayer = playersCollection.doc(player.playerID);
      docPlayer.update(player.toMap());

      print("PLAYER UPDATED: ${player.toString()}");
      return "";
    } catch (e) {
      print("PLAYER NOT UPDATED: ${player.toString()} \n ${e.toString()}");
      return e.toString();
    }
  }

  /// DELETE PLAYER
  /// return: error message
  static String deletePlayer(Player player) {
    try {
      String errorMsg = "";
      print("PLAYER DELETE: ${player.toString()}");
      playersCollection.doc(player.playerID).delete().
              onError((error, stackTrace) => errorMsg = error.toString());

      return errorMsg;
    } catch (e) {
      return e.toString();
    }
  }

  ////////////////////////////////////////////////////////////////////
  // GAMES DATABASE
  ////////////////////////////////////////////////////////////////////
  ///
  /// Get all the games
  static Stream<List<Game>> getAllGames() =>
      FirebaseFirestore.instance.collection("games").orderBy("date").snapshots().
      map((snapshot) => snapshot.docs.map((doc) =>
          Game.fromMap(doc.data())).toList());

  ///
  /// get all games that are active
  static Stream<List<Game>> getAllGamesActive() =>
      FirebaseFirestore.instance.collection("games").
      where("gameStatus", isEqualTo: "active").snapshots().
      map((snapshot) => snapshot.docs.map((doc) =>
          Game.fromMap(doc.data())).toList());

  ///
  /// CREATE GAME
  static Game? createGame(Game game) {
    try {
      final docPlayer = gamesCollection.doc(game.gameID);
      docPlayer.set(game.toMap());

      print("GAME CREATED: ${game.toString()}");
      return game;
    } catch (e) {
      print("GAME NOT CREATED: ${game.toString()} \n ${e.toString()}");
      return null;
    }
  }

  ///
  /// CHECK PLAYER EXIST .. If not then insert
  static Future<Game> insertIfGameNotExist(Game game) async {
    bool foundGame = false;

    try {
      final docRef = await gamesCollection.
                    where("gameID", isEqualTo: game.gameID).get().
      then((snapshot) {
        for (var element in snapshot.docs) {
          foundGame = true;
          game = Game.fromMap(element.data() as Map<String, dynamic>);
          print("insertIfGameNotExist  FOUND ${element.data()}");
        }
        if (!foundGame) {
          game = createGame(game)!;
          print("insertIfGameNotExist  NOT FOUND - CREATED - ${game.toString()}");
        }
        return game;
        if (!foundGame) {
          createGame(game);
        }
      });
    } catch (e) {
      print("ERROR - Check for Game existence.... $e");
    }
    return game;
  }

  ///
  /// UPDATE GAME
  /// return: error message
  static Future<String> updateGame(Game game) async {
    try {
      final docPlayer = gamesCollection.doc(game.gameID);
      docPlayer.update(game.toMap());

      print("GAME UPDATED: ${game.toString()}");
      return "";
    } catch (e) {
      print("GAME NOT UPDATED: ${game.toString()} \n ${e.toString()}");
      return e.toString();
    }
  }

  ///
  /// Find the requested Game
  static Future<Game?> findGame(String gameID) async {
    late Game? game;
    bool foundGame = false;

    try {
      await gamesCollection.doc(gameID).get().
      then((DocumentSnapshot doc) {
        foundGame = true;
        game = Game.fromMap(doc.data() as Map<String, dynamic>);

      });

      if (foundGame) {
        print("findGame $gameID OUT: ${game.toString()}");
      } else {
        print("findGame $gameID OUT -- NOT FOUND");
      }

      return game;
    } catch (e) {
      print("ERROR - FIND Game... $e");
      return null;
    }
  }

  /// DELETE PLAYER
  /// return: error message
  static String deleteGame(Game game) {
    try {
      String errorMsg = "";
      print("GAME DELETE: ${game.toString()}");
      gamesCollection.doc(game.gameID).delete().
             onError((error, stackTrace) => errorMsg = error.toString());

      return errorMsg;
    } catch (e) {
      return e.toString();
    }
  }

  ///
  ///
  static void subscribeToRealTimeUpdatesGames(String gameID, Function(dynamic) onChanged) {
    try {
      final docRef = gamesCollection.doc(gameID);
      listener = docRef.snapshots().listen((event) {
          final source = (event.metadata.hasPendingWrites) ? "Local" : "Server";
          // print("$source data: ${event.data()}");
          if (event.metadata.isFromCache) {
            return;
          }
          //if (!event.metadata.hasPendingWrites) {  ALWAYS GET LOCAL -- NEVER SERVER????
            onChanged(event.data()); //returns back the event data (GAME object)
          //}
        },
        onError: (error) => print("Listen failed: $error"),
      );


      // listener = gamesCollection.doc(gameID).snapshots().
      // listen((event) {
      //   print("${event.docs.}");
      //   valueGetter() => event;
      // });
    } catch(e) {
      print("SUBSCRIBE FOR GAME UPDATES LISTENER ERROR...:\n $e");
    }
  }

  static void closeRealTimeUpdateListener() {
    try {
      listener.cancel();
    } catch(e) {
      print("CANCEL GAME UPDATES LISTENER ERROR...:\n $e");
    }
  }
}
