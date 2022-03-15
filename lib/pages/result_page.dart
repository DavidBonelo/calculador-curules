import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({
    Key? key,
    required this.partiesQuantity,
    required this.curulesQuantity,
    required this.totalValidVotes,
    required this.names,
    required this.votes,
    required this.umbral,
  }) : super(key: key);

  final int partiesQuantity;
  final int curulesQuantity;
  final int totalValidVotes;
  final List<String> names;
  final List<double> votes;

  final double umbral;
  // List<List<double>> matrix = [];
  // List<double> top100 = [];
  // double cifraRepartidora = 0;
  // List<double> partiesCurulesQuantity = [];

  @override
  Widget build(BuildContext context) {
    // final double _umbral = curulesQuantity > 2
    //     ? validVotesNumber * 0.03
    //     : validVotesNumber / curulesQuantity * 0.3;
    List<List<double>> _matrix = [];
    // actually top n*
    List<double> _top100 = [];
    double _cifraRepartidora = 0;
    List<double> _partiesCurulesQuantity = [];

    for (var i = 1; i <= curulesQuantity; i++) {
      List<double> _partyVotes = [];

      for (var j = 0; j < votes.length; j++) {
        var innerValue = votes[j] / i;
        _partyVotes.add(innerValue);

        _top100.sort();

        _top100.add(innerValue);
      }

      _matrix.add(_partyVotes);
      // print(_partidoValues);
    }
//   // print(matrix);
    _top100.sort();
    _top100.removeRange(0, _top100.length - curulesQuantity);
//   // print(_top100.length);

// cifra repartidora is the lowest value from the topN
    _cifraRepartidora = _top100.first;

    for (var i = 0; i < partiesQuantity; i++) {
      _partiesCurulesQuantity.add(votes[i] / _cifraRepartidora);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              curulesQuantity > 1 ? Text('''Curules: $curulesQuantity
Votos validos: $totalValidVotes
Umbral: $umbral
Cifra repartidora: $_cifraRepartidora''') : Text('''Curules: $curulesQuantity
Votos validos: $totalValidVotes
Cifra repartidora: $_cifraRepartidora'''),
              // 'Curules: $curulesQuantity\nUmbral: $_umbral\nVotos validos: $validVotesNumber'),
              ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.all(32.0),
                itemCount: partiesQuantity,
                itemBuilder: (_, index) {
                  return ListTile(
                    title: Text(names[index]),
                    trailing: Text(
                        _partiesCurulesQuantity[index].truncate().toString()),
                  );
                },
                separatorBuilder: (_, i) {
                  return const Divider();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
