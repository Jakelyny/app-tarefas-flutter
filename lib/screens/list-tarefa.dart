import 'package:flutter/material.dart';
import 'package:pteste/database/tarefa_dao.dart';
import '../models/tarefa.dart';
import 'form-tarefa.dart';

class ListaTarefa extends StatefulWidget {
  List<Tarefa> _tarefas = [];

  @override
  State<StatefulWidget> createState() {
    return ListaTarefaState();
  }
}

class ListaTarefaState extends State<ListaTarefa> {
  TarefaDao dao = TarefaDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final Future future = Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FormTarefa();
          }));
          future.then((tarefa) {
            setState(() {});
          });
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<List<Tarefa>>(
        initialData: [],
        future: dao.findAll(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.data != null) {
                final List<Tarefa>? tarefas = snapshot.data;
                return ListView.builder(
                  itemCount: tarefas!.length,
                  itemBuilder: (context, indice) {
                    final tarefa = tarefas[indice];
                    return Dismissible(
                      key: UniqueKey(),
                      background: Container(
                        color: Colors.deepOrangeAccent,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Confirmação"),
                              content: Text("Deseja excluir esta tarefa?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);  // Cancela a exclusão
                                  },
                                  child: Text("Cancelar"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);  // Confirma a exclusão
                                  },
                                  child: Text("Confirmar"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onDismissed: (direction) {
                        _excluir(context, tarefa.id);  // Função para excluir a tarefa
                      },
                      child: ItemTarefa(context, tarefa),
                    );
                  },
                );
              }
              break;
            default:
              return Center(
                child: CircularProgressIndicator(),
              );
          }
          return Center(child: Text("Nenhuma Tarefa"));
        },
      ),
    );
  }

  Widget ItemTarefa(BuildContext context, Tarefa _tarefa) {
    return GestureDetector(
      onTap: () {
        final Future future = Navigator.push(context, MaterialPageRoute(builder: (context) {
          return FormTarefa(tarefa: _tarefa);
        }));
        future.then((value) => setState(() {}));
      },
      child: Card(
        child: ListTile(
          title: Text(_tarefa.descricao),
          subtitle: Text(_tarefa.obs),
          leading: Icon(Icons.add_alert),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _excluir(context, _tarefa.id);
                },
                child: Padding(
                  padding: EdgeInsets.all(8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _excluir(BuildContext context, int id) {
    dao.delete(id).then((value) => setState(() {}));
  }
}
