import 'package:hive_flutter/hive_flutter.dart';
import 'package:workout_tracker/data_time/date_time.dart';
import 'package:workout_tracker/models/exercise.dart';
import 'package:workout_tracker/models/work_out.dart';

class HiveDatabase {
  // reference the hive box
  final _myBox = Hive.box('workout_database3');

  // check if there is already data stored, if not, record the start date
  bool previousDataExist() {
    if (_myBox.isEmpty) {
      print('Previous data does not exist');
      _myBox.put(
        'START_DATE',
        todaysDate(),
      );
      return false;
    } else {
      print('Previous data does exist');
      return true;
    }
  }

  // return start date
  String getStartDate() {
    return _myBox.get('START_DATE');
  }

  // write data
  void saveToDatabase(List<Workout> workouts) {
    // convert workout object into list of strings
    final workoutList = convertWorkoutToList(workouts);
    final exerciseList = convertExercisesToList(workouts);

    if (exerciseCompleted(workouts)) {
      _myBox.put('COMPLETION_STATUS_${todaysDate()}', 1);
    } else {
      _myBox.put('COMPLETION_STATUS_${todaysDate()}', 0);
    }

    // save into hive
    _myBox.put('WORKOUTS', workoutList);
    _myBox.put("EXERCISES", exerciseList);
  }

  // read data
  List<Workout> readDatabase() {
    List<Workout> myWorkouts = [];

    List<String> workoutNames = _myBox.get('WORKOUTS');
    final exerciseDetails = _myBox.get('EXERCISES');

    // create workout objects
    for (int i = 0; i < workoutNames.length; i++) {
      // each workout can have multiple exercises
      List<Exercise> exercises = [];

      for (int j = 0; j < exerciseDetails[i].length; j++) {
        // add each exercise to a list
        exercises.add(
          Exercise(
            name: exerciseDetails[i][j][0],
            weight: exerciseDetails[i][j][1],
            reps: exerciseDetails[i][j][2],
            sets: exerciseDetails[i][j][3],
            isCompleted: exerciseDetails[i][j][4] == 'true' ? true : false,
          ),
        );
      }

      // create individual workout
      Workout workout = Workout(name: workoutNames[i], exercises: exercises);

      // add individual workout to overall list
      myWorkouts.add(workout);
    }

    return myWorkouts;
  }

  // check if any exercise have been done
  bool exerciseCompleted(List<Workout> workouts) {
    // loop through each workout
    for (var workout in workouts) {
      // loop through each exercise in workout
      for (var exercise in workout.exercises) {
        if (exercise.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }

  // return completion status of a given date
  int getCompletionStatus(String date) {
    // return 0 or 1, if null return 0
    int completionStatus = _myBox.get('COMPLETION_STATUS_$date') ?? 0;

    return completionStatus;
  }

  // convert workout object into a list
  List<String> convertWorkoutToList(List<Workout> workouts) {
    List<String> workoutList = [];

    for (int i = 0; i < workouts.length; i++) {
      // in each of the workout, add the name, followed by list of exercises
      workoutList.add(
        workouts[i].name,
      );
    }

    return workoutList;
  }

// convert the exercise in a the workout object into a list of strings
  List<List<List<String>>> convertExercisesToList(List<Workout> workouts) {
    List<List<List<String>>> exerciseList = [];

    // loop through each workout
    for (int i = 0; i < workouts.length; i++) {
      // get exercise from each workout
      List<Exercise> exercises = workouts[i].exercises;

      List<List<String>> individualWorkout = [];

      // loop through each exercise exerciseList
      for (int j = 0; j < exercises.length; j++) {
        List<String> individualExercise = [];
        individualExercise.addAll(
          [
            exercises[j].name,
            exercises[j].weight,
            exercises[j].reps,
            exercises[j].sets,
            exercises[j].isCompleted.toString(),
          ],
        );

        individualWorkout.add(individualExercise);
      }

      exerciseList.add(individualWorkout);
    }

    return exerciseList;
  }
}
