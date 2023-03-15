import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_light/screens/home/groupview.dart';

class CreateGroupView extends StatefulWidget {
  const CreateGroupView({Key? key}) : super(key: key);

  @override
  State<CreateGroupView> createState() => _CreateGroupViewState();
}

class _CreateGroupViewState extends State<CreateGroupView> {

  final _groupNameController = TextEditingController();
  final _capacityController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _groupNameController.dispose();
    _capacityController.dispose();
    _descriptionController.dispose();
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
            'Create a Group',
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
                _buildGroupName(_groupNameController),
                _buildCapacity(_capacityController),
                _buildDescription(_descriptionController),
                _buildCompletionButton(_groupNameController, _capacityController, _descriptionController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildGroupName(TextEditingController groupNameController) {
  return Container(
    margin: EdgeInsets.only(top: 30.h),
    child: Column(
      children: <Widget>[
        _groupNameTitle(),
        _groupNameInput(groupNameController),
      ],
    ),
  );
}

Widget _groupNameTitle() {
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

Widget _groupNameInput(TextEditingController groupNameController) {
  return Container(
    height: 55.h,
    margin: EdgeInsets.only(top: 12.h, left: 24.w, right: 24.w),
    child: TextField(
      controller: groupNameController,
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
        hintText: 'Pleae enter your Group name',
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xff676767),
        ),
      ),
    ),
  );
}

Widget _buildCapacity(TextEditingController capacityController) {
  return Container(
    margin: EdgeInsets.only(top: 20.h),
    child: Column(
      children: <Widget>[
        _capacityTitle(),
        _capacityInputs(capacityController),
      ],
    ),
  );
}

Widget _capacityTitle() {
  return Container(
    margin: EdgeInsets.only(left: 24.w),
    alignment: Alignment.centerLeft,
    child: const Text(
      'Maximum capacity',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xff141C27),
      ),
    ),
  );
}

Widget _capacityInputs(TextEditingController capacityController) {
  return Container(
    margin: EdgeInsets.only(top: 12.h),
    child: Row(
      children: <Widget>[
        _capacityInput(capacityController),
        _capacityUnit(),
      ],
    ),
  );
}

Widget _capacityInput(TextEditingController capacityController) {
  return Container(
    width: 70.w,
    height: 55.h,
    margin: EdgeInsets.only(left: 24.w),
    child: TextField(
      controller: capacityController,
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
        hintText: '7',
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xff676767),
        ),
      ),
    ),
  );
}

Widget _capacityUnit() {
  return Container(
    margin: EdgeInsets.only(left: 8.w),
    child: const Text(
      'people',
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: Color(0xff676767),
      ),
    ),
  );
}

Widget _buildDescription(TextEditingController descriptionController) {
  return Container(
    margin: EdgeInsets.only(top: 20.h),
    child: Column(
      children: <Widget>[
        _descriptionTitle(),
        _descriptionInput(descriptionController),
      ],
    ),
  );
}

Widget _descriptionTitle() {
  return Container(
    margin: EdgeInsets.only(left: 24.w),
    alignment: Alignment.centerLeft,
    child: const Text(
      'Description of the group',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xff141C27),
      ),
    ),
  );
}

Widget _descriptionInput(TextEditingController descriptionController) {
  return Container(
    height: 126.h,
    margin: EdgeInsets.only(top: 11.h, left: 24.w, right: 24.w),
    padding: EdgeInsets.only(bottom: 13.h),
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
      color: Color(0xffFFFFFF),
    ),
    child: TextField(
      controller: descriptionController,
      keyboardType: TextInputType.multiline,
      maxLines: 5,
      maxLength: 140,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 342.w,
          ),
        ),
        counterStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xffBFBFBF),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 342.w,
          ),
        ),
        hintText: 'Please enter description of the group!',
        hintStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xff676767),
        ),
      ),
    ),
  );
}

Widget _buildCompletionButton(
    TextEditingController groupNameController,
    TextEditingController capacityController,
    TextEditingController descriptionController) {
  Color buttonColor = const Color(0xffABB2BA);
  if ((groupNameController.text.isNotEmpty) && (capacityController.text.isNotEmpty)
      && (descriptionController.text.isNotEmpty)) {
    buttonColor = const Color(0xff5DC86C);
  } else {
    buttonColor = const Color(0xffABB2BA);
  }
  return Builder(
      builder: (context) {
        return Container(
          margin: EdgeInsets.only(top: 235.h, left: 24.w, right: 24.w),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
              backgroundColor: buttonColor,
              minimumSize: Size(342.w, 54.h),
              elevation: 0,
            ),
            onPressed: () {
              if (buttonColor == const Color(0xff5DC86C)) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GroupPage(),
                  ),
                );
              }
            },
            child: const Text(
              'Completion',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
        );
      }
  );
}