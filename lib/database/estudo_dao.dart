import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/estudo.dart';
import 'app_database-estudo.dart';

class EstudoDao {
  static const String _tableName = "estudos";
  static const String _id = "id";
  static const String _disciplina = "disciplina";
  static const String _diaSemana = "dia_semana"; // Alterado para STRING
  static const String _temAtividade = "tem_atividade";
  static const String _professor = "professor";

  static const String tableSql =
      'CREATE TABLE estudos (id INTEGER PRIMARY KEY, disciplina TEXT, dia_semana TEXT, tem_atividade BOOLEAN, professor TEXT)';

  Map<String, dynamic> toMap(Estudo estudo) {
    final Map<String, dynamic> estudoMap = Map();
    estudoMap[_disciplina] = estudo.disciplina;
    estudoMap[_diaSemana] = estudo.diaSemana; // Use o valor do campo de texto
    estudoMap[_temAtividade] = estudo.temAtividade ? 1 : 0;
    estudoMap[_professor] = estudo.professor;
    return estudoMap;
  }

  Future<int> save(Estudo estudo) async {
    final Database db = await getDatabase();
    Map<String, dynamic> estudoMap = toMap(estudo);
    return db.insert(_tableName, estudoMap);
  }

  Future<int> update(Estudo estudo) async {
    final Database db = await getDatabase();
    Map<String, dynamic> estudoMap = toMap(estudo);
    return db.update(_tableName, estudoMap, where: '$_id = ?', whereArgs: [estudo.id]);
  }

  Future<int> delete(int id) async {
    final Database db = await getDatabase();
    return db.delete(_tableName, where: '$_id = ?', whereArgs: [id]);
  }

  List<Estudo> toList(List<Map<String, dynamic>> result) {
    final List<Estudo> estudos = [];
    for (Map<String, dynamic> row in result) {
      final Estudo estudo = Estudo(
        row[_id],
        row[_disciplina],
        row[_diaSemana],
        row[_temAtividade] == 1 ? true : false,
        row[_professor],
      );
      estudos.add(estudo);
    }
    return estudos;
  }

  Future<List<Estudo>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<Estudo> estudos = toList(result);
    return estudos;
  }
}
