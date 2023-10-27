import 'package:flutter/material.dart';
import '../models/estudo.dart';
import '../database/estudo_dao.dart';
import 'form.dart';

class ListaEstudo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListaEstudoState();
  }
}

class ListaEstudoState extends State<ListaEstudo> {
  final EstudoDao dao = EstudoDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Estudos"),
        backgroundColor: Colors.teal[900],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _abrirFormularioEstudo(context);
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<List<Estudo>>(
        initialData: [],
        future: dao.findAll(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.data != null) {
                final List<Estudo>? estudos = snapshot.data;
                return ListView.builder(
                  itemCount: estudos!.length,
                  itemBuilder: (context, indice) {
                    final estudo = estudos[indice];
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
                              content: Text("Deseja excluir este estudo?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text("Cancelar"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: Text("Confirmar"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onDismissed: (direction) {
                        _excluir(estudo.id);
                      },
                      child: _buildItemEstudo(context, estudo),
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
          return Center(child: Text("Nenhum estudo encontrado"));
        },
      ),
    );
  }

  Widget _buildItemEstudo(BuildContext context, Estudo estudo) {
    return GestureDetector(
      onTap: () {
        _abrirFormularioEstudo(context, estudo);
      },
      child: Card(
        child: ListTile(
          title: Text("Disciplina: ${estudo.disciplina}"),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Dia da Semana: ${estudo.diaSemana}"),
              Text("Tem Atividade: ${estudo.temAtividade ? 'Sim' : 'Não'}"),
              Text("Professor: ${estudo.professor}"),
            ],
          ),
          leading: Icon(Icons.school),
        ),
      ),
    );
  }

  void _abrirFormularioEstudo(BuildContext context, [Estudo? estudo]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormEstudo(
          estudo: estudo,
          onSave: (estudo) {
            if (estudo.id != 0) {
              dao.update(estudo).then((value) {
                setState(() {});
              });
            } else {
              dao.save(estudo).then((value) {
                setState(() {});
              });
            }
          },
        ),
      ),
    );

    // Handle the result if needed
  }

  void _excluir(int id) {
    dao.delete(id).then((value) {
      setState(() {});
    });
  }
}
