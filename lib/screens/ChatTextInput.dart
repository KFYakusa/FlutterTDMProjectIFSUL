import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatTextInput extends StatefulWidget{
  final Function({ String text, File imgFile}) sendMessage;
  ChatTextInput(this.sendMessage);

  @override
  State<StatefulWidget> createState() => _ChatTextInputState();
}

class _ChatTextInputState extends State<ChatTextInput>{
  final _textController = TextEditingController();
  bool _isWriting = false;
  final picker = ImagePicker();

  void _reset(){
    _textController.clear();
    setState(() {
      _isWriting =false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child:Row(
          children: <Widget>[
            Container(
              child: IconButton(icon: Icon(Icons.photo_camera,color: Theme.of(context).backgroundColor),
              onPressed:() async {
                final img = await picker.pickImage(source: ImageSource.camera);
                if(img== null)
                  return;
                final imgFile = File(img.path);
                widget.sendMessage(imgFile : imgFile);
              })
            ),
            Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration.collapsed(hintText: "Digite uma Mensagem"),
                  onChanged: (text)=> setState(()=>_isWriting=text.length>0),
                  onSubmitted: (text){
                    widget.sendMessage(text : text);
                    print(text);
                    _reset();
                  },
                )
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                color: Theme.of(context).buttonColor,
                icon: Icon(Icons.send),
                onPressed: _isWriting? () {
                  widget.sendMessage(text: _textController.text);
                  print(_textController.text);
                  _reset();
                } : null,
              )
            )
          ],
        )
      )
    );

  }


}