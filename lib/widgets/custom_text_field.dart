import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget{

  final TextEditingController? controller;
  final IconData? data;
  final String? hintText;
  bool? isObsecre = true;
  bool? enabled = true;

  CustomTextField({
    this.controller,
    this.data,
    this.hintText,
    this.isObsecre,
    this.enabled,
  });

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      //padding: const EdgeInsets.all(4.0),
      margin: const EdgeInsets.only(left: 30, top:10, right: 30, bottom:5),
      //margin: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: enabled,
        controller: controller,
        obscureText: isObsecre!,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            data,
            color: Colors.grey.shade500,
          ),
          focusColor: Theme.of(context).primaryColor,
          hintText:hintText,
        ),
      ),
    );
  }
}


