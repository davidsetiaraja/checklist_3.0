import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    home: Login(),

  ));
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus {
  notSignIn,
  signIn

}

class _LoginState extends State<Login> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String nik, password, nama_lengkap, handphone, email;
  final _key = new GlobalKey<FormState>();
  

  bool _secureText = true;

  showHide(){
    setState(() {
      _secureText = !_secureText;
    });
  }

  check(){
    final form = _key.currentState;
    if (form.validate()){
      form.save();
      login();
    }
  }

  login() async{
    final response = await http.post(Uri.parse("http://192.168.0.110/checklist/api/login.php"), 
        body: {"nik" : nik, "password" : password});
    final data = jsonDecode(response.body);
    int value = data ['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
         _loginStatus = LoginStatus.signIn;
        savePref(value);
      });
    print(pesan);
    } else {
    print(pesan);
  }
}

savePref(int value)async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  setState(() {
    preferences.setInt("value", value);
    preferences.commit();
  });
}  

var value; 
getPref()async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  setState(() {
    value = preferences.getInt("value");
    _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
  });
}

signOut() async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  setState(() {
    preferences.setInt("value", 0);
    _loginStatus = LoginStatus.notSignIn;
  });
}


 @override
  void initState() {

    super.initState();
    getPref();
  }



  @override
  Widget build(BuildContext context) {
      switch (_loginStatus) {
        case LoginStatus.notSignIn :
           return Scaffold(
      appBar: AppBar(
      title: Text("Aplikasi Checklist Kendaraan"),
      ),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
          TextFormField(
            validator: (e){
              if (e.isEmpty){
                return "Please insert NIK";
              }
            },
            onSaved: (e)=>nik = e,
            decoration: InputDecoration(labelText: "NIK"),
          ),
          TextFormField(
            obscureText: _secureText,
            onSaved: (e)=>password = e,
            decoration: InputDecoration(
            labelText: "Password",
            suffixIcon: IconButton(
              onPressed: showHide,
              icon: Icon(_secureText ? Icons.visibility_off : Icons.visibility),
             ),
            ),
          ),
          MaterialButton(
            onPressed: (){
               check();
            },
            child: Text("Login"),
          ),
          InkWell(
            onTap:(){
              Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Register()));
            },
            child: Text("Create a new account, in here", textAlign: TextAlign.center,),
          )
        ],
      ),
    ),
  );
          break;
        case LoginStatus.signIn:
       return MainMenu(signOut);
       break;
      }
     
 }
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String  nik, password, nama_lengkap, handphone, email;
  final _key = new GlobalKey<FormState>();
    bool _secureText = true;

  showHide(){
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      save();
    }
  }

save()async {
    final response = await http.post(Uri.parse("http://192.168.0.110/checklist/api/register.php"), 
    body:{
      "nik" : nik,
      "password" : password,
      "nama_lengkap" : nama_lengkap,
      "handphone" : handphone,
      "email" : email


    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value==1) {
      setState(() {
        Navigator.pop(context);
      });
    } else {
      print(pesan);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(),
    body: Form(
      key:  _key,
      child: ListView(
      padding: EdgeInsets.all(16.0),
      children: <Widget>[
        TextFormField(
            validator: (e){
              if (e.isEmpty){
                return "Please insert NIK";
              }
            },
            onSaved: (e)=>nik = e,
            decoration: InputDecoration(labelText: "NIK"),
          ),
                  TextFormField(
            obscureText: _secureText,
            onSaved: (e)=>password = e,
            decoration: InputDecoration(
            labelText: "Password",
            suffixIcon: IconButton(
              onPressed: showHide,
              icon: Icon(_secureText ? Icons.visibility_off : Icons.visibility),
             ),
            ),
          ),
        TextFormField(
            validator: (e){
              if (e.isEmpty){
                return "Please insert Full Name";
              }
            },
            onSaved: (e)=>nama_lengkap = e,
            decoration: InputDecoration(labelText: "Nama Lengkap"),
          ),
        TextFormField(
            validator: (e){
              if (e.isEmpty){
                return "Please insert Handphone";
              }
            },
            onSaved: (e)=>handphone = e,
            decoration: InputDecoration(labelText: "Handphone"),
          ),
          TextFormField(
            validator: (e){
              if (e.isEmpty){
                return "Please insert Email";
              }
            },
            onSaved: (e)=>email = e,
            decoration: InputDecoration(labelText: "Email"),
          ),
        MaterialButton(
          onPressed: (){
            check();
          },
          child: Text("Register"),
        )
      ],
    ),
    ),
  );
  }
}

class MainMenu extends StatefulWidget {
  final VoidCallback signOut;
  MainMenu(this.signOut);
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  signOut(){
    setState(() {
      widget.signOut();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    
      actions: <Widget>[
        IconButton(onPressed: (){
          signOut();
        },
 icon: Icon(Icons.lock_open),
        )
      ],
    ),
    body: Center(
      child: Text("Menu Utama"),
    ),
   );
  }
}
