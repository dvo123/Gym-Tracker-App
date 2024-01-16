import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_first_flutter_project/components/exercise_tile.dart';
import 'package:provider/provider.dart';
import '../components/dialog_box.dart';
import '../user data/workout_data.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;

  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}
class _WorkoutPageState extends State<WorkoutPage> {
  final exerciseController = TextEditingController();
  final weightController = TextEditingController();
  final repController = TextEditingController();
  final setController = TextEditingController();

  // check box was tapped
  void onCheckBoxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkOffExercise(workoutName, exerciseName);
  }

  // create new exercise
  void createNewExercise() {
    // show alert dialog
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          exerciseController: exerciseController,
          weightController: weightController,
          repController: repController,
          setController: setController,
          onSave: saveNewExercise,
          onCancel: cancelNewExercise,
        );
      },
    );
  }

  // save new exercise
  void saveNewExercise() {
    // add new exercise info
    String newExerciseName = exerciseController.text;
    String weight = weightController.text;
    String reps = repController.text;
    String sets = setController.text;

    Provider.of<WorkoutData>(context, listen: false).addExercise(
        widget.workoutName,
        newExerciseName,
        weight,
        reps,
        sets,
    );
    Navigator.of(context).pop();
    clear();
  }

  // cancel new exercise
  void cancelNewExercise() {
    Navigator.of(context).pop();
    clear();
  }

  void clear() {
    exerciseController.clear();
    weightController.clear();
    repController.clear();
    setController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text(widget.workoutName),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewExercise,
          backgroundColor: Colors.black,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: ListView.builder(
            itemCount: value.numberOfExerciseInWorkout(widget.workoutName),
            itemBuilder: (context, index) => Slidable(
              endActionPane: ActionPane(
                motion: StretchMotion(),
                children: [
                  // setting option
                  SlidableAction(
                    onPressed: (context) {},
                    backgroundColor: Colors.black,
                    icon: Icons.settings,
                    borderRadius: BorderRadius.circular(12),
                  ),

                  //delete option
                  SlidableAction(
                    onPressed: (context) {},
                    backgroundColor: Colors.red.shade400,
                    icon: Icons.delete,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ],
              ),
              child: ExerciseTile(
                exerciseName: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .name,
                weight: value
                      .getRelevantWorkout(widget.workoutName)
                      .exercises[index]
                      .weight,
                reps: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .reps,
                sets: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .sets,
                isCompleted: value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .isCompleted,
                onCheckBoxChanged: (val) => onCheckBoxChanged(
                    widget.workoutName,
                    value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .name),
              ),
            ),
        ),
      ),
    );
  }
}