import 'package:calculador_curules_partidos/pages/parties_list_page.dart';
import 'package:flutter/material.dart';

import '../data/curules_data.dart';
import '../widgets/number_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _curulesQuantity = 0,
      _votosBlanco = 0,
      _totalPartiesVotes = 0,
      _totalValidVotes = 0,
      _partiesNumber = 0;
  double _umbral = 0;
  String _selectedCorporacion = '';
  String _selectedCircunscripcion = '';
  String _selectedDepartamento = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculador de curules de partidos'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              _buildCorporacionDropdown(),
              _buildCircunscripcionDropdown(),
              _buildDepartamentoDropdown(),
              // const Text('Número de curules:'),
              // NumberField(
              //   onChanged: (v) => setState(() {
              //     _curulesQuantity = int.tryParse(v) ?? 0;
              //   }),
              // ),
              // const SizedBox(height: 32.0),
              const Text('Número de votos de partidos: '),
              NumberField(
                onChanged: (v) => setState(() {
                  _totalPartiesVotes = int.tryParse(v) ?? 0;
                  _totalValidVotes = _totalPartiesVotes + _votosBlanco;
                }),
              ),
              const SizedBox(height: 32.0),
              const Text('Número de votos en blanco: '),
              NumberField(
                onChanged: (v) => setState(() {
                  _votosBlanco = int.tryParse(v) ?? 0;
                  _totalValidVotes = _totalPartiesVotes + _votosBlanco;
                }),
              ),
              const SizedBox(height: 32.0),
              const Text('Número de partidos: '),
              NumberField(
                onChanged: (v) => setState(() {
                  _partiesNumber = int.tryParse(v) ?? 0;
                }),
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                  onPressed: () {
                    // TODO: calculate valid votes here
                    // and validate that the fields have data(?
                    _calculateCurules();
                    _calculateUmbral();
                    Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => PartiesListPage(
                            curulesQuantity: _curulesQuantity,
                            validVotesNumber: _totalValidVotes,
                            partiesQuantity: _partiesNumber,
                            umbral: _umbral,
                          ),
                        ));
                  },
                  child: const Text('Siguiente')),
              // Text('Total votos validos: $_totalValidVotes')
            ],
          ),
        ),
      ),
    );
  }

  _buildCorporacionDropdown() {
    return Column(
      children: [
        const Text('Corporación:'),
        DropdownButton(
            alignment: Alignment.center,
            hint: const Text('Seleccione la corporación'),
            value: _selectedCorporacion.isEmpty ? null : _selectedCorporacion,
            items: const [
              DropdownMenuItem<String>(
                child: Text('Senado'),
                value: 'Senado',
              ),
              DropdownMenuItem<String>(
                child: Text('Camara de representantes'),
                value: 'Camara de representantes',
              ),
            ],
            onChanged: (v) {
              setState(() {
                _selectedCircunscripcion = '';
                _selectedCorporacion = v.toString();
              });
            }),
        const SizedBox(height: 32.0),
      ],
    );
  }

  _buildCircunscripcionDropdown() {
    List<DropdownMenuItem<String>> _menuItemsList = [];
    if (_selectedCorporacion == 'Senado') {
      _menuItemsList = const [
        DropdownMenuItem<String>(
          child: Text('Nacional'),
          value: 'Nacional',
        ),
        DropdownMenuItem<String>(
          child: Text('Indigena'),
          value: 'SIndigena',
        ),
      ];
    }
    if (_selectedCorporacion == 'Camara de representantes') {
      _menuItemsList = const [
        DropdownMenuItem<String>(
          child: Text('Departamental'),
          value: 'Departamental',
        ),
        DropdownMenuItem<String>(
          child: Text('Internacional'),
          value: 'Internacional',
        ),
        DropdownMenuItem<String>(
          child: Text('Indigena'),
          value: 'CIndigena',
        ),
        DropdownMenuItem<String>(
          child: Text('Negritudes'),
          value: 'Negritudes',
        ),
      ];
    }
    return _selectedCorporacion.isEmpty
        ? Container()
        : Column(
            children: [
              const Text('Circunscripción:'),
              DropdownButton(
                  alignment: Alignment.center,
                  value: _selectedCircunscripcion.isEmpty
                      ? null
                      : _selectedCircunscripcion,
                  items: _menuItemsList,
                  onChanged: (v) {
                    setState(() {
                      _selectedCircunscripcion = v.toString();
                      print(_selectedCircunscripcion);
                    });
                  }),
              const SizedBox(height: 32.0),
            ],
          );
  }

  _buildDepartamentoDropdown() {
    List<DropdownMenuItem<String>> departamentosItems = [];
    for (var departamento in curulesDepartamentos.keys) {
      departamentosItems.add(DropdownMenuItem(
        child: Text(departamento),
        value: departamento,
      ));
    }
    return _selectedCircunscripcion != 'Departamental'
        ? Container()
        : Column(
            children: [
              const Text('Departamento:'),
              DropdownButton(
                  alignment: Alignment.center,
                  hint: const Text('Seleccione el departamento'),
                  value: _selectedDepartamento.isEmpty
                      ? null
                      : _selectedDepartamento,
                  items: departamentosItems,
                  onChanged: (v) {
                    setState(() {
                      _selectedDepartamento = v.toString();
                    });
                  }),
              const SizedBox(height: 32.0),
            ],
          );
  }

  void _calculateCurules() {
    if (_selectedCircunscripcion == 'Departamental') {
      _curulesQuantity = curulesDepartamentos[_selectedDepartamento] ?? 0;
    } else {
      _curulesQuantity = asignatedCurules[_selectedCircunscripcion] ?? 0;
    }
    print('curules: $_curulesQuantity');
  }

// Umbral
// para senado nacional es Votos validos * 0.03
// para 2 curules es votos validos/curules * 0.3
// para más de 3 curules es votos validos/curules/2
// para los de 1 curul no se aplica umbral, se escoge el de mayor votación

  void _calculateUmbral() {
    if (_curulesQuantity == 100) {
      _umbral = _totalValidVotes * 0.03;
    } else if (_curulesQuantity > 2) {
      _umbral = _totalValidVotes / _curulesQuantity / 2;
    } else if (_curulesQuantity == 2) {
      _umbral = _totalValidVotes / _curulesQuantity * 0.3;
    }
    print('Umbral: $_umbral');
  }
}
