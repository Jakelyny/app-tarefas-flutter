import 'package:flutter/material.dart';
import 'package:pteste/screens/form.dart';
import 'package:pteste/screens/form-tarefa.dart';
import 'package:pteste/screens/gifs.dart';
import 'package:pteste/screens/list.dart';
import 'package:pteste/screens/list-tarefa.dart';

class MenuOptions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MenuOptionsState();
  }
}

class MenuOptionsState extends State<MenuOptions> {
  int paginaAtual = 0;
  PageController? pc;

  setPaginaAtual(pagina) {
    setState(() {
      paginaAtual = pagina;
    });
  }

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: paginaAtual);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pc,
        children: [ListaTarefa(), ListaEstudo(), GifPage()],
        onPageChanged: setPaginaAtual,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.task_outlined), label: "Tarefa"),
          BottomNavigationBarItem(
              icon: Icon(Icons.task_outlined), label: "Estudos"),
          BottomNavigationBarItem(
              icon: Icon(Icons.gif), label: "Gifs")
        ],
        onTap: (pagina) {
          pc?.animateToPage(pagina,
              duration: Duration(microseconds: 400), curve: Curves.ease);
        },
        backgroundColor: Colors.teal[900],
      ),
    );
  }
}