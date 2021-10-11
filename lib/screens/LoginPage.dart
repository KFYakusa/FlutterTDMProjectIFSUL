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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController = TextEditingController();
  final GoogleSignIn ggleSign = GoogleSignIn();
  final _auth = FirebaseAuth.instance;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  // User? _currentUser;

  Future<User?> _singInEmail(BuildContext context) async{
    try{
      UserCredential userCred =  await _auth.signInWithEmailAndPassword(email: _emailEditingController.text, password: _passwordEditingController.text);
      return userCred.user;
    } on FirebaseAuthException catch(e){
      if(e.code == "user-not-found"){
        return _signUpEmail(context);
      }else if (e.code =="wrong-password"){
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text('Senha errada')));
        return null;
      }else{
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text('Algo de errado ocorreu')));
        return null;
      }
    }catch(e){
      print(e);
    }
  }

  Future <User?> _signUpEmail(BuildContext context) async{
    try{
      UserCredential userCred =  await _auth.createUserWithEmailAndPassword(email: _emailEditingController.text, password: _passwordEditingController.text);
      return userCred.user;
    } on FirebaseAuthException catch(e){
      if(e.code =="weak-password"){
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text('Senha Fraca')));
        return null;
      }else if(e.code=="email-already-in-use"){
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text('Email já está em uso')));
        return null;
      }else{
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text('Algo de errado ocorreu aqui!')));
        return null;
      }
    }catch(e){
      print(e);
    }
  }

  Future<User?> _getUserGoogle() async{
    ggleSign.signOut();
    return ggleSign.signIn()
        .then((googleSignInAccount) => googleSignInAccount!.authentication)
        .then((auth) =>GoogleAuthProvider.credential(idToken: auth.idToken, accessToken: auth.accessToken) )
        .then((credential)=>FirebaseAuth.instance.signInWithCredential(credential))
        .then((authResult){
      print("User: "+ authResult.user!.displayName!);
      return authResult.user;
    }).catchError((error){
      debugPrint("entering error");
      debugPrint(error.toString());
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
                    Text("Who are you?",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                    Column(
                      children: [
                        Padding(padding: const EdgeInsets.only(left:20,right:20),
                            child: MaterialButton(color: Colors.teal[100],
                              elevation: 10,
                              child: Row(mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.email, color: Theme.of(context).backgroundColor,),
                                  SizedBox(width:20),
                                  Text("Sign In with Email", style: TextStyle(
                                      color: Theme.of(context).backgroundColor
                                  ))
                                ],),
                              onPressed: (){
                                _showEmailDialog(context);
                              },
                            )
                        ),
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
                                      Text("Sign In with Google",style: TextStyle(
                                          color: Theme.of(context).backgroundColor
                                      ))]),
                                onPressed: (){
                                  _getUserGoogle().then((userRetorno){
                                    if(userRetorno != null){
                                      // _currentUser = userRetorno;
                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage(user: userRetorno, ggleSign: ggleSign)));
                                    }
                                  }).catchError((onError)=>debugPrint(onError));
                                }
                            )
                        ),
                      ],
                    )

                  ]
              ))));
  }

  Future<void> _showEmailDialog(BuildContext context) async{
    bool obscure = true;
    return await showDialog(context: context, builder: (context){
      return StatefulBuilder(builder: (context,setState){
        return AlertDialog(
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children:[
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 20.0,
                  ),
                  child: TextFormField(
                    controller: _emailEditingController,
                    validator: (value){
                      return (value != null && value.isNotEmpty) ? null : "email não pode ser nullo";
                    },
                    decoration: InputDecoration(hintText: "Enter Email"),
                    ),

                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom:20.0
                  ),
                  child:TextFormField(
                    controller: _passwordEditingController,
                    obscureText: obscure,
                    validator: (value){
                      return (value != null && value.length > 0) ? null : "senha precisa ter 6 digitos";
                    },
                    decoration: InputDecoration(hintText: "Enter Password",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.visibility, color: Colors.white),
                          onPressed: (){
                            setState((){
                              obscure = !obscure;
                            });
                          },

                        )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom:20.0),
                  child: ElevatedButton(
                    // style: ButtonStyle(
                    //   backgroundColor:
                    // ),
                    onPressed: (){
                      if(_formKey.currentState!.validate()){
                        _singInEmail(context).then((us) {
                          if(us!= null)
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage(user: us)));
                        });

                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 60.0
                      ),
                      child: Text("submit")
                    )
                  )
                )

              ]
            )
          ),
        );
      });
    });
  }


}