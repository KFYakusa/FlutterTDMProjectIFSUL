import 'package:sqflite/sqflite.dart';
import 'package:tdm_movies_crud/database/app.database.dart';
import 'package:tdm_movies_crud/models/Filme.dart';




class filmeDao {

  static const String _tableName = 'movies';
  static const String _id = 'id';
  static const String _nome = 'nome';
  static const String _ano = 'ano';
  static const String _link = 'link';
  static const String _checked = 'isChecked';
  static const String tableSQL = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY, '
      '$_nome TEXT,'
      '$_ano TEXT,'
      '$_link TEXT,'
      '$_checked INTEGER DEFAULT 0)';

  Future<int> save(Filme filme) async{
    final Database db = await getDatabase();
    Map<String, dynamic> filmeMap = toMap(filme);
    return db.insert(_tableName, filmeMap);
  }

  Future<int> update(Filme filme) async{
    final Database db = await getDatabase();
    Map<String, dynamic> filmeMap = toMap(filme);
    return db.update(_tableName, filmeMap, where: '$_id = ?', whereArgs: [filme.id]);
  }

  Future<int> delete(int id) async{
    final Database db = await getDatabase();
    return db.delete(_tableName, where: '$_id = ?', whereArgs: [id]);
  }

  Map<String, dynamic> toMap(Filme filme) {
    final Map<String, dynamic> filmeMap = Map();
    filmeMap[_nome] = filme.nome;
    filmeMap[_ano] = filme.ano;
    filmeMap[_link] = filme.linkOnline;
    filmeMap[_checked] = filme.checked;
    return filmeMap;
  }

  Future<List<Filme>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<Filme> filmes = toList(result);
    return filmes;
  }

  List<Filme> toList(List<Map<String, dynamic>> result) {
    final List<Filme> filmes = [];
    for (Map<String, dynamic> row in result) {
      final Filme filme = Filme(
          row['$_id'],
          row[_nome],
          row[_ano],
          row[_link],
          row[_checked]
      );
      filmes.add(filme);
    }
    return filmes;
  }
}