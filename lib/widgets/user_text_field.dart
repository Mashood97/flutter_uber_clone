import 'package:flutter/material.dart';

class UserTextField extends StatelessWidget {
  final titleLabel;
  final maxLength;
  final icon;
  UserTextField({@required this.titleLabel,@required this.maxLength,@required this.icon});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        maxLength: maxLength,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(

          labelText: titleLabel,
          suffixIcon: Icon(icon,color: Colors.black,),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
