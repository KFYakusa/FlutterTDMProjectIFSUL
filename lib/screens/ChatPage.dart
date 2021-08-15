import 'package:flutter/material.dart';
import 'package:tdm_movies_crud/screens/ChatTextInput.dart';
import 'package:tdm_movies_crud/screens/HomePage.dart';

class ChatPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>{


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
          child:ChatTextInput()
        )
      )
    );
  }

}