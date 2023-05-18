
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tictactoe_game/models/player.dart';
import 'package:tictactoe_game/screens/player_waiting_page.dart';
import 'package:tictactoe_game/screens/text_form_fields/phone_number_field.dart';
import 'package:tictactoe_game/screens/text_form_fields/text_entry_field.dart';
import 'package:tictactoe_game/services/database/database_service.dart';

import '../main.dart';
import '../models/tictactoe_model.dart';
import '../services/utils.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  // final phoneNumberController = TextEditingController();

  TicTacToe ticTacToe = TicTacToe(
    games: [],
    players: [],
  );


  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    // phoneNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Multi Player Sign In'),
        centerTitle: true,
      ),

      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),

          children: <Widget> [

            const Image(
              image: AssetImage('assets/images/TicTacToe.png'),
            ),

            const SizedBox(height: 10),

            const Text(
              'Sign In',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 32),

            const Text(
              'Select Your Name From List\n or Create New Name',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
            ),

            // playerListSelection(),
            playerListContainer(),

            const SizedBox(height: 4),

            TextEntryField(
              editingController: nameController,
              fieldLabel: 'Enter Name',
              onChanged: (value) {
                // print("Name value = $value");
              },
              errorText: "Field must be valued",
            ),

            // PhoneNumberField(
            //   fieldLabel: "Mobile Phone Number",
            //   hintText: "",
            //   onChanged: (value) {
            //     // print("Phone Number value = $value");
            //   },
            //   editingController: phoneNumberController,
            //   errorText: "Enter a valid Phone Number.",
            //
            // ),

            SizedBox(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size.fromHeight(40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),

                onPressed: () async {
                  _hideKeyboard(context);

                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                  }

                  Player? player = await validateAndGetPlayer();
                  if (player == null) {
                    return;
                  }

                  navigateToNextPage(player);
                },

                child: const Text(
                    "Join / Start Game",
                    style: TextStyle(fontSize: 18),
                ),
              ),
            ),

          ],
        ),

      ),
    );
  }

  void navigateToNextPage(Player player) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (_) =>
            PlayerWaitingPage(currentPlayer: player)
        )
    );
  }

  ///
  /// hide keyboard
  ///
  void _hideKeyboard(BuildContext context)  {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  Future<Player?> validateAndGetPlayer() async {
   if (nameController.text.isEmpty) {
      Utils.showSnackBarMessage(context, "PLAYER Name must be valued", true);
      return null;
    }

    // if (phoneNumberController.text.isEmpty) {
    //   Utils.showSnackBarMessage(context, "PLAYER Phone Number must be valued", true);
    //   return null;
    // }

    Player? player = Player(
        playerID: DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text);
        // phoneNumber: phoneNumberController.text);

    player = await DatabaseService.insertIfPlayerNotExist(player);

    return player;
  }

  ///
  /// container for showing the current list of all players
  Widget playerListSelection() {

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),

        margin: const EdgeInsets.all(14),

        child: playerListContainer(),
    );
  }

  ///
  /// container for showing the current list of Games with status
  Widget playerListContainer() {
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
          stream: DatabaseService.getAllPlayers(),

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
                  thickness: 2,
                ),

                // padding: const EdgeInsets.symmetric(vertical: 0.0),
                itemCount: players.length,

                itemBuilder: (BuildContext context, int index) {
                  final player = players[index];
                  if (index == 0) {
                    ticTacToe.resetPlayers();
                  }
                  ticTacToe.addPlayer(player);
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
  /// build & display the player tile
  Widget buildPlayerTile(Player player, int index) {
    return ListTile(
      title: Text(
        player.name, // \n${player.phoneNumber}",
        style: const TextStyle(
          fontSize: 18.0,
          decoration: TextDecoration.none,
        ),
      ),

      //select any player opponent but current player
      onTap: () {
        setState(() {
          nameController.text = player.name;
          // phoneNumberController.text = player.phoneNumber;
        });
      },
    );
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
