import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Hub',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/download.jpg', // Assuming download.jpeg is in the assets folder
              fit: BoxFit.cover,
            ),
            GameMenu(),
          ],
        ),
      ),
    );
  }
}

class GameMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GameOptionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TicTacToeGame(),
                ),
              );
            },
            text: 'Tic Tac Toe',
          ),
          GameOptionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RockPaperScissorsGame(),
                ),
              );
            },
            text: 'Rock Paper Scissors',
          ),
          GameOptionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GuessGame(),
                ),
              );
            },
            text: 'Guess the Number',
          ),
        ],
      ),
    );
  }
}

class GameOptionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const GameOptionButton({
    required this.onPressed,
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: 20),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}

class TicTacToeGame extends StatefulWidget {
  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  List<String> board = List.filled(9, ''); // Initialize empty board
  String currentPlayer = 'X'; // X starts the game
  String winner = '';
  bool gameOver = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Current Player: $currentPlayer',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemCount: 9,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (gameOver || board[index] != '') return;
                    setState(() {
                      board[index] = currentPlayer;
                      if (checkWinner(currentPlayer)) {
                        winner = currentPlayer;
                        gameOver = true;
                      } else if (isBoardFull()) {
                        winner = 'Tie';
                        gameOver = true;
                      } else {
                        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: Text(
                        board[index],
                        style: TextStyle(
                          fontSize: 40,
                          decoration: board[index].startsWith('─') ||
                                  board[index].startsWith('│') ||
                                  board[index].startsWith('↘') ||
                                  board[index].startsWith('↙') ||
                                  board[index].startsWith('↗') ||
                                  board[index].startsWith('↖')
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            if (gameOver)
              Column(
                children: [
                  Text(
                    winner != 'Tie' ? 'Winner: $winner' : 'It\'s a Tie!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: resetGame, // Reset the game on button press
                    child: Text('New Game'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // Function to reset the game
  void resetGame() {
    setState(() {
      board = List.filled(9, ''); // Reset the board
      currentPlayer = 'X'; // Reset the current player
      winner = ''; // Reset the winner
      gameOver = false; // Reset the game over flag
    });
  }

  bool checkWinner(String player) {
    // Check rows
    for (int i = 0; i < 9; i += 3) {
      if (board[i] == player &&
          board[i + 1] == player &&
          board[i + 2] == player) {
        return true;
      }
    }
    // Check columns
    for (int i = 0; i < 3; i++) {
      if (board[i] == player &&
          board[i + 3] == player &&
          board[i + 6] == player) {
        return true;
      }
    }
    // Check diagonals
    if (board[0] == player && board[4] == player && board[8] == player) {
      return true;
    }
    if (board[2] == player && board[4] == player && board[6] == player) {
      return true;
    }
    return false;
  }

  bool isBoardFull() {
    for (String cell in board) {
      if (cell == '') {
        return false;
      }
    }
    return true;
  }
}

class RockPaperScissorsGame extends StatefulWidget {
  @override
  _RockPaperScissorsGameState createState() => _RockPaperScissorsGameState();
}

class _RockPaperScissorsGameState extends State<RockPaperScissorsGame> {
  final List<String> choices = ['Rock', 'Paper', 'Scissors'];
  String playerChoice = '';
  String computerChoice = '';
  String result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rock Paper Scissors'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/rps.jpg',
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Choose your move:',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: choices.map((choice) {
                    return ElevatedButton(
                      onPressed: () => playGame(choice),
                      child: Text(choice),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                Text(
                  'You chose: $playerChoice',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Computer chose: $computerChoice',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                Text(
                  '$result',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void playGame(String choice) {
    setState(() {
      playerChoice = choice;
      final random = Random();
      computerChoice = choices[random.nextInt(choices.length)];
      result = determineWinner(playerChoice, computerChoice);
    });
  }

  String determineWinner(String player, String computer) {
    if (player == computer) {
      return 'It\'s a tie!';
    } else if ((player == 'Rock' && computer == 'Scissors') ||
        (player == 'Paper' && computer == 'Rock') ||
        (player == 'Scissors' && computer == 'Paper')) {
      return 'You win!';
    } else {
      return 'Computer wins!';
    }
  }
}

class GuessGame extends StatefulWidget {
  @override
  _GuessGameState createState() => _GuessGameState();
}

class _GuessGameState extends State<GuessGame> {
  int? _randomNumber;
  String _feedback = '';

  @override
  void initState() {
    super.initState();
    _generateRandomNumber();
  }

  void _generateRandomNumber() {
    final random = Random();
    _randomNumber =
        random.nextInt(100) + 1; // Generates a random number between 1 and 100
  }

  void _checkGuess(int guess) {
    setState(() {
      if (_randomNumber == null) return;
      if (guess == _randomNumber) {
        _feedback = 'Congratulations! You guessed the number $_randomNumber!';
      } else if (guess < _randomNumber!) {
        _feedback = 'Too low! Try a higher number.';
      } else {
        _feedback = 'Too high! Try a lower number.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guess The Number'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/download3.jpg',
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '$_feedback',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _generateRandomNumber();
                    setState(() {
                      _feedback = '';
                    });
                  },
                  child: Text('New Game'),
                ),
                SizedBox(height: 30),
                Container(
                  width: 200,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Enter your guess',
                    ),
                    onSubmitted: (value) {
                      int guess = int.tryParse(value) ?? 0;
                      _checkGuess(guess);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
