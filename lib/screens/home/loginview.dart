import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_light/screens/home/createaccountview.dart';
import 'package:green_light/screens/shared/loading.dart';
import 'package:green_light/services/auth.dart';

class LoginView extends StatefulWidget {

  final Function? toggleView;
  const LoginView({Key? key, this.toggleView}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final AuthService _auth = AuthService();
  bool loading = false;


  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Color buttonColor = const Color(0xffABB2BA);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if ((_emailController.text.isNotEmpty) && (_passwordController.text.isNotEmpty)) {
      buttonColor = const Color(0xff80CA4C);
    } else {
      buttonColor = const Color(0xffABB2BA);
    }

    return loading ? const Loading() : Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            width: 390.w,
            height: 844.h,
            decoration: const BoxDecoration(
              color: Color(0xffF2F3F5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _buildGreenLight(),
                _buildEmail(_emailController),
                _buildPassword(_passwordController),
                _buildSignUp(),
                // Container(
                //   margin: EdgeInsets.only(top: 124.h, left: 20.w, right: 20.w),
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       shape: const RoundedRectangleBorder(
                //         borderRadius: BorderRadius.all(Radius.circular(10)),
                //       ),
                //       backgroundColor: buttonColor,
                //       minimumSize: Size(350.w, 60.h),
                //       elevation: 0,
                //     ),
                //     onPressed: () async {
                //       if (buttonColor == const Color(0xff80CA4C)) {
                //         setState(() {
                //           loading = true;
                //         });

                //         dynamic result = await _auth.signInWithEmailAndPassword(_emailController.text, _passwordController.text);
                //         if (result == null){
                //           setState(() {
                //             loading = false;
                //           });
                //         }
                        
                //         // Navigator.push(
                //         //   context,
                //         //   MaterialPageRoute(builder: (context) => const Home()),
                //         // );
                //       }
                //     },
                //     child: const Text(
                //       'Login',
                //       style: TextStyle(
                //         fontWeight: FontWeight.w600,
                //         fontSize: 18,
                //       ),
                //     ),
                //   ),
                // ),
                // const LoginButton(),
                _buildLoginButton(_emailController, _passwordController, _auth),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildGreenLight() {
  return Container(
    margin: EdgeInsets.only(top: 307.h, left: 21.w),
    alignment: Alignment.centerLeft,
    child: const Text(
      'Hello, We are GreenLight!',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Color(0xff141C17),
      ),
    ),
  );
}

Widget _buildEmail(TextEditingController emailController) {
  return Container(
    margin: EdgeInsets.only(top: 32.h),
    child: Column(
      children: <Widget>[
        _emailTitle(),
        _emailInput(emailController),
      ],
    ),
  );
}

Widget _emailTitle() {
  return Container(
    margin: EdgeInsets.only(left: 24.w),
    alignment: Alignment.centerLeft,
    child: const Text(
      'Email',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xff141C27),
      ),
    ),
  );
}

Widget _emailInput(TextEditingController emailController) {
  return Container(
    width: 342.w,
    height: 55.h,
    margin: EdgeInsets.only(top: 12.h),
    child: TextField(
      controller: emailController,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.person,
          size: 25,
        ),
        prefixIconColor: const Color(0xff8C939B),
        filled: true,
        fillColor: const Color(0xffFFFFFF),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none
        ),
        hintText: 'Please enter your Email',
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xff676767),
        ),
      ),
    ),
  );
}

Widget _buildPassword(TextEditingController passwordController) {
  return Container(
    margin: EdgeInsets.only(top: 28.h),
    child: Column(
      children: <Widget>[
        _passwordTitle(),
        _passwordInput(passwordController),
      ],
    ),
  );
}

Widget _passwordTitle() {
  return Container(
    margin: EdgeInsets.only(left: 24.w),
    alignment: Alignment.centerLeft,
    child: const Text(
      'Password',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xff141C27),
      ),
    ),
  );
}

Widget _passwordInput(TextEditingController passwordController) {
  return Container(
    width: 342.w,
    height: 55.h,
    margin: EdgeInsets.only(top: 12.h),
    child: TextField(
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.lock,
          size: 25,
        ),
        prefixIconColor: const Color(0xff8C939B),
        filled: true,
        fillColor: const Color(0xffFFFFFF),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none
        ),
        hintText: 'Please enter your Password',
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xff676767),
        ),
      ),
    ),
  );
}

Widget _buildSignUp() {
  return Container(
    // margin: EdgeInsets.only(top: 5.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _accountNone(),
        _signUp(),
      ],
    ),
  );
}

Widget _accountNone() {
  return Container(
    margin: EdgeInsets.only(right: 5.w),
    child: const Text(
      "Don't have an account?",
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xff999EA1),
      ),
    ),
  );
}

Widget _signUp() {
  return Container(
    margin: EdgeInsets.only(right: 18.w),
    child: Builder(
      builder: (context) {
        return TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateAccountView()),
            );
          },
          child: const Text(
            'Sign Up',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xff5DC86C),
            ),
          ),
        );
      }
    ),
  );
}

Widget _buildLoginButton(TextEditingController emailController, TextEditingController passwordController, AuthService _auth) {
  Color buttonColor = const Color(0xffABB2BA);
  if ((emailController.text.isNotEmpty) && (passwordController.text.isNotEmpty)) {
    buttonColor = const Color(0xff80CA4C);
  } else {
    buttonColor = const Color(0xffABB2BA);
  }
  return Builder(
    builder: (context) {
      return Container(
        margin: EdgeInsets.only(top: 124.h, left: 20.w, right: 20.w),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            backgroundColor: buttonColor,
            minimumSize: Size(350.w, 60.h),
            elevation: 0,
          ),
          onPressed: () async {
            // if (buttonColor == const Color(0xff80CA4C)) {
            

              dynamic result = await _auth.signInWithEmailAndPassword(emailController.text, passwordController.text);
              // debugPrint(emailController.text);
              // debugPrint(passwordController.text);

              if (result == null){
                debugPrint("unfound user");
              }

              
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const Home()),
              // );
            // }
          },
          child: const Text(
            'Login',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
      );
    },
  );
}