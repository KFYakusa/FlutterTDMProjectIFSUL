import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tdm_movies_crud/database/filme_dao.dart';
import 'package:tdm_movies_crud/models/Filme.dart';
import 'package:tdm_movies_crud/screens/ChatPage.dart';
import 'package:tdm_movies_crud/screens/FormMovie.dart';
import 'package:tdm_movies_crud/screens/LoginPage.dart';

class HomePage extends StatefulWidget {
  User? _user;
  GoogleSignIn? _gglwIn;
  HomePage({Key? key, User? user, required GoogleSignIn ggleSign}): super(key: key){
    this._user = user;
    this._gglwIn = ggleSign;
  }


  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}


class _HomePageState extends State<HomePage> {
  final filmeDao _dao = new filmeDao();

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Gostaria de Sair?'),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Icon(Icons.exit_to_app, color:Colors.red),
              onPressed: (){
                FirebaseAuth.instance.signOut();
                widget._gglwIn!.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
              },
            )
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details){},
      onHorizontalDragUpdate: (details){
        int sensitivity =0;
        if(details.delta.direction> sensitivity){

          Navigator.of(context).push(
              PageRouteBuilder(
                transitionsBuilder: (context, animation,secondaryAnimation,child){
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  final tween =Tween(begin:begin,end:end);
                  final offsetAnimation = animation.drive(tween);
                  return SlideTransition(position: offsetAnimation, child:child);
                },
                  pageBuilder: (BuildContext context, Animation<double> animation, Animation <double> secondaryAnimation){
                    return ChatPage(user:widget._user!);
                }
              ));
        }
        else if(details.delta.direction < -sensitivity){

        }
      },
      child:Scaffold(
          appBar: AppBar(
            leading: widget._user != null ? TextButton(child: Container(height: 40.0,width: 40.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image:NetworkImage(widget._user!.photoURL!),
                      fit: BoxFit.cover),
                  shape: BoxShape.circle),
            ),
              onPressed:(){
                _showMyDialog();
              },
            ) : null,
              title: Center(child: Text("Lista de filmes")),
            actions: [
                TextButton(
                    child: Icon(Icons.chat,color: Theme.of(context).backgroundColor, ),
                    onPressed: (){
                      Navigator.of(context).push(
                          PageRouteBuilder(
                              transitionsBuilder: (context, animation,secondaryAnimation,child){
                                const begin = Offset(1.0, 0.0);
                                const end = Offset.zero;
                                final tween =Tween(begin:begin,end:end);
                                final offsetAnimation = animation.drive(tween);
                                return SlideTransition(position: offsetAnimation, child:child);
                              },
                              pageBuilder: (BuildContext context, Animation<double> animation, Animation <double> secondaryAnimation){
                                return ChatPage(user: widget._user!);
                              }
                          ));
                } ),

            ],
          ),

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
              tooltip: "add new movie",
              onPressed: () {
                final Future future =
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return FormMovie();
                }));
                future.then((movie) {
                  setState(() {});
                });})
      )
    );
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
