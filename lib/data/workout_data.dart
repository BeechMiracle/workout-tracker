import 'package:flutter/material.dart';
import 'package:workout_tracker/data/hive_database.dart';
import 'package:workout_tracker/data_time/date_time.dart';
import 'package:workout_tracker/models/exercise.dart';
import 'package:workout_tracker/models/work_out.dart';

class WorkoutData extends ChangeNotifier {
  // database
  final db = HiveDatabase();

  // list of all workouts
  List<Workout> workoutList = [
    // default workout
    Workout(
      name: 'Upper Body',
      exercises: [
        Exercise(
          name: 'Bicep Curls',
          weight: '10',
          reps: '10',
          sets: '3',
        ),
      ],
    ),
    Workout(
      name: 'Lower Body',
      exercises: [
        Exercise(
          name: 'Bicep Curls',
          weight: '10',
          reps: '10',
          sets: '3',
        ),
      ],
    ),
  ];

  // if workout exist in database , get database workout, else return default workout
  void initializeWorkout() {
    if (db.previousDataExist()) {
      workoutList = db.readDatabase();
    } else {
      db.saveToDatabase(workoutList);
    }

    // load heatmap
    loadHeatMap();
  }

  // get the list of workouts
  List<Workout> getWorkoutList() => workoutList;

  // get length of a given workout
  int numberOfExercisesInWorkout(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    return relevantWorkout.exercises.length;
  }

  // add a workout
  void addWorkout(String name) {
    workoutList.add(
      Workout(name: name, exercises: []),
    );

    notifyListeners();
    // save to database
    db.saveToDatabase(workoutList);
  }

  // get relevant workout
  Workout getRelevantWorkout(String workoutName) {
    Workout relevantWorkout =
        workoutList.firstWhere((workout) => workout.name == workoutName);

    return relevantWorkout;
  }

  // get relevant exercise
  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    // find relevant workout
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    // find relevant exercise
    Exercise relevantExercise = relevantWorkout.exercises
        .firstWhere((exercise) => exercise.name == exerciseName);

    return relevantExercise;
  }

  // add an exercise to a workout
  void addExercise(
    String workoutName,
    String exerciseName,
    String weight,
    String reps,
    String sets,
  ) {
    // find the relevant workout
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    relevantWorkout.exercises.add(
      Exercise(
        name: exerciseName,
        weight: weight,
        reps: reps,
        sets: sets,
      ),
    );

    notifyListeners();
    // save to database
    db.saveToDatabase(workoutList);
  }

  // check off exercise
  void checkOffExercise(String workoutName, String exerciseName) {
    // find the relevant workout and relevant exercise in that workout
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);

    // check off boolean to show user has completed the workout
    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    notifyListeners();
    // save to database
    db.saveToDatabase(workoutList);

    // load heat map
    loadHeatMap();
  }

  // get start date
  String getStartDate() {
    return db.getStartDate();
  }

  Map<DateTime, int> dataSets = {};

  // load heat map
  void loadHeatMap() {
    DateTime startDate = createDateTime(getStartDate());

    // count the number of days to load
    int daysBetween = DateTime.now().difference(startDate).inDays;

    for (int i = 0; i < daysBetween + 1; i++) {
      String date = convertDateTime(startDate.add(Duration(days: i)));

      // completion status
      int status = db.getCompletionStatus(date);

      // year
      int year = startDate.add(Duration(days: i)).year;

      // month
      int month = startDate.add(Duration(days: i)).month;

      // day
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): status
      };

      // add to heatmap dataset
      dataSets.addEntries(percentForEachDay.entries);
    }
  }
}
