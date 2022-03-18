import 'dart:math';

import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({
    Key? key,
    required this.partiesQuantity,
    required this.curulesQuantity,
    required this.totalValidVotes,
    required this.partiesNames,
    required this.partiesVotes,
    required this.umbral,
  }) : super(key: key);

  final int partiesQuantity;
  final int curulesQuantity;
  final int totalValidVotes;
  final List<String> partiesNames;
  final List<double> partiesVotes;

  final double umbral;

  @override
  Widget build(BuildContext context) {
    // List<List<double>> _matrix = [];
    // actually top n*
    List<double> _top100 = [];
    double _cifraRepartidora = 0;
    Map<String, double> _partiesVotesAboveUmbral = {};
    Map<String, double> _partiesVotesBelowUmbral = {};
    List<double> _partiesCurulesQuantity = [];

    for (var j = 0; j < partiesVotes.length; j++) {
      if (partiesVotes[j] >= umbral) {
        _partiesVotesAboveUmbral.addAll({partiesNames[j]: partiesVotes[j]});

        // _top100.sort();

      } else {
        _partiesVotesBelowUmbral.addAll({partiesNames[j]: partiesVotes[j]});
      }
    }

    for (var i = 1; i <= curulesQuantity; i++) {
      // List<double> _partyVotes = [];

      _partiesVotesAboveUmbral.forEach((key, value) {
        //
        var innerValue = value / i;
        _top100.add(innerValue);

        // _partyVotes.add(innerValue);
      });

      // _matrix.add(_partyVotes);
    }
//   // print(matrix);
    _top100.sort();
    // pick the topN values
    _top100.removeRange(0, _top100.length - curulesQuantity);
//   // print(_top100.length);

// cifra repartidora is the lowest value from the topN
    _cifraRepartidora = _top100.first;

    final List<int> _partiesCurulesDecimals = [];

    _partiesVotesAboveUmbral.forEach((key, value) {
      var _partiesCurules = value / _cifraRepartidora;
      _partiesCurulesQuantity.add(_partiesCurules);
      _partiesCurulesDecimals.add(getDecimals(_partiesCurules));
    });

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
                    title: Text(partiesNames[index]),
                    trailing: Text(_partiesCurulesQuantity[index].toString()),
                    // _partiesCurulesQuantity[index].truncate().toString()),
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

int getDecimals(double number) {
  final decimals = ((number % 1) * pow(10, 4)).floor();
  print(decimals);
  return decimals;
}
