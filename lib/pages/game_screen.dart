import 'package:flutter/material.dart';
import 'package:tp_gregory/model/player.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class GameScreen extends StatefulWidget {
  final String title;
  final String player1Name;
  final String player2Name;

  const GameScreen({
    Key? key,
    required this.title,
    required this.player1Name,
    required this.player2Name,
  }) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const _boardLength = 3;
  late Player _player1;
  late Player _player2;
  late Player _currentPlayer;
  late List<List<String>> _board;

  @override
  void initState() {
    super.initState();
    _player1 = Player(
        name: widget.player1Name.toUpperCase(),
        symbole: "X",
        color: Colors.red);
    _player2 = Player(
        name: widget.player2Name.toUpperCase(),
        symbole: "O",
        color: Colors.blue);
    _currentPlayer = _player1;
    resetGame();
  }

  void resetGame() {
    setState(() {
      _board = List.generate(
        _boardLength,
        (_) => List.generate(_boardLength, (_) => ""),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blue, Colors.red],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Au tour de : ${_currentPlayer.name} (${_currentPlayer.symbole})",
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 65,
              ),
              Column(
                children: _board.asMap().entries.map((rowEntry) {
                  final rowIndex = rowEntry.key;
                  final rowValues = rowEntry.value;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: rowValues.asMap().entries.map((colEntry) {
                      final colIndex = colEntry.key;
                      final symbole = colEntry.value;
                      return GestureDetector(
                        onTap: () => makeMove(symbole, rowIndex, colIndex),
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: getPlayer(symbole).color,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: 100,
                          height: 100,
                          alignment: Alignment.center,
                          child: Text(
                            symbole,
                            style: const TextStyle(
                              fontSize: 45,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 75,
              ),
              InkWell(
                onTap: resetGame,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  child: const Text(
                    "Restart",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Player getPlayer(String value) {
    if (_player1.symbole == value) {
      return _player1;
    } else if (_player2.symbole == value) {
      return _player2;
    } else {
      return Player(symbole: '', color: Colors.white);
    }
  }

  void makeMove(String symbole, int row, int col) {
    if (symbole == "") {
      Player newCurrentPlayer;

      if (_currentPlayer == _player1) {
        newCurrentPlayer = _player2;
      } else {
        newCurrentPlayer = _player1;
      }

      setState(() {
        _board[row][col] = _currentPlayer.symbole;
        if (isWinner(row, col)) {
          showWinnerDialog('Le joueur ${_currentPlayer.name} Gagne');
        } else if (isTie()) {
          showTieDialog('Match Nul');
        }

        _currentPlayer = newCurrentPlayer;
      });
    }
  }

  bool isTie() {
    for (var rows in _board) {
      for (var cell in rows) {
        if (cell == "") {
          return false;
        }
      }
    }
    return true;
  }

  bool isWinner(int rowOfBoard, int colOfBoard) {
    var col = 0, row = 0, diag = 0, rdiag = 0;
    final playerSymbol = _board[rowOfBoard][colOfBoard];
    const n = _boardLength;

    for (int i = 0; i < n; i++) {
      if (_board[rowOfBoard][i] == playerSymbol) col++;
      if (_board[i][colOfBoard] == playerSymbol) row++;
      if (_board[i][i] == playerSymbol) diag++;
      if (_board[i][n - i - 1] == playerSymbol) rdiag++;
    }

    return row == n || col == n || diag == n || rdiag == n;
  }

  void showWinnerDialog(String title) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: title,
      desc: 'Cliquez ici pour recommencer une partie',
      btnOkOnPress: () {
        resetGame();
      },
    ).show();
  }

  void showTieDialog(String title) async {
    await AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: title,
      desc: 'Cliquez ici pour recommencer une partie',
      btnOkOnPress: () {
        resetGame();
      },
      btnOkColor: const Color(0xFFD93F47),
    ).show();
  }
}
