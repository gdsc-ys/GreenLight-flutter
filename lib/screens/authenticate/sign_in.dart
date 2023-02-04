import 'package:flutter/material.dart';
import 'package:green_light/screens/shared/loading.dart';
import 'package:green_light/services/auth.dart';


class SignIn extends StatefulWidget {

  final Function? toggleView;
  const SignIn({super.key, this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

@override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightGreenAccent[400],
        elevation: 0.0,
        title: Text('Sign in to the App'),
        actions: <Widget>[
          TextButton.icon(
            onPressed: () {
              widget.toggleView!();
            },
            icon: Icon(Icons.person, color: Colors.white,), 
            label: Text('Register', style: TextStyle(color: Colors.white),)
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0,),
              TextFormField(
                validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                },
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                obscureText: true,
                validator: (val) => val!.length < 6 ? 'Enter a password more than 5 letters' : null,
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
              ),
              SizedBox(height: 20.0,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.greenAccent[400],
                ),
                child: Text(
                  'Sign in',
                  style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()){
                      setState(() {
                        loading = true;
                      });

                      dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                      if (result == null){
                        setState(() {
                          loading = false;
                          error = 'could not sign in with those credentials';
                        });
                      }
                    }
                  },
              ),
              SizedBox(height: 12.0,),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ],
          ),
          )
      ),
    );
  }
}