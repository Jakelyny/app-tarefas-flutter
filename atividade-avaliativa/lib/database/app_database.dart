// app_database.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'tarefa_dao.dart';

const String tableSqlEstudo = 'CREATE TABLE estudos ( '
    'id INTEGER PRIMARY KEY, '
    'disciplina TEXT, '
    'dia_semana TEXT, '
    'tem_atividade BOOLEAN, '
    'professor TEXT)';

// tive que fazer uma gambiarra aqui para funcionar, criando um de cada vez

//const String tableSql2 =  'CREATE TABLE cursos ( '
//    ' id INTEGER PRIMARY KEY, '
//    ' nome TEXT, '
//    ' info TEXT)';


Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'dbtarefasss.db');
  return openDatabase(path,
      onCreate: (db, version){
        print("testeeeeeeeeeeeeeeeeeee nova tabela cursos");
        db.execute(TarefaDao.tableSql);
        db.execute(tableSqlEstudo);
      },
      onUpgrade: (db, oldVersion, newVersion) async{
        var batch = db.batch();
        print("versão antiga: "+ oldVersion.toString());
        print("versão nova:" + newVersion.toString());
        if (newVersion == 2){
          batch.execute(tableSqlEstudo);
          print("criando nova tabela cursos");
        }
        await batch.commit();
      },
      onDowngrade: onDatabaseDowngradeDelete,
      version: 2);
}