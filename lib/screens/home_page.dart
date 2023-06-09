
import 'package:flutter/material.dart';
import 'package:tictactoe_game/screens/signin_page.dart';
import 'package:tictactoe_game/screens/single_user_home_page.dart';
import 'package:tictactoe_game/screens/tictactoe_computer_home_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tic Tac Toe Game'),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment. start,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: <Widget> [

            const SizedBox(height: 60),

            const Image(
              image: AssetImage('assets/images/TicTacToe.png'),
            ),

            const SizedBox(height: 20),

            const Text(
              'Welcome',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: 300,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(4),
                  backgroundColor: Colors.blue,
                  minimumSize: const Size.fromHeight(40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),

                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SingleUserHomePage()));
                },

                child: const Text(
                  "Single User Mode",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),

            const SizedBox(height: 4),

            SizedBox(
              width: 300,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(4),
                  backgroundColor: Colors.blue,
                  minimumSize: const Size.fromHeight(40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),

                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) =>
                          TicTacToeComputerHomePage()
                      )
                  );        // playerXName: playerXName,
                              // currentPlayer: currentPlayer)));
                },

                child: const Text(
                  "Compete With Computer",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),

            const SizedBox(height: 4),

            SizedBox(
              width: 300,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(4),
                  backgroundColor: Colors.blue,
                  minimumSize: const Size.fromHeight(40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),

                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignInPage()));
                },

                child: const Text(
                  "Multi Player Mode",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),

            ],
          ),
      ),

      );
  }

}
