import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uber/main.dart';
import 'package:uber/progressbar.dart';
import 'package:uber/screen/registerscreen.dart';

import 'homescreen.dart';

class LoginScreen extends StatelessWidget {
  static const String id = 'login';

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40,),
              Image.asset('images/taxi2.png' , width: 250,height: 250,),
              Text('Login as a Rider',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30.0),),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress ,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.grey,fontSize: 15.0),
                        labelStyle: TextStyle(fontSize: 14.0),
                      ),
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.grey,fontSize: 15.0),
                        labelStyle: TextStyle(fontSize: 14.0),
                      ),
                    ),
                    SizedBox(height: 20,),
                    RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      color: Colors.yellow,
                        textColor: Colors.white,
                        onPressed: (){
                          if(!emailTextEditingController.text.contains('@')){
                            displayerrormsg('email is not valid', context);
                          }
                          else if(passwordTextEditingController.text.isEmpty){
                            displayerrormsg('error password', context);
                          }
                          else{
                            print('user');
                            loginUser(context);
                          }
                        },
                      child: Container(
                        height: 50,
                        child: Center(child: Text('Login',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),)),
                      ),
                    )
                  ],
                ),
              ),
              FlatButton(onPressed: (){
                Navigator.pushNamedAndRemoveUntil(context, RegisterScreen.id, (route) => false);
              },
                  child:Text('don\'t have an account? Register Here')
              )
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth auth = FirebaseAuth.instance ;

  void loginUser(BuildContext context) async{

    showDialog(
        context: context,
          barrierDismissible: false,
      builder: (BuildContext context){
          return ProgressBar(message: 'Authenticating , please wait...',);
      }

    );
    final User firebaseUser = (await auth
            .signInWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text).catchError((errmsg){
          Navigator.pop(context);
      displayerrormsg('Error: '+errmsg, context);
    })).user;
    if (firebaseUser != null) {
      //compare user account to database
      userRef.child(firebaseUser.uid).once().then((value) => (DataSnapshot snap){
        if(snap.value !=null){
          Navigator.pushNamedAndRemoveUntil(context, HomeScreen.id, (route) => false);
          displayerrormsg('you successfully login', context);
        }
        else{
          Navigator.pop(context);
          auth.signOut();
          displayerrormsg('account not exist ', context);
        }
      });

    }
    else{
      Navigator.pop(context);
      displayerrormsg('Error : can not be logged-in', context);
    }
  }

}

