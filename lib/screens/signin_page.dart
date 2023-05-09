
import 'package:flutter/material.dart';
import 'package:tictactoe_game/models/player.dart';
import 'package:tictactoe_game/screens/player_waiting_page.dart';
import 'package:tictactoe_game/screens/text_form_fields/text_entry_field.dart';
import 'package:tictactoe_game/services/database/database_service.dart';

import '../main.dart';
import '../services/utils.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  // final emailController = TextEditingController();
  // final phoneNumberController = TextEditingController();


  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    // emailController.dispose();
    // phoneNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Multi User Sign In'),
        centerTitle: true,
      ),

      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),

          children: <Widget> [

            const Image(
              image: AssetImage('assets/images/TicTacToe2.png'),
            ),

            const SizedBox(height: 10),

            const Text(
              'Sign In',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 32),

            const Text(
              'Select Your Name or \nCreate New Name',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
            ),

            playerListSelection(),

            const SizedBox(height: 4),

            TextEntryField(
              editingController: nameController,
              fieldLabel: 'Enter Name',
              onChanged: (value) {
                print("Name value = $value");
              },
            ),

            // PhoneNumberField(
            //   fieldLabel: "Mobile Phone Number",
            //   hintText: "",
            //   onChanged: (value) {
            //     setState(() {
            //
            //     });
            //   },
            //   editingController: phoneNumberController,
            //   errorText: "Enter a valid Phone Number.",
            //
            // ),
            //
            // EmailField(
            //   editingController: emailController,
            //   fieldLabel: 'Enter Email',
            //   onChanged: (value) {
            //     print("Email value = $value");
            //   },
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

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) =>
                      PlayerWaitingPage(currentPlayer: player)
                    )
                  );
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
    print("Name: ${nameController.text}");
    // print("PHONE NUMBER: ${phoneNumberController.text}");
    // print("EMAIL: ${emailController.text}");

    if (nameController.text.isEmpty) {
      Utils.showSnackBarMessage(context, "PLAYER Name must be valued", true);
      return null;
    }

    Player? player = Player(
        playerID: DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text);
        // email: emailController.text,
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

        child: StreamBuilder<List<Player>>(
          stream: DatabaseService.getAllPlayers(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong! ${snapshot.error}");
            } else if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              List<Player> players = snapshot.data!;
              return Container(
                padding: const EdgeInsets.all(4.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: nameController.text.isEmpty ? null : nameController.text,
                    iconSize: 28,

                    icon: const Icon(Icons.arrow_downward),

                    isExpanded: true,
                    elevation: 12,

                    style: const TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),

                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        //print('Selected Item: $value');
                        nameController.text = value!;
                      });
                    },

                    items: players.map<DropdownMenuItem<String>>((Player player) {
                      return DropdownMenuItem<String>(
                        value: player.name,
                        child: Text(player.name),
                      );
                      }).toList(),

                    ),
                  ),
                );
              }
            },
        ),

    );
  }

}
