import 'package:flutter/material.dart';
import '../models/estudo.dart';

class FormEstudo extends StatefulWidget {
  final Estudo? estudo;
  final Function(Estudo) onSave;

  FormEstudo({this.estudo, required this.onSave});

  @override
  State<StatefulWidget> createState() {
    return FormEstudoState();
  }
}

class FormEstudoState extends State<FormEstudo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controladorDisciplina = TextEditingController();
  String? _selectedDiaSemana;
  bool _isChecked = false;
  final TextEditingController _controladorProfessor = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.estudo != null) {
      _controladorDisciplina.text = widget.estudo!.disciplina;
      _selectedDiaSemana = widget.estudo!.diaSemana;
      _isChecked = widget.estudo!.temAtividade;
      _controladorProfessor.text = widget.estudo!.professor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Form de estudos")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _controladorDisciplina,
                  decoration: InputDecoration(
                    labelText: "Disciplina",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Campo obrigatório";
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedDiaSemana,
                  items: diasDaSemana.map((String dia) {
                    return DropdownMenuItem<String>(
                      value: dia,
                      child: Text(dia),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedDiaSemana = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Dia da Semana",
                  ),
                ),
                ListTile(
                  title: Text("Tem Atividade:"),
                  trailing: Switch(
                    value: _isChecked,
                    onChanged: (bool value) {
                      setState(() {
                        _isChecked = value;
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                ),
                TextFormField(
                  controller: _controladorProfessor,
                  decoration: InputDecoration(
                    labelText: "Professor",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Campo obrigatório";
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _salvarEstudo(context);
                    },
                    child: Text("Salvar"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _salvarEstudo(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final estudo = Estudo(
        widget.estudo != null ? widget.estudo!.id : 0,
        _controladorDisciplina.text,
        _selectedDiaSemana ?? "Segunda-feira",
        _isChecked,
        _controladorProfessor.text,
      );

      widget.onSave(estudo);

      Navigator.pop(context);
    }
  }

  List<String> diasDaSemana = [
    "Segunda-feira",
    "Terça-feira",
    "Quarta-feira",
    "Quinta-feira",
    "Sexta-feira",
    "Sábado",
    "Domingo",
  ];
}
