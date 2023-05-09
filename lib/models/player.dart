
import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  late final String playerID;
  final String name;
  final String email;
  final String phoneNumber;
  final String playerStatus;
  final int totalWins;
  final int totalLosses;

  Player({
    required this.playerID,
    required this.name,
    this.email = "tictactoe@gmail.com",
    this.phoneNumber = "123-456-7890",
    this.playerStatus = "inactive",
    this.totalWins = 0,
    this.totalLosses = 0,
  });

  static const String PLAYER_ID = "playerID";
  static const String PLAYER_NAME = "name";
  static const String PLAYER_EMAIL = "email";
  static const String PLAYER_PHONENUMBER = "phoneNumber";
  static const String PLAYER_STATUS = "playerStatus";

  Map<String, dynamic> toMap() {
    return {
      'playerID': playerID,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'playerStatus': playerStatus,
      'totalWins': totalWins,
      'totalLosses': totalLosses,
    };
  }

  factory Player.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Player(
      playerID: data?['playerID'],
      name: data?['name'],
      email: data?['email'],
      phoneNumber: data?['phoneNumber'],
      playerStatus: data?['playerStatus'],
      totalWins: data?['totalWins'],
      totalLosses: data?['totalLosses'],
    );
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      playerID: map['playerID'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      playerStatus: map['playerStatus'] ?? '',
      totalWins: map['totalWins'] ?? 0,
      totalLosses: map['totalLosses'] ?? 0,
    );
  }

  Player copyWith({
    String? playerID,
    String? name,
    String? email,
    String? phoneNumber,
    String? playerStatus,
    int? totalWins,
    int? totalLosses,
  }) {
    return Player(
      playerID: playerID ?? this.playerID,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      playerStatus: playerStatus ?? this.playerStatus,
      totalWins: totalWins ?? this.totalWins,
      totalLosses: totalLosses ?? this.totalLosses,
    );
  }

  @override
  String toString() {
    return "$name  $phoneNumber $email $playerID $playerStatus  $totalWins $totalLosses";
  }

  String tilePlayerInfo() {
    return "$name\nWins: $totalWins  Losses: $totalLosses";
    //  $playerID";
    // return "$name   $phoneNumber";
    // return "$name   $phoneNumber \n$email \n$playerID";
  }
}
