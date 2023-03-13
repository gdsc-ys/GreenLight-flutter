import 'package:flutter/material.dart';

class ManageGroupsView extends StatefulWidget {
  const ManageGroupsView({Key? key}) : super(key: key);

  @override
  State<ManageGroupsView> createState() => _ManageGroupsViewState();
}

class _ManageGroupsViewState extends State<ManageGroupsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Groups',
        ),
      ),
    );
  }
}
