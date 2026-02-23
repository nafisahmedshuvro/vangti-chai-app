import 'package:flutter/material.dart';

void main() {
  runApp(const VangtiChaiApp());
}

class VangtiChaiApp extends StatelessWidget {
  const VangtiChaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VangtiChai',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const VangtiChaiHomePage(),
    );
  }
}

class VangtiChaiHomePage extends StatefulWidget {
  const VangtiChaiHomePage({super.key});

  @override
  State<VangtiChaiHomePage> createState() => _VangtiChaiHomePageState();
}

class _VangtiChaiHomePageState extends State<VangtiChaiHomePage> {
  String _amount = '0';
  Map<int, int> _change = {
    500: 0, 100: 0, 50: 0, 20: 0, 10: 0, 5: 0, 2: 0, 1: 0
  };
  final List<int> _notes = [500, 100, 50, 20, 10, 5, 2, 1];

  void _onKeyPressed(String value) {
    setState(() {
      if (value == 'CLEAR') {
        _amount = '0';
        _change.updateAll((key, value) => 0);
      } else {
        if (_amount.length < 12) {
          if (_amount == '0') {
            _amount = value;
          } else {
            _amount += value;
          }
        }
      }
      _calculateChange();
    });
  }

  void _calculateChange() {
    int amountValue = int.tryParse(_amount) ?? 0;
    Map<int, int> newChange = {};
    for (var note in _notes) {
      if (amountValue >= note) {
        newChange[note] = amountValue ~/ note;
        amountValue %= note;
      } else {
        newChange[note] = 0;
      }
    }
    _change = newChange;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VangtiChai'),
      ),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              // --- PORTRAIT LAYOUT --- 
              return Column(
                children: [
                  Expanded(
                    flex: 2, // Info section takes 2 parts of the height
                    child: Row(
                      children: [
                        Expanded(flex: 3, child: _buildChangeList()),
                        Expanded(flex: 2, child: _buildAmountDisplay()),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3, // Keypad takes 3 parts of the height
                    child: _buildNumericKeypad(),
                  ),
                ],
              );
            } else {
              // --- LANDSCAPE LAYOUT (ADJUSTED) ---
              return Row(
                children: [
                  Expanded(
                    flex: 1, // Change list takes the left half
                    child: _buildChangeList(),
                  ),
                  Expanded(
                    flex: 1, // Right column takes the right half
                    child: Column(
                      children: [
                        // Amount box is made smaller
                        Expanded(
                          flex: 2, // Amount display is smaller
                          child: _buildAmountDisplay(),
                        ),
                        // Keypad is made bigger
                        Expanded(
                          flex: 3, // Keypad is bigger
                          child: _buildNumericKeypad(),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildChangeList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _notes.map((note) {
            return FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                'Taka $note: ${_change[note] ?? 0}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            );
          }).toList()),
    );
  }

  Widget _buildAmountDisplay() {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Amount:',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  _amount,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumericKeypad() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _buildButtonRow(['1', '2', '3']),
          _buildButtonRow(['4', '5', '6']),
          _buildButtonRow(['7', '8', '9']),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton(
                      onPressed: () => _onKeyPressed('0'),
                      child: const FittedBox(
                        child: Text('0', style: TextStyle(fontSize: 24)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black),
                      onPressed: () => _onKeyPressed('CLEAR'),
                      child: const FittedBox(
                        child: Text('CLEAR', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> keys) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: keys.map((key) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black),
                onPressed: () => _onKeyPressed(key),
                child: FittedBox(
                  child: Text(key, style: const TextStyle(fontSize: 24)),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
