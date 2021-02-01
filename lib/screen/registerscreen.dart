import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uber/main.dart';
import 'package:uber/screen/homescreen.dart';
import 'package:uber/screen/loginscreen.dart';

import '../progressbar.dart';

class RegisterScreen extends StatelessWidget {
  static const String id = 'register';
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();

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
              Text('Register as a Rider',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30.0),),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.text ,
                      decoration: InputDecoration(
                        hintText: 'Name',
                        hintStyle: TextStyle(color: Colors.grey,fontSize: 15.0),
                        labelStyle: TextStyle(fontSize: 14.0),
                      ),
                    ),
                    SizedBox(height: 10,),
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
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone ,
                      decoration: InputDecoration(
                        hintText: 'Phone',
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
                        if(nameTextEditingController.text.length <3){
                          displayerrormsg('name must be at least 3 character', context);
                        }
                        else if(!emailTextEditingController.text.contains('@')){
                          displayerrormsg('email is not valid', context);
                        }
                        else if(phoneTextEditingController.text.isEmpty){
                          displayerrormsg('phone number is required', context);
                        }
                        else if(passwordTextEditingController.text.length <6){
                          displayerrormsg('password must be at least 6 character', context);
                        }
                        else {
                          registerNewUser(context);
                        }
                      },
                      child: Container(
                        height: 50,
                        child: Center(child: Text('Create Account',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),)),
                      ),
                    )
                  ],
                ),
              ),
              FlatButton(onPressed: (){
                Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (route) => false);

              },
                  child:Text('Already have an account? Login Here')
              )
            ],
          ),
        ),
      ),
    );
  }
  final FirebaseAuth auth = FirebaseAuth.instance ;
  void registerNewUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return ProgressBar(message: 'Registering , please wait...',);
        }

    );
    final User firebaseUser = (await auth
        .createUserWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text).catchError((errmsg){
      Navigator.pop(context);
      displayerrormsg('Error: '+errmsg, context);
    })).user;
    if (firebaseUser != null) {
        //success register
      Map userDataMap = {
        'name' : nameTextEditingController.text.trim(),
        'email' : emailTextEditingController.text.trim(),
        'phone' : phoneTextEditingController.text.trim()
      };
      
      userRef.child(firebaseUser.uid).set(userDataMap);
      displayerrormsg('account has been created', context);
      Navigator.pushNamedAndRemoveUntil(context, HomeScreen.id, (route) => false);
    }
    else{
      Navigator.pop(context);
      // error
      displayerrormsg('new user account has not been created', context);
    }
  }
}
displayerrormsg(String message,BuildContext context){
  Fluttertoast.showToast(msg: message);
}