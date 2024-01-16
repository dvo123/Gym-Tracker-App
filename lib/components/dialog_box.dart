import 'package:flutter/material.dart';
import 'package:my_first_flutter_project/components/my_button.dart';

class DialogBox extends StatelessWidget {
  final exerciseController;
  final weightController;
  final repController;
  final setController;
  VoidCallback onSave;
  VoidCallback onCancel;

  DialogBox({
    super.key,
    required this.exerciseController,
    required this.weightController,
    required this.repController,
    required this.setController,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: IntrinsicHeight(
          child: Column(
            children: [
              // get exercise
              TextField(
                controller: exerciseController,
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintText: "exercise",
                ),
              ),

              const SizedBox(height: 20),

              // get weight
              TextField(
                controller: weightController,
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintText: "weight",
                ),
              ),

              const SizedBox(height: 20),

              // get rep
              TextField(
                controller: repController,
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintText: "reps",
                ),
              ),

              const SizedBox(height: 20),

              // get sets
              TextField(
                controller: setController,
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintText: "sets",
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // save button
                  MyButton(text: "Save", onPressed: onSave),
                  const SizedBox(width: 8),
                  // cancel button
                  MyButton(text: "Cancel", onPressed: onCancel),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
