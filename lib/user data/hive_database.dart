import 'package:my_first_flutter_project/date_time/date_time.dart';
import '../components/exercise.dart';
import '../components/workout.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabase {
  // reference our hive box
  final _myBox = Hive.box("workout_database_");

  Box getMyBox() {
    return _myBox;
  }

  // check if there is already data stored, if not, record the start date
  bool previousDateExists() {
    if(_myBox.isEmpty) {
      print("previous data does NOT exist");
      _myBox.put("START_DATE" , todaysDateYYYYMMDD());
      return false;
    } else {
      print("previous data does exist!");
      return true;
    }
}

  // return start date as yyyymmdd
  String getStartDate() {
    return _myBox.get("START_DATE");
  }

  // write data
  void saveToDatabase(List<Workout> workouts) {
    final workoutList = convertObjectToWorkoutList(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);

    if(exerciseCompleted(workouts)) {
      _myBox.put("COMPLETION_STATUS_" + todaysDateYYYYMMDD(), 1);
    } else {
      _myBox.put("COMPLETION_STATUS_" + todaysDateYYYYMMDD(), 0);
    }
    // save into hive
    _myBox.put("WORKOUTS", workoutList);
    _myBox.put("EXERCISES", exerciseList);
  }

  int getTotalExercises() {
    List<Workout> savedWorkouts = readFromDatabase();
    int totalExercises = 0;

    for (var workout in savedWorkouts) {
      totalExercises += workout.exercises.length;
    }

    return totalExercises;
  }

  // read data, and return a list of workouts
  List<Workout> readFromDatabase() {
    List<Workout> mySavedWorkouts =[];

    List<String> workoutNames = _myBox.get("WORKOUTS");
    final exerciseDetails = _myBox.get("EXERCISES");

    // create workout objects
    for(int i = 0; i < workoutNames.length; i++) {
      // each workout can have multiple exercises
      List<Exercise> exercisesInEachWorkout =[];

      for(int j = 0; j < exerciseDetails[i].length; j++) {
        // add each exercise into a list
        exercisesInEachWorkout.add(
          Exercise(
              name: exerciseDetails[i][j][0],
              weight: exerciseDetails[i][j][1],
              reps: exerciseDetails[i][j][2],
              sets: exerciseDetails[i][j][3],
              isCompleted:  exerciseDetails[i][j][4] == "true" ? true : false,
          ),
        );
      }

      // create individual workout
      Workout workout =
          Workout(name: workoutNames[i], exercises: exercisesInEachWorkout);

      // add individual workout to overall list
      mySavedWorkouts.add(workout);
    }
    return mySavedWorkouts;
  }

  // check if any exercises have been done
  bool exerciseCompleted(List<Workout> workouts) {
    for (var workout in workouts) {
      for (var exercise in workout.exercises) {
        if(exercise.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }

  // return completion status of a given date yyyymmdd
  int getCompletionStatus(String yyyymmdd) {
    // return 0 or 1, if null then return 0
    int completionStatus = _myBox.get("COMPLETION_STATUS_" + yyyymmdd) ?? 0;
    return completionStatus;
  }
}

  // converts workout objects into a list -> eg. [ upper body, lower body ]
List<String> convertObjectToWorkoutList(List<Workout> workouts) {
  List <String> workoutList = [

  ];

  for (int i = 0; i < workouts.length; i++) {
    workoutList.add(
      workouts[i].name,
    );
  }
  return workoutList;
}
  // converts the exercises in a exercise object into a list of strings
List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
  List<List<List<String>>> exerciseList = [];

  for (int i = 0; i< workouts.length; i++) {
    List<Exercise> exercisesInWorkout = workouts[i].exercises;

    List<List<String>> individualWorkout = [];

    for (int j = 0; j < exercisesInWorkout.length; j++) {
      List<String> individualExercise = [];

      individualExercise.addAll(
        [
          exercisesInWorkout[j].name,
          exercisesInWorkout[j].weight,
          exercisesInWorkout[j].reps,
          exercisesInWorkout[j].sets,
          exercisesInWorkout[j].isCompleted.toString(),
        ],
      );
      individualWorkout.add(individualExercise);
    }
    exerciseList.add(individualWorkout);
  }
  return exerciseList;
}