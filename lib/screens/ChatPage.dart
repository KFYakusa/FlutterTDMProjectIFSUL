import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tdm_movies_crud/screens/ChatTextInput.dart';

class ChatPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>{

  void _sendMessage({String? text, File? imgFile}) async{
    Map<String, dynamic> data ={};
    if(imgFile != null){
       String url;
       url = await FirebaseStorage.instance.ref().child("imgs").child(DateTime.now().millisecondsSinceEpoch.toString()).putFile(imgFile).then((retorno) => retorno.ref.getDownloadURL());

       data['url'] = url;
    }
    if(text!= null)
        data['text'] = text;
    FirebaseFirestore.instance.collection("messages").add(data);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return GestureDetector(
      onVerticalDragUpdate: (details){},
      onHorizontalDragUpdate: (details){
        int sensitivity = 0;
        // debugPrint("ta entrando no GestureDetector");
        if(details.delta.direction <= sensitivity){

          Navigator.pop(context);
        }else if(details.delta.direction> sensitivity ){

        }
      },
      child: Scaffold(
        // appBar: AppBar(title: Text("Movie's Chat")),
        body: Center(
          child:ChatTextInput(_sendMessage)
        )
      )
    );
  }

}