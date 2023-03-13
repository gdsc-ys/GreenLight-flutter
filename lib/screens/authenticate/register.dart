import 'package:flutter/material.dart';
import 'package:green_light/screens/shared/loading.dart';
import 'package:green_light/services/auth.dart';

class Register extends StatefulWidget {

  final Function? toggleView;
  const Register({super.key, this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  // 폼 유효성 확인
  final _formKey = GlobalKey<FormState>();
  // 로딩 이미지 불러 올지에 대한 플래그
  bool loading = false;

  // 초기 데이터 null 설정도 괜찮음
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    // 로딩 이미지 불러야될 상황이면 부르고 아니면 준비된 화면 pop
    return loading ? const Loading() : Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightGreenAccent[400],
        elevation: 0.0,
        title: const Text('Sign up to the App'),
          actions: <Widget>[
            TextButton.icon(
              onPressed: () {
                widget.toggleView!();
              },
              icon: const Icon(Icons.person, color: Colors.white,), 
              label: const Text('Sign In', style: TextStyle(color: Colors.white),)
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
                  'Register',
                  style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()){
                      setState(() {
                        loading = true;
                      });
                      dynamic result = await _auth.registerWithEmailAndPassword(email, password);

                      if (result == null){
                        setState(() {
                          loading = false;
                          error = 'please supply a valid email';
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