//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../models/player.dart';
//
// class PlayersTile extends StatelessWidget {
//   // final VoidCallback updateDistanceLog;
//   final Player player;
//
//   const PlayersTile({
//     // required this.updateDistanceLog,
//     required this.player,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       key: Key(player.name),
//
//       title: Text(
//         player.toString(),
//         style: const TextStyle(
//           fontSize: 16.0,
//           decoration: TextDecoration.none,
//         ),
//       ),
//
//       // subtitle: ,
//
//       trailing: IconButton(
//         icon: const Icon(Icons.delete),
//         color: Colors.redAccent,
//
//         onPressed: () {
//           // DatabaseService.instance.delete(distanceTravel.id!);
//           // updateDistanceLog();
//           // Navigator.of(context).pop();
//         },
//       ),
//
//       // onTap: () => Navigator.push(
//       //   context,
//       //   MaterialPageRoute(
//       //     fullscreenDialog: true,
//       //     builder: (_) => AddDistanceLogPage(
//       //       updateDistanceLog: updateDistanceLog,
//       //       distanceTravel: distanceTravel,
//       //     ),
//       //   ),
//       // ),
//
//     );
//   }
// }
