import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tdm_movies_crud/database/filme_dao.dart';
import 'package:tdm_movies_crud/models/Filme.dart';
import 'package:tdm_movies_crud/screens/FormMovie.dart';

class HomePage extends StatefulWidget {
  // List<Filme> _listFilmes = <Filme>[];

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  final filmeDao _dao = new filmeDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Lista de filmes"))),
      body: FutureBuilder<List<Filme>>(
        initialData: [],
        future: Future.delayed(Duration(seconds: 0))
            .then((value) => _dao.findAll()),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
              break;
            case ConnectionState.waiting:
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        strokeWidth: 5,
                        backgroundColor: Theme.of(context).backgroundColor,
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                      )])));
            case ConnectionState.done:
              if (snapshot.data != null) {
                final List<Filme>? filmesDB = snapshot.data;
                return ListView.builder(
                  itemCount: filmesDB!.length,
                  itemBuilder: (context, index) {
                    final filme = filmesDB[index];
                    return ItemFilme(context, filme);
                  });}
              return Center(child: Text("nenhum filme "));
            default:
              return Center(child: Text("nenhum filme "));
          }
          if (snapshot.hasError) {
            return Center(child: Text("deu erro"));
          }
          return Center(child: Text("nenhum filme "));
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: " add new movie",
        onPressed: () {
          final Future future =
              Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FormMovie();
          }));
          future.then((movie) {
            setState(() {});
          });}));
  }

  Widget ItemFilme(BuildContext context, Filme _filme) {
    final filmeDao _dao = new filmeDao();

    void _updateChecked(_movie) {
      _dao.update(_movie);
    }
    void _excluirFilme(Filme _movie) {
      _dao.delete(_movie.id);
    }
    return Card(
      child: InkWell(
          splashColor: Colors.yellowAccent,
          onTap: (){},
          child:ListTile(
            tileColor: _filme.checked==1? Colors.green: null,
            leading: Checkbox(
              value: _filme.checked == 1,
              side: BorderSide(color: Colors.white),
              checkColor: Colors.lightGreenAccent,
              activeColor: Theme.of(context).scaffoldBackgroundColor,
              onChanged: (bool? value) {
                setState(() {
                  _filme.checked = value! ? 1 : 0;
                  _updateChecked(_filme);
                });
              }
            ),
            title: Text(_filme.nome),
            subtitle: Text(_filme.linkOnline),
            onTap: () {
              final Future future =
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return FormMovie(_filme);
              }));
              future.then((editReturn) {
                setState(() {});
              }, onError: (e) {
                debugPrint("error editing" + e);
              });
            },
            trailing: TextButton(
              onPressed: ()=>showDialog(
                context: context,
                builder: (BuildContext context)=> AlertDialog(
                  title: const Text("Excluir Filme"),
                  content: const Text('Certeza que deseja excluir este filme da lista de desejos?'),
                  actions: [
                    TextButton(
                      child: Icon(Icons.close),
                      onPressed: (){
                        return Navigator.pop(context,'Cancel');
                    }),
                    TextButton(
                      child:Icon(Icons.delete_outline_outlined, color: Colors.red),
                      onPressed: (){
                        _excluirFilme(_filme);
                        setState(() {});
                        return Navigator.pop(context,"OK");
                     })])),
                child: Icon(Icons.delete, color: Colors.red)),
          )));
  }// ITEM FILME
}// CLASSE
