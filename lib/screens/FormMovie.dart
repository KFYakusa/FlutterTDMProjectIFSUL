

import 'package:flutter/material.dart';
import 'package:tdm_movies_crud/database/filme_dao.dart';
import 'package:tdm_movies_crud/models/Filme.dart';

class FormMovie extends StatefulWidget{

  final Filme? movie;

  FormMovie([this.movie]);

  @override
  State<StatefulWidget> createState() {
    return _FormMovieState();
  }
}

class _FormMovieState extends State<FormMovie>{
final filmeDao _dao = new filmeDao();
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerAno = TextEditingController();
  final TextEditingController _controllerLink = TextEditingController();

  int? _id;
  final _movieFormKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    if(widget.movie != null){
      _id = widget.movie!.id;
      _controllerNome.text = widget.movie!.nome;
      _controllerAno.text = widget.movie!.ano;
      _controllerLink.text = widget.movie!.linkOnline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text(widget.movie != null ? "editar" : " novo filme"),
      ),
      body: Form(
        key: _movieFormKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _controllerNome,
              decoration: InputDecoration(
                icon: Icon(Icons.movie),
                hintText: "NOme do filme",
                labelText: "Nome do filme",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue ),
                )
              ),
              validator: (value){
                if(value==null || value.isEmpty){
                  return "enter some text";
                }else if(value.contains('@')){
                  return "não pode ter '@' no nome do filme";
                }
                return null;
              },
            ),
            TextFormField(
              controller: _controllerAno,
              decoration:InputDecoration(
                icon:Icon(Icons.event),
                hintText: "ano do filme",
                labelText: "Ano de lançamento",
                enabledBorder: UnderlineInputBorder(
                  borderSide:BorderSide(color:Colors.blue),
                )
              ),
              validator: (value){
                final regex = new RegExp(r'^[0-9]+$');
                if(value==null || value.isEmpty){
                  return "enter some year";
                }else if(!regex.hasMatch(value)){
                  return "Apenas números permitidos no ano do filme";
                }
                return null;
              },
            ),
            TextFormField(
              controller: _controllerLink,
              decoration:InputDecoration(
                  icon:Icon(Icons.link),
                  hintText: "add um link pra poder acessar fácil",
                  labelText: "Link de onde encontrar",
                  enabledBorder: UnderlineInputBorder(
                    borderSide:BorderSide(color:Colors.blue),
                  )
              ),
              validator: (value){
                if(value==null || value.isEmpty){
                  return "enter some text";
                }
                return null;
              },
            ),
            Center(
              child:ElevatedButton(
                onPressed: (){
                  if(_movieFormKey.currentState!.validate()){
                    if(_id != null)
                      _updateFilme(context);
                    else
                      _criarFilme(context);

                  }
                },child:Text("confirmar"),
              )
            )
          ],
        )
      )
    );
  } // @override Build Function

  void _criarFilme(BuildContext context){
    final _filmeNovo = new Filme(0, _controllerNome.text, _controllerAno.text, _controllerLink.text);
    _dao.save(_filmeNovo).then((id)=>Navigator.pop(context));
  }

  void _updateFilme(BuildContext context){
    final _filmeEdited = new Filme(_id!, _controllerNome.text, _controllerAno.text, _controllerLink.text);
    _dao.update(_filmeEdited).then((id)=>Navigator.pop(context));
  }

}