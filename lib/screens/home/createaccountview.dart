import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_light/screens/home/loginview.dart';
import 'package:green_light/screens/wrapper.dart';
import 'package:green_light/services/auth.dart';


class CreateAccountView extends StatefulWidget {
  final Function? toggleView;
  const CreateAccountView({Key? key, this.toggleView}) : super(key: key);

  @override
  State<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _yearController = TextEditingController();
  final _monthController = TextEditingController();
  final _dateController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  final AuthService _auth = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _yearController.dispose();
    _monthController.dispose();
    _dateController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        leading: Container(
          margin: EdgeInsets.only(left: 20.w),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: const Color(0xffC3C8CE),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: const Color(0xffF2F3F5),
        title: Container(
          margin: EdgeInsets.only(left: 5.w),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Create an account',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
              color: Color(0xff141C27),
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            width: 390.w,
            height: 750.h,
            decoration: const BoxDecoration(
              color: Color(0xffF2F3F5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildEmail(_emailController),
                _buildPassword(_passwordController),
                _buildUsername(_usernameController),
                _buildBirth(_yearController, _monthController, _dateController),
                _buildHeightWeight(_heightController, _weightController),
                _buildSignUpButton(
                  _emailController, _passwordController, _usernameController,
                  _yearController, _monthController, _dateController,
                  _heightController, _weightController, _auth,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
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
    margin: EdgeInsets.only(top: 20.h),
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

Widget _buildUsername(TextEditingController usernameController) {
  return Container(
    margin: EdgeInsets.only(top: 58.h),
    child: Column(
      children: <Widget>[
        _usernameTitle(),
        _usernameInput(usernameController),
      ],
    ),
  );
}

Widget _usernameTitle() {
  return Container(
    margin: EdgeInsets.only(left: 24.w),
    alignment: Alignment.centerLeft,
    child: const Text(
      'User name',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xff141C27),
      ),
    ),
  );
}

Widget _usernameInput(TextEditingController usernameController) {
  return Container(
    width: 342.w,
    height: 55.h,
    margin: EdgeInsets.only(top: 12.h),
    child: TextField(
      controller: usernameController,
      decoration: InputDecoration(
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
        hintText: 'Please enter your User name',
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xff676767),
        ),
      ),
    ),
  );
}

Widget _buildBirth(TextEditingController yearController,
    TextEditingController monthController, TextEditingController dataController) {
  return Container(
    margin: EdgeInsets.only(top: 20.h),
    child: Column(
      children: <Widget>[
        _birthTitle(),
        _birthInput(yearController, monthController, dataController),
      ],
    ),
  );
}

Widget _birthTitle() {
  return Container(
    margin: EdgeInsets.only(left: 24.w),
    alignment: Alignment.centerLeft,
    child: const Text(
      'Date of birth',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xff141C27),
      ),
    ),
  );
}

Widget _birthInput(TextEditingController yearController,
    TextEditingController monthController, TextEditingController dateController) {
  return Container(
    margin: EdgeInsets.only(top: 16.h),
    child: Row(
      children: <Widget>[
        _yearInput(yearController),
        _monthInput(monthController),
        _dateInput(dateController),
      ],
    ),
  );
}

Widget _yearInput(TextEditingController yearController) {
  return Container(
    width: 130.w,
    height: 55.h,
    margin: EdgeInsets.only(left: 24.w),
    child: TextField(
      controller: yearController,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
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
        hintText: 'YYYY',
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xff676767),
        ),
      ),
    ),
  );
}

Widget _monthInput(TextEditingController monthController) {
  return Container(
    width: 70.w,
    height: 55.h,
    margin: EdgeInsets.only(left: 56.w),
    child: TextField(
      controller: monthController,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
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
        hintText: 'MM',
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xff676767),
        ),
      ),
    ),
  );
}

Widget _dateInput(TextEditingController dateController) {
  return Container(
    width: 70.w,
    height: 55.h,
    margin: EdgeInsets.only(left: 16.w),
    child: TextField(
      controller: dateController,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
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
        hintText: 'DD',
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xff676767),
        ),
      ),
    ),
  );
}

Widget _buildHeightWeight(TextEditingController heightController, TextEditingController weightController) {
  return Container(
    margin: EdgeInsets.only(top: 20.h),
    child: Column(
      children: <Widget>[
        _heightWeightTitle(),
        _heightWeightInput(heightController, weightController),
      ],
    ),
  );
}

Widget _heightWeightTitle() {
  return Container(
    margin: EdgeInsets.only(left: 24.w),
    alignment: Alignment.centerLeft,
    child: const Text(
      'Height & Weight',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xff141C27),
      ),
    ),
  );
}

Widget _heightWeightInput(TextEditingController heightController, TextEditingController weightController) {
  return Container(
    margin: EdgeInsets.only(top: 12.h),
    child: Row(
      children: <Widget>[
        _heightInput(heightController),
        _heightUnit(),
        _weightInput(weightController),
        _weightUnit(),
      ],
    ),
  );
}

Widget _heightInput(TextEditingController heightController) {
  return Container(
    width: 70.w,
    height: 55.h,
    margin: EdgeInsets.only(left: 24.w),
    child: TextField(
      controller: heightController,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
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
        hintText: '170',
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xffBABABA),
        ),
      ),
    ),
  );
}

Widget _heightUnit() {
  return Container(
    margin: EdgeInsets.only(left: 8.w),
    child: const Text(
      'cm',
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: Color(0xff676767),
      ),
    ),
  );
}

Widget _weightInput(TextEditingController weightController) {
  return Container(
    width: 70.w,
    height: 55.h,
    margin: EdgeInsets.only(left: 88.w),
    child: TextField(
      controller: weightController,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
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
        hintText: '60',
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xffBABABA),
        ),
      ),
    ),
  );
}

Widget _weightUnit() {
  return Container(
    margin: EdgeInsets.only(left: 8.w),
    child: const Text(
      'kg',
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: Color(0xff676767),
      ),
    ),
  );
}

Widget _buildSignUpButton(TextEditingController emailController,
    TextEditingController passwordController, TextEditingController usernameController,
    TextEditingController yearController, TextEditingController monthController,
    TextEditingController dateController, TextEditingController heightController,
    TextEditingController weightController, AuthService _auth,
    ) {
  Color buttonColor = const Color(0xffABB2BA);
  if ((emailController.text.isNotEmpty) && (passwordController.text.isNotEmpty)
      && (usernameController.text.isNotEmpty) && (yearController.text.isNotEmpty)
      && (monthController.text.isNotEmpty) && (dateController.text.isNotEmpty)
      && (heightController.text.isNotEmpty) && (weightController.text.isNotEmpty)) {
    buttonColor = const Color(0xff80CA4C);
  } else {
    buttonColor = const Color(0xffABB2BA);
  }
  return Builder(
    builder: (context) {
      return Container(
        margin: EdgeInsets.only(top: 53.h, left: 20.w, right: 20.w),
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
            if (buttonColor == const Color(0xff80CA4C)) {

              dynamic result = await _auth.registerWithEmailAndPassword(
                emailController.text, 
                passwordController.text,
                usernameController.text,
                yearController.text,
                monthController.text,
                dateController.text,
                heightController.text,
                weightController.text,
                );
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const Wrapper()),
              // );
            }
          },
          child: const Text(
            'Sign Up',
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

// Widget _buildSignUpButton(TextEditingController emailController,
//     TextEditingController passwordController, TextEditingController usernameController,
//     TextEditingController yearController, TextEditingController monthController,
//     TextEditingController dateController, TextEditingController heightController,
//     TextEditingController weightController,
//     ) {
//   Color buttonColor = const Color(0xffABB2BA);
//   if ((emailController.text.isNotEmpty) && (passwordController.text.isNotEmpty)
//       && (usernameController.text.isNotEmpty) && (yearController.text.isNotEmpty)
//       && (monthController.text.isNotEmpty) && (dateController.text.isNotEmpty)
//       && (heightController.text.isNotEmpty) && (weightController.text.isNotEmpty)) {
//     buttonColor = const Color(0xff80CA4C);
//   } else {
//     buttonColor = const Color(0xffABB2BA);
//   }
//   return Builder(
//     builder: (context) {
//       return Container(
//         margin: EdgeInsets.only(top: 53.h, left: 20.w, right: 20.w),
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10)),
//             ),
//             backgroundColor: buttonColor,
//             minimumSize: Size(350.w, 60.h),
//             elevation: 0,
//           ),
//           onPressed: () {
//             if (buttonColor == const Color(0xff80CA4C)) {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const LoginView()),
//               );
//             }
//           },
//           child: const Text(
//             'Sign Up',
//             style: TextStyle(
//               fontWeight: FontWeight.w600,
//               fontSize: 18,
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }