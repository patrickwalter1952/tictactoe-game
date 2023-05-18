
import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  late final String playerID;
  final String name;
  final String phoneNumber;
  final int totalWins;
  final int totalLosses;

  Player({
    required this.playerID,
    required this.name,
    this.phoneNumber = "123-456-7890",
    this.totalWins = 0,
    this.totalLosses = 0,
  });

  static const String PLAYER_ID = "playerID";
  static const String PLAYER_NAME = "name";
  static const String PLAYER_PHONENUMBER = "phoneNumber";

  Map<String, dynamic> toMap() {
    return {
      'playerID': playerID,
      'name': name,
      'phoneNumber': phoneNumber,
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
      phoneNumber: data?['phoneNumber'],
      totalWins: data?['totalWins'],
      totalLosses: data?['totalLosses'],
    );
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      playerID: map['playerID'] ?? '',
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      totalWins: map['totalWins'] ?? 0,
      totalLosses: map['totalLosses'] ?? 0,
    );
  }

  Player copyWith({
    String? playerID,
    String? name,
    String? phoneNumber,
    int? totalWins,
    int? totalLosses,
  }) {
    return Player(
      playerID: playerID ?? this.playerID,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      totalWins: totalWins ?? this.totalWins,
      totalLosses: totalLosses ?? this.totalLosses,
    );
  }

  ///
  ///
  bool isEqual(Player otherPlayer) {
    return name == otherPlayer.name && phoneNumber == otherPlayer.phoneNumber;
  }

  @override
  String toString() {
    return "$name  $phoneNumber $playerID $totalWins $totalLosses";
  }

  String tilePlayerInfo() {
    // return "$name  \n$phoneNumber\nWins: $totalWins  Losses: $totalLosses";
    return "$name\nWins: $totalWins  Losses: $totalLosses";
  }
}
