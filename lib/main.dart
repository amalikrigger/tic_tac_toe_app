import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TicTacToeScreen(),
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  const TicTacToeScreen({super.key});

  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  List<List<String?>> board = [];
  String currentPlayer = 'X';
  int gridSize = 3;
  int validMovesCount = 0;

  @override
  void initState() {
    super.initState();
    initializeBoard();
  }

  void initializeBoard() {
    board =
        List.generate(gridSize, (_) => List.generate(gridSize, (_) => null));
    countValidMoves();
  }

  bool isValidMove(int row, int col) {
    return board[row][col] == null;
  }

  void handleClick(int row, int col) {
    if (isValidMove(row, col)) {
      setState(() {
        board[row][col] = currentPlayer;
        countValidMoves();
        if (checkWinner(row, col)) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('$currentPlayer wins!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      resetGame();
                    },
                    child: const Text('Play Again'),
                  ),
                ],
              );
            },
          );
        } else if (checkDraw()) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("It's a draw!"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      resetGame();
                    },
                    child: const Text('Play Again'),
                  ),
                ],
              );
            },
          );
        } else {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
        }
      });
    }
  }

  bool checkWinner(int lastRow, int lastCol) {
    String symbol = board[lastRow][lastCol]!;
    bool isWinner = false;

    // Check row
    if (board[lastRow].every((cell) => cell == symbol)) {
      isWinner = true;
    }

    // Check column
    if (!isWinner && board.every((row) => row[lastCol] == symbol)) {
      isWinner = true;
    }

    // Check diagonal
    if (!isWinner && lastRow == lastCol) {
      var i = 0;
      isWinner = board.every((row) => row[i++] == symbol);
    }
    if (!isWinner && lastRow + lastCol == gridSize - 1) {
      var i = 0;
      isWinner = board.every((row) => row[gridSize - 1 - i++] == symbol);
    }

    return isWinner;
  }

  bool checkDraw() {
    return board.every((row) => row.every((cell) => cell != null));
  }

  void resetGame() {
    setState(() {
      initializeBoard();
      currentPlayer = 'X';
    });
  }

  int countValidMoves() {
    if (board.isEmpty) return 0;

    for (int row = 0; row < board.length; row++) {
      for (int col = 0; col < board[row].length; col++) {
        if (isValidMove(row, col)) {
          validMovesCount++;
        }
      }
    }
    return validMovesCount;
  }

  List<int> computeSum(List<int> arr1, List<int> arr2) {
    if (arr1.length != arr2.length) {
      return []; // Arrays must have the same length
    }

    List<int> sumArray = [];
    for (int i = 0; i < arr1.length; i++) {
      sumArray.add(arr1[i] + arr2[i]);
    }
    return sumArray;
  }

  @override
  Widget build(BuildContext context) {
    print(computeSum([1, 2, 3], [3, 4, 5]));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Tic Tac Toe',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridSize,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
              ),
              itemCount: gridSize * gridSize,
              itemBuilder: (BuildContext context, int index) {
                int row = index ~/ gridSize;
                int col = index % gridSize;
                return GestureDetector(
                  onTap: () => handleClick(row, col),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(
                      child: Text(
                        board[row][col] ?? '',
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Next turn: $currentPlayer',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '$validMovesCount: valid moves left',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
