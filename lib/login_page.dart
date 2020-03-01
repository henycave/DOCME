
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'list_users.dart';

class LoginPage extends StatefulWidget {


  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType{
  login,
  Register
}

  class _LoginPageState extends State<LoginPage>{

  final formKey = new GlobalKey<FormState>();
  final db = Firestore.instance;

  String _fName;
  String _lName;
  String _userName;
  String _mobile;
  String _gender;
  String _email;
  String _password;
  FormType _formType = FormType.login;

  bool validateAndSave(){
    final form = formKey.currentState;
    form.save();
    if(form.validate())
      return true;

      return false;
  }

  void validateAndSubmit() async{
    if(validateAndSave()) {
      try {
        if (_formType == FormType.login){

          AuthResult result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
        print('signed in : ${result.user.uid}');
          if (result.user.uid != null) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ListPage()),
            );
      }
        }
        else{
          AuthResult result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
          //print('registerd user: ${user.uid}');
            await db.collection("users").document(_email).setData({'Fname': _fName, 'Lname': _lName, 'user name': _userName,'mobile': _mobile,'Gender': _gender});
          print('registrerd user: ${result.user.uid}');
          if (result.user.uid != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListPage()),
            );
          }
          else{

          }


        }
    }
      catch(e){
        print('Error: $e');
      }
    }
  }

  void moveToRegister(){
    formKey.currentState.reset();
    setState(() {
        _formType = FormType.Register;
    });

  }

  void moveToLogin(){
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //backgroundColor: Color(0xFFDF8E33),

      //resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        backgroundColor: Color.fromRGBO(0,128,0,0.8),
        title: _title(),
      ),
        body: new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(image: new AssetImage("assets/images/go.jpg"), fit: BoxFit.cover,),
          ),
          padding: EdgeInsets.all(16.0),
          child: new Form(
            key: formKey,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:
              buildInputs()+buildSubmitButton(),
            ),),
        ),
    );
  }

  List<Widget> buildInputs(){
    if(_formType == FormType.login) {
      return [
        new TextFormField(
          decoration: new InputDecoration(labelText: 'Email', labelStyle: new TextStyle(fontSize: 20.0, color: Colors.white), ),
          validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
          onSaved: (value) => _email = value,
          style: new TextStyle(color: Colors.white),
        ),
        new TextFormField(
          decoration: new InputDecoration(labelText: 'password', labelStyle: new TextStyle(fontSize: 20.0, color: Colors.white),),
          obscureText: true,
          validator: (value) =>
          value.isEmpty
              ? 'password can\'t be empty'
              : null,
          onSaved: (value) => _password = value,
          style: new TextStyle(color: Colors.white),
        ),
      ];
    }
    else{
      return [
        new TextFormField(

          decoration: new InputDecoration(labelText: 'First name', labelStyle: new TextStyle(fontSize: 20.0, color: Colors.white),),
          validator: (value) => value.isEmpty ? 'first name can\'t be empty' : null,
          onSaved: (value) => _fName = value,
          style: new TextStyle(color: Colors.white),

        ),
        new TextFormField(
          decoration: new InputDecoration(labelText: 'Last name', labelStyle: new TextStyle(fontSize: 20.0, color: Colors.white),),
          validator: (value) => value.isEmpty ? 'last name can\'t be empty' : null,
          onSaved: (value) => _lName = value,
          style: new TextStyle(color: Colors.white),
        ),
        new TextFormField(
          decoration: new InputDecoration(labelText: 'user name', labelStyle: new TextStyle(fontSize: 20.0, color: Colors.white),),
          validator: (value) => value.isEmpty ? 'name can\'t be empty' : null,
          onSaved: (value) => _userName = value,
          style: new TextStyle(color: Colors.white),
        ),
        new TextFormField(
          decoration: new InputDecoration(labelText: 'Email', labelStyle: new TextStyle(fontSize: 20.0, color: Colors.white),),
          validator: (value) => value.isEmpty ? 'name can\'t be empty' : null,
          onSaved: (value) => _email = value,
          style: new TextStyle(color: Colors.white),
        ),
        new TextFormField(
          decoration: new InputDecoration(labelText: 'Phone number', labelStyle: new TextStyle(fontSize: 20.0, color: Colors.white),),
          validator: (value) => value.isEmpty ? 'name can\'t be empty' : null,
          onSaved: (value) => _mobile = value,
          style: new TextStyle(color: Colors.white),
        ),
        new TextFormField(
          decoration: new InputDecoration(labelText: 'Gender', labelStyle: new TextStyle(fontSize: 20.0, color: Colors.white),),
          validator: (value) => value.isEmpty ? 'name can\'t be empty' : null,
          onSaved: (value) => _gender = value,
          style: new TextStyle(color: Colors.white),
        ),
        new TextFormField(
          decoration: new InputDecoration(labelText: 'password', labelStyle: new TextStyle(fontSize: 20.0, color: Colors.white),),
          obscureText: true,
          validator: (value) => value.isEmpty ? 'password can\'t be empty' : null,
          onSaved: (value) => _password = value,
          style: new TextStyle(color: Colors.white),
        ),
      ];
    }
  }
  List<Widget> buildSubmitButton(){

    if(_formType == FormType.login) {
      return [
        new RaisedButton(
          child: new Text('Login', style: new TextStyle(fontSize: 20.0),),
          onPressed: validateAndSubmit,
        ),
        new FlatButton(
          child: new Text(
            'create an account', style: new TextStyle(fontSize: 20.0, color: Colors.white), ),
          onPressed: moveToRegister,
        )
      ];
    }
    else{
      return [
        new RaisedButton(
          child: new Text('create an account', style: new TextStyle(fontSize: 20.0),),
          onPressed: validateAndSubmit,
        ),
        new FlatButton(
          child: new Text(
            'already have an acount? Login', style: new TextStyle(fontSize: 20.0, color: Colors.white ),),
          onPressed: moveToLogin,
        )
      ];
    }
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'DO',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'C',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'ME',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }
}