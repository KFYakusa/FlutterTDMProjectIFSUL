import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tdm_movies_crud/screens/LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FilmesApp());
  // FirebaseFirestore.instance.collection("filmes").add({"nome":"Assassin's Creed", "ano":"2016", "link":"https://www.imdb.com/title/tt2094766/"});
  debugPrint("teste");
  // QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("filmes").get();
  // snapshot.docs.forEach((element) {
  //   print(element.data().toString());
  //   FirebaseFirestore.instance.collection("filmes").doc(element.id).delete();
  // });
}



class FilmesApp extends StatefulWidget {
  FilmesApp({Key? key}): super(key:key);
  @override
  State<StatefulWidget> createState()=>_FilmesAppState();
}

class _FilmesAppState extends State<FilmesApp>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: LoginPage(),
    );
  }

}

