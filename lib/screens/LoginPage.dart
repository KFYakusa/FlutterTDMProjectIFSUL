import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tdm_movies_crud/screens/HomePage.dart';

class LoginPage extends StatefulWidget{


  @override
  State<StatefulWidget> createState() =>_LoginPageState();
}

class _LoginPageState extends State<LoginPage>{

  final  GoogleSignIn ggleSign = GoogleSignIn();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // User? _currentUser;

  Future<User?> _getUser() async{

    return ggleSign.signIn()
        .then((googleSignInAccount) => googleSignInAccount!.authentication)
        .then((auth) => GoogleAuthProvider
        .credential(idToken: auth.idToken, accessToken: auth.accessToken))
        .then((credential)=>FirebaseAuth.instance.signInWithCredential(credential))
        .then((authResult){
      print("User: "+ authResult.user!.displayName!);
      return authResult.user;
    }).catchError((error){
      debugPrint(error);
      return null;
    }) ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
          gradient: LinearGradient(
          colors: [
            Colors.blue,
            Colors.red,
          ],),),
          child: Card(
              margin: EdgeInsets.only(top: 200, bottom: 200, left: 30, right: 30),
              elevation: 20,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Sing in With Google",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                    Padding(padding: const EdgeInsets.only(left: 20, right: 20),
                      child: MaterialButton(color: Colors.teal[100],
                        elevation: 10,
                        child: Row(mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(height: 30.0,width: 30.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:AssetImage('assets/imgs/google-512x512.png'),
                                  fit: BoxFit.cover),
                            shape: BoxShape.circle),
                          ),
                          SizedBox(width: 20),
                          Text("Sign In with Google")]),
                      onPressed: (){
                        _getUser().then((userRetorno){

                          if(userRetorno != null){
                            // _currentUser = userRetorno;
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage(user: userRetorno, ggleSign: ggleSign)));
                          }
                        }).catchError((onError)=>debugPrint("error"));
                      }))]))));
  }

}