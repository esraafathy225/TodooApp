import 'package:flutter/material.dart';

class DialogBox extends StatelessWidget {
  final controller;
  VoidCallback onSave;
  VoidCallback onCancel;

  DialogBox(
      {required this.controller, required this.onSave, required this.onCancel});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey.shade900,
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: controller,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              labelText: 'Add a new task',
              labelStyle: TextStyle(color: Colors.white),
              border: _border,
              focusedBorder: _border,
              enabledBorder: _border),
          validator: (value){
            if(value ==null || value.isEmpty){
              return 'Please enter your task';
            }else{
              return null;
            }
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: onCancel,
                child: Text('Cancel'),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: (){
                  if(_formKey.currentState?.validate() == true){
                    onSave();
                  }
                },
                child: Text('Save'),
              ),
            )
          ],
        ),
      ],
    );
  }
}

var _border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: BorderSide(color: Colors.white, width: 2) // Rounded corners
    );
