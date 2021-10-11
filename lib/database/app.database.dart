import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tdm_movies_crud/database/filme_dao.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'dbtarefas.db');
  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(filmeDao.tableSQL);
    },
    version: 1,
    onDowngrade: onDatabaseDowngradeDelete,
  );
}
