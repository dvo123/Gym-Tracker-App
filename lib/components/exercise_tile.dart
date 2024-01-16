import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ExerciseTile extends StatelessWidget {
  final String exerciseName;
  final String weight;
  final String reps;
  final String sets;
  final bool isCompleted;
  void Function(bool?)? onCheckBoxChanged;

  ExerciseTile({
    Key? key,
    required this.exerciseName,
    required this.weight,
    required this.reps,
    required this.sets,
    required this.isCompleted,
    required this.onCheckBoxChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exerciseName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
          subtitle: Row(
            children: [
              Flexible(
                child: Chip(
                  label: Text(
                    "${weight} lbs",
                  ),
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Chip(
                  label: Text(
                    "${reps} reps",
                  ),
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Chip(
                  label: Text(
                    "${sets} sets",
                  ),
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),
          trailing: Checkbox(
            value: isCompleted,
            onChanged: (value) => onCheckBoxChanged!(value),
          ),
        ),
      ),
    );
  }
}
