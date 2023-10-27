import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'estudo_dao.dart';

const String tableSqlEstudo = 'CREATE TABLE estudos ( '
    'id INTEGER PRIMARY KEY, '
    'disciplina TEXT, '
    'dia_semana TEXT, '
    'tem_atividade BOOLEAN, '
    'professor TEXT)';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'dbtarefasss.db');
  return openDatabase(path,
      onCreate: (db, version){
        print("testeeeeeeeeeeeeeeeeeee nova tabela cursos");
        db.execute(EstudoDao.tableSql);
      },
      onUpgrade: (db, oldVersion, newVersion) async{
        var batch = db.batch();
        print("versão antiga: "+ oldVersion.toString());
        print("versão nova:" + newVersion.toString());
        if (newVersion > oldVersion){
          batch.execute(tableSqlEstudo);
          print("criando nova tabela cursos");
        }
        await batch.commit();
      },
      onDowngrade: onDatabaseDowngradeDelete,
      version: 9);
}
