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
    return loading ? const Loading() : Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightGreenAccent[400],
        elevation: 0.0,
        title: const Text('Sign in to the App'),
        actions: <Widget>[
          TextButton.icon(
            onPressed: () {
              widget.toggleView!();
            },
            icon: const Icon(Icons.person, color: Colors.white,), 
            label: const Text('Register', style: TextStyle(color: Colors.white),)
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0,),
              TextFormField(
                validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                },
              ),
              const SizedBox(height: 20.0,),
              TextFormField(
                obscureText: true,
                validator: (val) => val!.length < 6 ? 'Enter a password more than 5 letters' : null,
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
              ),
              const SizedBox(height: 20.0,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent[400],
                ),
                child: const Text(
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
              const SizedBox(height: 12.0,),
              Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ],
          ),
          )
      ),
    );
  }
}