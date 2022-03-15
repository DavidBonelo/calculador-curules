import 'package:calculador_curules_partidos/pages/result_page.dart';
import 'package:calculador_curules_partidos/widgets/number_field.dart';
import 'package:flutter/material.dart';

class PartiesListPage extends StatefulWidget {
  const PartiesListPage({
    Key? key,
    required this.partiesQuantity,
    required this.curulesQuantity,
    required this.validVotesNumber,
    required this.umbral,
  }) : super(key: key);

  final int partiesQuantity;
  final int curulesQuantity;
  final int validVotesNumber;
  final double umbral;

  @override
  State<PartiesListPage> createState() => _PartiesListPageState();
}

class _PartiesListPageState extends State<PartiesListPage> {
  final List<TextEditingController> _namesControllers = [];
  List<String> _names = [];

  final List<TextEditingController> _votesControllers = [];
  List<double> _votes = [0, 0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de partidos'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(32.0),
                itemCount: widget.partiesQuantity,
                itemBuilder: (BuildContext context, int index) {
                  return _buildPartyInput(context, index);
                },
              ),
              ElevatedButton(
                  onPressed: () => Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => ResultPage(
                          curulesQuantity: widget.curulesQuantity,
                          totalValidVotes: widget.validVotesNumber,
                          partiesQuantity: widget.partiesQuantity,
                          names: _names,
                          votes: _votes,
                          umbral: widget.umbral,
                        ),
                      )),
                  child: const Text('Calcular curules')),
              const SizedBox(height: 32)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPartyInput(BuildContext context, int index) {
    // creates the controllers on demand (fked this bc of the button, change it to a fab)
    if (_namesControllers.length >= index + 1) {
    } else {
      var newNameController = TextEditingController();
      _namesControllers.add(newNameController);

      var newVotesController = TextEditingController();
      _votesControllers.add(newVotesController);
      print('created controllers for index #$index');
    }
    // return NumberTextField(
    //     controller: _textControllers[index],
    //     onChanged: (newValue) {
    //       _updateNumbers();
    //     });
    return Center(
      child: GridView.extent(
        childAspectRatio: 5,
        maxCrossAxisExtent: 500.0,
        shrinkWrap: true,
        // mainAxisSpacing: 32.0,
        crossAxisSpacing: 16.0,
        children: [
          TextField(
            onChanged: _updateNames,
            controller: _namesControllers[index],
            decoration: InputDecoration(
              hintText: 'Nombre del partido ${index + 1}',
            ),
          ),
          NumberField(
            controller: _votesControllers[index],
            onChanged: _updaateVotes,
          ),
        ],
      ),
    );
  }

  void _updateNames(String value) {
    List<String> newNames = [];

    for (var controller in _namesControllers) {
      newNames.add(controller.text);
    }
    _names = newNames;

    // _numbers = newNumbers.length >=2 ? newNumbers : [0, 0]; // simplified
    // _names = newNames.length >= 2
    //     ? newNames
    //     : newNames.isNotEmpty
    //         ? [newNames[0], ""]
    //         : ['', ''];
    // print(_numbers);

    // Rebuilds the OperationsButtonsV2 widget with the updated _numbers
    setState(() {});
  }

  void _updaateVotes(String p1) {
    List<double> newNumbers = [];

    for (var controller in _votesControllers) {
      double? number = double.tryParse(controller.text);
      if (number != null) newNumbers.add(number);
    }

    // _numbers = newNumbers.length >=2 ? newNumbers : [0, 0]; // simplified
    _votes = newNumbers.length >= 2
        ? newNumbers
        : newNumbers.isNotEmpty
            ? [newNumbers[0], 0]
            : [0, 0];
    // print(_numbers);

    // Rebuilds the OperationsButtonsV2 widget with the updated _numbers
    setState(() {});
  }
}
