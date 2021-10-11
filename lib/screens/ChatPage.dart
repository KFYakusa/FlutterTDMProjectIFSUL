import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:tdm_movies_crud/screens/ChatTextInput.dart';

class ChatPage extends StatefulWidget {
  User? _user;
  ChatPage({required User user}) {
    this._user = user;
  }

  @override
  State<StatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  void _sendMessage({String? text, File? imgFile}) async {
    Map<String, dynamic> data = {
      "uid": widget._user!.uid,
      "senderName": widget._user?.displayName,
      'senderPhotoURL': widget._user?.photoURL,
      "time": Timestamp.now(),
    };

    if (imgFile != null) {
      String url;
      url = await FirebaseStorage.instance
          .ref()
          .child("imgs")
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(imgFile)
          .then((retorno) => retorno.ref.getDownloadURL()).catchError((onError){
            debugPrint("error inside downloadURL");
            print(onError);
      });
      data['url'] = url;
    }
    if (text != null) data['text'] = text;
    FirebaseFirestore.instance.collection("messages").add(data);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return GestureDetector(
        onVerticalDragUpdate: (details) {},
        onHorizontalDragUpdate: (details) {
          int sensitivity = 0;
          // debugPrint("ta entrando no GestureDetector");
          if (details.delta.direction <= sensitivity) {
            Navigator.pop(context);
          } else if (details.delta.direction > sensitivity) {}
        },
        child: Scaffold(
            // appBar: AppBar(title: Text("Movie's Chat")),
            body: Center(
                child: Column(children: <Widget>[
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("messages")
                      .orderBy("time")
                      .snapshots(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(
                            child: Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      CircularProgressIndicator(
                                        strokeWidth: 5,
                                        backgroundColor:
                                            Theme.of(context).backgroundColor,
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                                Colors.green),
                                      )
                                    ])));
                      default:
                        List<DocumentSnapshot> documents =
                            snapshot.data!.docs.reversed.toList();
                        return ListTileTheme(
                            // tileColor: Colors.green,
                            style: ListTileStyle.list,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 15),
                            horizontalTitleGap: 5,
                            child: Container(
                                // padding: EdgeInsets.only(right: 80),
                                child: ListView.builder(
                                    itemCount: documents.length,
                                    reverse: true,
                                    itemBuilder: (context, index) {
                                      return Card(
                                          margin: EdgeInsets.only(top:3,
                                              right:documents[index].get("uid") == widget._user!.uid ? 0 : 70,
                                              left: documents[index].get("uid") == widget._user!.uid ? 70 : 0 ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15.0),
                                          ),
                                          color: documents[index].get("uid") == widget._user!.uid ? Colors.green : Colors.white54,
                                          child: ListTile(
                                            contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 15),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            dense: true,
                                            onLongPress: () {
                                              _showConfirmDialog(
                                                  documents[index]);
                                            },
                                            leading: index + 1 < documents.length && documents[index + 1].get("uid") == documents[index].get("uid")
                                                ? null
                                                : Container(height: 30.0, width: 30.0,
                                                    decoration: documents[index].get("senderPhotoURL") != null
                                                        ? BoxDecoration(
                                                        image: DecorationImage(
                                                            image: NetworkImage(documents[index].get("senderPhotoURL")),
                                                            fit: BoxFit.cover),
                                                            shape: BoxShape.circle)
                                                        : BoxDecoration(
                                                            image: DecorationImage(
                                                                image: AssetImage('assets/imgs/profileUserImage.png'),
                                                                fit: BoxFit.cover),
                                                            shape: BoxShape.circle),
                                                        ),
                                            title: documents[index].exists && documents[index].get("text") ? Image.network(documents[index].get("url")) : Text(documents[index].get("text") ),
                                            trailing: Text(DateFormat('HH:mm:ss').format((documents[index].get("time") as Timestamp).toDate())),
                                          ));
                                    })));
                    } // switch connections
                  })),
          ChatTextInput(_sendMessage)
        ]))));
  }

  Future<void> _showConfirmDialog(DocumentSnapshot<Object?> mensagem) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Gostaria de Deletar msg?'),
          actions: <Widget>[
            TextButton(
              child: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Icon(Icons.delete_forever, color: Colors.red),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection("messages")
                    .doc(mensagem.id)
                    .delete();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
