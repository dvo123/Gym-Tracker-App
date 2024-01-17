import 'package:flutter/cupertino.dart';
import 'package:my_first_flutter_project/components/exercise.dart';
import 'package:my_first_flutter_project/date_time/date_time.dart';
import 'package:my_first_flutter_project/user%20data/hive_database.dart';

import '../components/workout.dart';

class WorkoutData extends ChangeNotifier {

  final db = HiveDatabase();

  List<Workout> workoutList = [];

  // if there are workouts already in database, then get that workout list
  void initializeWorkoutList() {
    if(db.previousDateExists()) {
      workoutList = db.readFromDatabase();
    } else {
      db.saveToDatabase(workoutList);
    }
    loadHeatMap();
    calculateExercisePercentage();
  }

  // get the list of work outs
  List<Workout> getWorkoutList() {
    return workoutList;
  }
  // add a workout
  void addWorkout(String name) {
    workoutList.add(Workout(name: name, exercises: []));
    notifyListeners();
    db.saveToDatabase(workoutList);
  }

  // add an exercise to a workout
  void addExercise(String workoutName, String exerciseName, String weight, String reps, String sets) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    relevantWorkout.exercises.add(
      Exercise(
        name: exerciseName,
        weight: weight,
        reps: reps,
        sets: sets
      ),
    );
    notifyListeners();
    db.saveToDatabase(workoutList);
  }

  // check off exercise
  void checkOffExercise(String workoutName, String exerciseName) {
    Exercise relevantExercise =
        getRelevantExercise(workoutName, exerciseName);
    relevantExercise.isCompleted = !relevantExercise.isCompleted;
    print('tapped');
    notifyListeners();
    db.saveToDatabase(workoutList);
    calculateExercisePercentage();
    loadHeatMap();
  }

  //get length of  given workout
  int numberOfExerciseInWorkout(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    return relevantWorkout.exercises.length;
  }

  // return relevant workout object, given workout name
  Workout getRelevantWorkout(String workoutName) {
    Workout relevantWorkout =
        workoutList.firstWhere((workout) => workout.name == workoutName);
    return relevantWorkout;
  }

  // return relevant exercise object, given a exercise name
  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    Exercise relevantExercise =
        relevantWorkout.exercises.firstWhere((exercise) => exercise.name == exerciseName);
    return relevantExercise;
  }

  // get start date
  String getStartDate() {
    return db.getStartDate();
  }

  Map<DateTime, int> heatMapDataSet = {};
  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(getStartDate());

    // count the number of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd =
      convertDateTimeToYYYYMMDD(startDate.add(Duration(days: i)));

      double percent = double.parse(
          db.getMyBox().get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0",
      );

      // year
      int year = startDate.add(Duration(days: i)).year;

      // month
      int month = startDate.add(Duration(days: i)).month;

      // day
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int> {
        DateTime(year, month, day): (10 * percent).toInt(),
      };

      double adjustedPercent = 10 * percent;
      print("Percentage of completed exercises: $adjustedPercent%");

      // add to heat map dataset
      heatMapDataSet.addEntries(percentForEachDay.entries);
    }
  }
  void calculateExercisePercentage() {
    int countCompleted = 0;
    int totalExercises = db.getTotalExercises();

    List<Workout> savedWorkouts = db.readFromDatabase();

    for (var workout in savedWorkouts) {
      for (var exercise in workout.exercises) {
        // Assuming that 1 indicates completion in your database
        if (exercise.isCompleted) {
          countCompleted++;
        }
      }
    }

    String percent = (countCompleted / 10).toStringAsFixed(1);
    db.getMyBox().put("PERCENTAGE_SUMMARY_${todaysDateYYYYMMDD()}", percent);

    print("completed exercises/total of exercises: $countCompleted / $totalExercises");
  }
}
