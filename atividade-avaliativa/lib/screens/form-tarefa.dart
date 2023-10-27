import 'package:flutter/material.dart';
import '../models/tarefa.dart';
import '../components/editor.dart';
import '../database/tarefa_dao.dart';

class FormTarefa extends StatefulWidget {
  final Tarefa? tarefa;
  FormTarefa({this.tarefa});

  @override
  State<StatefulWidget> createState() {
    return FormTarefaState();
  }
}

class FormTarefaState extends State<FormTarefa> {
  final TextEditingController _controladorTarefa = TextEditingController();
  final TextEditingController _controladorObs = TextEditingController();
  int? _id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Form de Tarefas"),
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Editor(_controladorTarefa, "Tarefa", "Informe a Tarefa",
                      Icons.assignment),
                  Editor(_controladorObs, "Obs", "Informe a Obs",
                      Icons.assignment),
                  ElevatedButton(
                      onPressed: () {
                        criarTarefa(context);
                      },
                      child: Text("Salvar"))
                ],
              ))),
    );
  }

  void criarTarefa(BuildContext context) {
    TarefaDao dao = TarefaDao();
    if (_id != null){ // alteração
      final tarefa = Tarefa(_id!, _controladorTarefa.text, _controladorObs.text);
      dao.update(tarefa).then((id) => Navigator.pop(context));
    }else{
      final tarefa = Tarefa(0, _controladorTarefa.text, _controladorObs.text);
      dao.save(tarefa).then((id) {
        print("tarefa incluída: " + id.toString());
        Navigator.pop(context);
      });
    }
    SnackBar snackBar = SnackBar(content: Text("Tarefa atualizada!"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
   super.initState();
   if (widget.tarefa != null){
     _id = widget.tarefa!.id;
     _controladorTarefa.text = widget.tarefa!.descricao;
     _controladorObs.text = widget.tarefa!.obs;
   }
  }
}
